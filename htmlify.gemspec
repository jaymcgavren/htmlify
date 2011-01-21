# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "htmlify/version"

Gem::Specification.new do |s|
  s.name        = "htmlify"
  s.version     = HTMLify::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jay McGavren"]
  s.email       = ["jay@mcgavren.com"]
  s.homepage    = "http://github.com/jaymcgavren/htmlify"
  s.summary     = %q{A server that allows multiple users to view and program a shared Ruby-Processing sketch.}
  s.description = %q{A server that allows multiple users to view and program a shared Ruby-Processing sketch.}
  s.extra_rdoc_files = ["README.textile", "LICENSE"]
  
  s.rubyforge_project = "htmlify"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fuubar'
end
