$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'devise_invalidatable/version'

Gem::Specification.new do |s|
  s.name = 'h4-devise_invalidatable'
  s.version = DeviseInvalidatable::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.licenses = ['MIT']
  s.summary = 'Adds the ability to invalidate a session with Devise'
  s.email = 'mdadki@gmail.com'
  s.homepage = 'https://github.com/TetrationAnalytics/devise_invalidatable'
  s.description = 'Adds the ability to invalidate a session with Devise'
  s.authors = ['Michael Adkins', 'Michael Watts']

  s.files = Dir['lib/**/*.rb']
  s.require_paths = ['lib']

  s.add_runtime_dependency 'devise'
  s.add_runtime_dependency 'rails'
end
