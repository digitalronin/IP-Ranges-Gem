# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ip-ranges"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Salgado"]
  s.date = "2014-08-03"
  s.email = "david@digitalronin.com"
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["Gemfile", "Gemfile.lock", "Rakefile", "README.markdown", "spec/ip-ranges", "spec/ip-ranges/ip_spec.rb", "spec/ip-ranges/range_spec.rb", "spec/ip_ranges_spec.rb", "spec/spec_helper.rb", "lib/ip-ranges", "lib/ip-ranges/ip.rb", "lib/ip-ranges/range.rb", "lib/ip-ranges.rb"]
  s.homepage = "https://digitalronin.github.io/2011/09/10/ip-ranges-gem/"
  s.rdoc_options = ["--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Compare and manipulate ranges of IP numbers"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<netaddr>, ["~> 1.5.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
    else
      s.add_dependency(%q<netaddr>, ["~> 1.5.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
    end
  else
    s.add_dependency(%q<netaddr>, ["~> 1.5.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
  end
end