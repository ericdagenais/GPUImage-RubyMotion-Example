$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  app.name = 'GPUImage'
  app.device_family = [:iphone, :ipad]

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
task :vendorclean do
  sh "rm", "-rf", "vendor/build"
end

desc "Apply Patches: GPUImage"
task :patch do
  sh "patch -p1 < GPUImage_patch.diff"
  cd "vendor/GPUImage" do
    sh "git checkout -b RubyMotion"
    sh "git add -u"
    sh "git commit -m 'RubyMotion patch'"
  end
end
