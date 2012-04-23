$:.unshift File.expand_path('../../lib', __FILE__)

require 'test/unit'
require 'active_record'

begin 
  require 'mysql2'  
  'mysql2'
rescue 
  MissingSourceFile 
end

db_config = { 
  adapter:  "mysql2",
  database: "model_counter",
  username: "root",
  password: "",
  host:     "localhost"
}

ActiveRecord::Base.establish_connection(db_config.merge(:database => "mysql"))
# drop db if exist
ActiveRecord::Base.connection.drop_database(db_config[:database]) rescue nil
# create db
ActiveRecord::Base.connection.create_database(db_config[:database])
ActiveRecord::Base.establish_connection(db_config)
load(File.dirname(__FILE__) + "/schema.rb")

unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end