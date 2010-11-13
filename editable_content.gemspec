# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{editable_content}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Will Merrell"]
  s.date = %q{2010-11-13}
  s.description = %q{Creates a new class, Editable_Content, which manages content which can be saved in a database and edited by a user.}
  s.email = %q{will@morelandsolutions.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "app/controllers/contents_controller.rb",
     "app/models/ec_content.rb",
     "app/views/contents/edit.html.erb",
     "app/views/layouts/contents.html.erb",
     "lib/editable_content.rb",
     "lib/editable_content/application_helpers.rb",
     "lib/editable_content/controller_helper.rb",
     "lib/editable_content/engine.rb",
     "lib/generators/editable_content_generator.rb"
  ]
  s.homepage = %q{http://github.com/wmerrell/editable_content}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Manages User Editable Content.}
  s.test_files = [
    "test/helper.rb",
     "test/test_editable_content.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<RedCloth>, ["~> 4.2.3"])
      s.add_runtime_dependency(%q<radius>, ["~> 0.6.1"])
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<RedCloth>, ["~> 4.2.3"])
      s.add_dependency(%q<radius>, ["~> 0.6.1"])
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<RedCloth>, ["~> 4.2.3"])
    s.add_dependency(%q<radius>, ["~> 0.6.1"])
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end

