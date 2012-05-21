$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'GPUImage'
  app.vendor_project('vendor/GPUImage', :xcode,
      :target => 'GPUImage',
      :headers_dir => 'Source')
  app.frameworks << 'OpenGLES'
  app.frameworks << 'QuartzCore'
  app.frameworks << 'CoreVideo'
  app.frameworks << 'CoreMedia'
  app.frameworks << 'AVFoundation'
end
