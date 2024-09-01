# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "lode"
  spec.version = "1.7.0"
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

  spec.required_ruby_version = ">= 3.3", "<= 3.4"
  spec.add_dependency "dry-monads", "~> 1.6"
  spec.add_dependency "refinements", "~> 12.7"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
