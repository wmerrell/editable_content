require 'rails' if defined?(Rails) && Rails::VERSION::MAJOR == 3
require 'action_controller'
require 'action_view'

require 'radius'
require 'redcloth'

require 'editable_content/engine'
require 'editable_content/controller_helper'
require 'editable_content/view_helpers'

module EditableContent
end
