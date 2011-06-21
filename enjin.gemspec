spec = Gem::Specification.new do |s|
  # TODO - set this up to allow rbx 1.0+ and ruby 1.9.2+
  s.required_ruby_version = '~> 1.9.2'
  s.name = 'enjin'
  s.version = '0.0.1'
  s.date = '2011-06-20'
  s.summary = 'An open cloud for any altitude'
  s.homepage = 'http://github.com/wilson/enjin'
  s.description = 'An ongoing project to build a maintainable and fault-tolerant cloud platform.'
  s.has_rdoc = false
  s.authors = ["Wilson Bilkovich"]
  s.email   = ["wilson@supremetyrant.com"]
  s.add_dependency('nats', '~> 0.4.10')
  s.add_dependency('em-http-request', '~> 0.3.0')
  s.add_dependency('goliath', '~> 0.9.1')
  s.add_dependency('bcrypt-ruby', '~> 2.1.4')
  s.add_dependency('ruby-hmac', '~> 0.4.0')
  # TODO
  # s.require_paths = ['lib']
  # s.bindir = 'bin'
  # s.executables = []
  s.files = %w[
    README.md
    LICENSE
  ]
end
