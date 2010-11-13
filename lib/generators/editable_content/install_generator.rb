require 'rails/generators'
require 'rails/generators/active_record'
require 'rails/generators/migration'

module EditableContent
  module Generators
#    class ContentGenerator < Rails::Generators::Base
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      #source_root File.expand_path("../templates", __FILE__)

      def self.source_root
         @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end

      desc "Run this generator to create the EcContent Table"
      # ...
      # Implement the required interface for Rails::Generators::Migration.
      # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def create_migration_file
        migration_template 'migration.rb', 'db/migrate/create_ec_contents.rb'
      end
    end
  end
end
