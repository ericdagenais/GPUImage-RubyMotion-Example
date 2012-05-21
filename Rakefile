$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  app.name = 'GPUImage'
  app.device_family = [:iphone, :ipad]

  app.vendor_project('vendor/GPUImage', :xcode,
      :target => 'GPUImage',
      :headers_dir => 'Source')
  app.frameworks << 'OpenGLES'
  app.frameworks << 'QuartzCore'
  app.frameworks << 'CoreVideo'
  app.frameworks << 'CoreMedia'
  app.frameworks << 'AVFoundation'

  app.codesign_certificate = 'Eric Dagenais (9P3GB8C8WW)'
end
