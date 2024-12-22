# frozen_string_literal: true

require_relative "lib/with_conditions/version"

Gem::Specification.new do |spec|
  spec.name = "activemodel-with_conditions"
  spec.version = WithConditions::VERSION
  spec.authors = ["Henrik Nyh"]
  spec.email = ["henrik@nyh.se"]

  spec.summary = "Like with_options but merges :if and :unless conditions."
  spec.description = "Like with_options but merges :if and :unless conditions. Convenient for Active Model or Active Record validations and callbacks."
  spec.homepage = "https://github.com/henrik/activemodel-with_conditions"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/henrik/activemodel-with_conditions/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel"
end
