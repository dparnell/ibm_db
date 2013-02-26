# +----------------------------------------------------------------------+
# |  Licensed Materials - Property of IBM                                |
# |                                                                      |
# | (C) Copyright IBM Corporation 2006, 2007,2008,2009,2010              |
# +----------------------------------------------------------------------+

require 'rubygems'
require 'pathname'

Gem::Specification.new do |spec|
  # Required spec
  spec.name     = 'ibm_db'
  spec.version  = '2.5.9'
  spec.summary  = 'Rails Driver and Adapter for IBM Data Servers: {DB2 on Linux/Unix/Windows, DB2 on zOS, DB2 on i5/OS, Informix (IDS)}'

  # Optional spec
  spec.author = 'IBM'
  spec.email = 'rubyibm-developers@rubyforge.org'
  spec.homepage = 'http://rubyforge.org/projects/rubyibm/'
  spec.rubyforge_project = 'rubyibm'
  spec.required_ruby_version = '>= 1.8.6'
  spec.add_dependency('activerecord', '>= 1.15.1')
  spec.requirements << 'ActiveRecord, at least 1.15.1'

  candidates = Dir.glob("**/*")
  spec.files = candidates.delete_if do |item|
                 item.include?("CVS") ||
                 item.include?("rdoc") ||
                 item.include?("install.rb") ||
                 item.include?("uninstall.rb") ||
                 item.include?("Rakefile") ||
                 item.include?("IBM_DB.gemspec") ||
                 item.include?(".gem") ||
                 item.include?("ibm_db_mswin32.rb")
               end

  if RUBY_PLATFORM =~ /mswin32/ || RUBY_PLATFORM =~ /mingw/
    spec.platform = Gem::Platform::CURRENT
  else
    spec.files = candidates.delete_if { |item| item.include?("lib/mswin32") }
    puts ".. Check for the pre-built IBM_DB driver for this platform: #{RUBY_PLATFORM}"
    # find ibm_db driver path
    drv_path = Pathname.new(File.dirname(__FILE__)) + 'lib'
    puts ".. Locate ibm_db driver path: #{drv_path.realpath}"
    drv_lib = drv_path + 'ibm_db.so'
    if drv_lib.file? #&& (require "#{drv_lib.to_s}") #Commenting condition check as Ruby-1.9 does not recognize files from local directory
      puts ".. ibm_db driver was found:   #{drv_lib.realpath}"
    else
      puts ".. ibm_db driver binary was not found. The driver native extension to be built during install."
      spec.extensions << 'ext/extconf.rb'
    end
  end

  spec.test_file = 'test/ibm_db_test.rb'
  spec.has_rdoc = true
  spec.extra_rdoc_files = ["CHANGES", "README", "MANIFEST"]
end
