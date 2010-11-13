require 'rails/generators'
require 'rails/generators/migration'

class EditableContentGenerator < Rails::Generators::Base

  include Rails::Generators::Migration

  MIGRATIONS_FILE = File.join(File.dirname(__FILE__), "..", "..", "generators", "editable_content", "templates", "create_ec_contents.rb")

  class_option :"skip-migration", :type => :boolean, :desc => "Don't generate a migration for the EcContent table"
  class_option :"skip-routes", :type => :boolean, :desc => "Don't generate the routes for Editable Contents"

  def install_routes(*args)
    unless options["skip-routes"]
      route "get  '/contents/edit',   :as => :edit_content"
      route "post '/contents/update', :as => :update_content"
    end
  end

  def copy_files(*args)
    migration_template MIGRATIONS_FILE, "db/migrate/create_ec_contents.rb" unless options["skip-migration"]
  end

  # Taken from ActiveRecord's migration generator
  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

end
