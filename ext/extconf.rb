#!/usr/bin/env ruby

# +----------------------------------------------------------------------+
# |  Licensed Materials - Property of IBM                                |
# |                                                                      |
# | (C) Copyright IBM Corporation 2006, 2007,2008                        |
# +----------------------------------------------------------------------+

require 'mkmf'
WIN = RUBY_PLATFORM =~ /mswin/ || RUBY_PLATFORM =~ /mingw/

# use ENV['DB2DIR'] or latest db2 you can find
# (we need to revisit default when db2 10.x comes out)
IBM_DB_INCLUDE = (ENV['IBM_DB_INCLUDE'] or 
          (Dir['/opt/*/db2/*/include'].sort_by {|f| File.basename(f)}).last )
IBM_DB_LIB = (ENV['IBM_DB_LIB'] or
           (Dir['/opt/*/db2/*/lib32'].sort_by {|f| File.basename(f)}).last )
           
dir_config('IBM_DB',IBM_DB_INCLUDE,IBM_DB_LIB)

def crash(str)
  printf(" extconf failure: %s\n", str)
  exit 1
end

if( RUBY_VERSION =~ /1.9/)
  create_header('gil_release_version')
  create_header('unicode_support_version')
end

unless (have_library(WIN ? 'db2cli' : 'db2','SQLConnect') or find_library(WIN ? 'db2cli' : 'db2','SQLConnect', IBM_DB_LIB))
  crash(<<EOL)
Unable to locate DB2 libraries.

Follow the steps below and retry

Step 1: - Install IBM DB2 Universal Database Server/Client

step 2: - Set the environment variables IBM_DB_INCLUDE and IBM_DB_LIB as below 
        
             (assuming bash shell)
        
             export IBM_DB_INCLUDE=DB2HOME/include (eg. /home/db2inst1/sqllib/include or /opt/ibm/db2/v9.5/include)
             export IBM_DB_LIB=DB2HOME/lib     (eg. /home/db2inst1/sqllib/lib or /opt/ibm/db2/V9.5/lib32)

step 3: - Retry gem install
        
EOL
end

alias :libpathflag0 :libpathflag
def libpathflag(libpath)
  libpathflag0 + case Config::CONFIG["arch"]
    when /solaris2/
      libpath[0..-2].map {|path| " -R#{path}"}.join
    when /linux/
      libpath[0..-2].map {|path| " -Wl,-rpath,#{path}"}.join
    else
      ""
  end
end

have_header('gil_release_version')
have_header('unicode_support_version')

create_makefile('ibm_db')
