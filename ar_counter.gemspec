# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ar_counter/version"

Gem::Specification.new do |s|
  s.name        = "ar_counter"
  s.version     = ARCounter::VERSION
  s.authors     = ["Rafeequl"]
  s.email       = ["rafeequl@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A simple model to model stats/counter}
  s.description = %q{A simple model to model stats/counter.  It behaves similar to ActiveRecord counter cache but it will put the counter in separate table.}

  s.rubyforge_project = "ar_counter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
