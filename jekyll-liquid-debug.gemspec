require File.expand_path("lib/jekyll-liquid-debug/version", __dir__)

Gem::Specification.new do |s|
  s.required_ruby_version = ">= 2.5.0"
  s.name          = "jekyll-liquid-debug"
  s.version       = VERSION
  s.authors       = ["Xiang Zhong"]
  s.email         = ["zhongxiang117@gmail.com"]
  s.summary       = "Light Weight Jekyll Liquid Template Debug Package"
  s.license       = "MIT"
  s.homepage      = "https://github.com/zhongxiang117/jekyll-liquid-debug"
  s.files         = Dir["bin/*","data/*","lib/**/*", "jekyll-liquid-debug.gemspec", "LICENSE"]
  s.require_paths = ["lib"]

  s.add_dependency("liquid", "~> 4.0.0")
  s.add_dependency("kramdown", "~> 2.3.0")
end
