$:.unshift(File.dirname(__FILE__) + '/../../lib')
$:.unshift(File.dirname(__FILE__) + '/../../../activesupport/lib')

require 'config'

require 'rubygems'
require 'test/unit'
require 'stringio'

require 'active_record'
require 'active_record/test_case'
require 'active_record/fixtures'
require 'connection'

require 'cases/repair_helper'

# Show backtraces for deprecated behavior for quicker cleanup.
ActiveSupport::Deprecation.debug = true

# Quote "type" if it's a reserved word for the current connection.
QUOTED_TYPE = ActiveRecord::Base.connection.quote_column_name('type')

def current_adapter?(*types)
  types.any? do |type|
    ActiveRecord::ConnectionAdapters.const_defined?(type) &&
      ActiveRecord::Base.connection.is_a?(ActiveRecord::ConnectionAdapters.const_get(type))
  end
end

ActiveRecord::Base.connection.class.class_eval do
  IGNORED_SQL = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SAVEPOINT/, /^ROLLBACK TO SAVEPOINT/, /^RELEASE SAVEPOINT/, /SHOW FIELDS/]

  def execute_with_query_record(sql, name = nil, &block)
    $queries_executed ||= []
    $queries_executed << sql unless IGNORED_SQL.any? { |r| sql =~ r }
    execute_without_query_record(sql, name, &block)
  end

  def execute_prepared_stmt_with_query_record(pstmt, param_array = nil)
    $queries_executed ||= []
    $queries_executed << "#{@prepared_sql} + #{param_array}" unless IGNORED_SQL.any? { |r| @prepared_sql =~ r }
    execute_prepared_stmt_without_query_record(pstmt, param_array)
  end

  alias_method_chain :execute, :query_record
  alias_method_chain :execute_prepared_stmt, :query_record
end

# Make with_scope public for tests
class << ActiveRecord::Base
  public :with_scope, :with_exclusive_scope
end

unless ENV['FIXTURE_DEBUG']
  module ActiveRecord::TestFixtures::ClassMethods
    def try_to_load_dependency_with_silence(*args)
      ActiveRecord::Base.logger.silence { try_to_load_dependency_without_silence(*args)}
    end

    alias_method_chain :try_to_load_dependency, :silence
  end
end

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  include ActiveRecord::Testing::RepairHelper

  self.fixture_path = FIXTURES_ROOT
  self.use_instantiated_fixtures  = false
  self.use_transactional_fixtures = true

  def create_fixtures(*table_names, &block)
    Fixtures.create_fixtures(ActiveSupport::TestCase.fixture_path, table_names, {}, &block)
  end
end
