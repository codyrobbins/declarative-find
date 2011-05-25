Gem::Specification.new do |s|
  s.name     = 'declarative-find'
  s.version  = '1.0'
  s.summary  = 'Find records for Rails controller actions declaratively.'
  s.homepage = 'http://codyrobbins.com/software/declarative-find'
  s.author   = 'Cody Robbins'
  s.email    = 'cody@codyrobbins.com'

  s.post_install_message = '
-------------------------------------------------------------
Follow me on Twitter! http://twitter.com/codyrobbins
-------------------------------------------------------------

'

  s.files = `git ls-files`.split

  s.add_dependency('easier-instance-variable-access')
  s.add_dependency('to-class')
  s.add_dependency('http-error')
end