require 'rails'
require 'radius'
require 'redcloth'
require 'editable_content/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
require 'editable_content/controller_helper'
require 'editable_content/application_helpers'

module EditableContent
end
