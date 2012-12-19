$:.unshift("/Library/RubyMotion/lib")
require 'rubygems'
require 'motion/project'

Motion::Project::App.setup do |app|
  app.name = 'GPUImage'
  app.device_family = [:iphone, :ipad]

  app.deployment_target = '5.1'
  
  app.vendor_project('vendor/GPUImage/framework', :xcode,
      :target => 'GPUImage',
      :headers_dir => 'Source')
  app.frameworks << 'OpenGLES'
  app.frameworks << 'QuartzCore'
  app.frameworks << 'CoreVideo'
  app.frameworks << 'CoreMedia'
  app.frameworks << 'AVFoundation'

  app.codesign_certificate = 'Eric Dagenais (9P3GB8C8WW)'
end

desc "Clean the vendor build folder"
task :vendorclean => [:clean] do
  sh "rm", "-rf", "vendor/build"
end
