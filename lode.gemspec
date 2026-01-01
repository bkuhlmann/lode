# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "lode"
  spec.version = "2.6.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/lode"
  spec.summary = "A monadic store of marshaled objects."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/lode/issues",
    "changelog_uri" => "https://alchemists.io/projects/lode/versions",
    "homepage_uri" => "https://alchemists.io/projects/lode",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Lode",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/lode"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = ">= 4.0"
  spec.add_dependency "dry-monads", "~> 1.9"
  spec.add_dependency "pstore", "~> 0.2"
  spec.add_dependency "refinements", "~> 14.0"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
