require 'rubygems'
require 'test/unit'
require 'bundler'
Bundler.setup
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'editable_content'

class Test::Unit::TestCase
end
