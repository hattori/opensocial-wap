# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "opensocial-wap/version"

Gem::Specification.new do |s|
  s.name        = "opensocial-wap"
  s.version     = OpensocialWap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Fumitada Hattori"]
  s.email       = ["hattori@banana-systems.com"]
  s.homepage    = "http://www.banana-systems.com"
  s.summary     = %q{opensocial wap extension}
  s.description = %q{opensocial wap extension}

  s.rubyforge_project = "opensocial-wap"

  s.add_dependency 'rack'
  s.add_dependency 'oauth'
  s.add_development_dependency "rspec", ">=2.5.0"
  s.add_development_dependency "rspec-rails", ">=2.5.0" 
  s.add_development_dependency "rcov"
  s.add_development_dependency "rails", ">=3.0.0"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "capybara"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
