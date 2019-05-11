require 'active_record'

# Initialize the database connection
db_config       = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(db_config)

# Require all files for the project
Dir[File.join(__dir__, "/models/*.rb")].each {|file| require file }
Dir[File.join(__dir__, "/lib/*.rb")].each {|file| require file }
