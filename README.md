# A GPUImage RubyMotion Example

An example to demonstrate the use of [GPUImage][GI] with [RubyMotion][RM]. This is based on the example from the Indie Ambitions blog article [Learning OpenGL with GPUImage][IA].

This needs to be run on a physical iPhone device with a camera to see the results. Running it in the simulator simply results in a black screen. [This video][VI] shows the effect of the image filter. See the blog article for more details.

### Quickstart

        git clone https://github.com/ericdagenais/GPUImage-RubyMotion-Example.git
        cd GPUImage-RubyMotion-Example
        git submodule update  # fetch vendor/GPUImage submodule
        rake patch            # apply patch to vendor/GPUImage git submodule
        rake                  # build and run in simulator to check for errors/exceptions
        vim Rakefile          # edit app.codesign_certificate
        rake device           # deploy to iPhone/iPad

### Caveats

It seems that with the latest version of RubyMotion available at this time (v1.4), at least 2 small patches need to be applied to the GPUImage Objective-C sources to make the example work. The patch file is included (GPUImage_patch.diff) and can be applied with the "rake patch" task in the above instructions.

The following code in gpu_image_polar_pixellate_posterize_filter.rb throws a runtime exception, see below for details and workaround:

        @pixelSizeUniform = self.filterProgram.uniformIndex("pixelSize")
        @centerUniform = self.filterProgram.uniformIndex("center")

The original Objective-C code was:

        pixelSizeUniform = [filterProgram uniformIndex:@"pixelSize"];
        centerUniform = [filterProgram uniformIndex:@"center"];
  
  (filterProgram is defined as a protected instance variable of the superclass GPUImageFilter)

2 workarounds are needed and require patching the GPUImage Objective-C library to use self.filterProgram and self.filterProgram.uniformIndex

1. "filterProgram" is a protected instance variable of GPUImageFilter. Both the ruby syntax @filterProgram and self.filterProgram return nil when using the vanilla GPUImage libray. GPUImageFilter.{h,m} had to be modified to expose a public getter method "filterProgram"

   GPUImageFilter.h:

        - (GLProgram *)filterProgram; // RubyMotion workaround

2. "uniformIndex" defined in GLProgram.h should work as is, but throws a run-time exception:

  GLProgram.h:

        - (GLuint)uniformIndex:(NSString *)uniformName;

  Exception:

        Objective-C stub for message `uniformIndex:' type `I@:@' not precompiled. Make sure you properly link with the framework or library that defines this message
   
  GLProgram.{h,m} had to be modified to insert a method called uniformIndex2 which returned type NSNumber* instead of GLuint:

  GLProgram.h:

        - (NSNumber *)uniformIndex2:(NSString *)uniformName; // RubyMotion workaround

The following code in gpu_image_polar_pixellate_posterize_filter.rb works correctly with the workarounds in place:

        @pixelSizeUniform = self.filterProgram.uniformIndex2("pixelSize").unsignedIntValue
        @centerUniform = self.filterProgram.uniformIndex2("center").unsignedIntValue


[GI]: https://github.com/BradLarson/GPUImage
[RM]: http://www.rubymotion.com/
[IA]: http://indieambitions.com/idevblogaday/learning-opengl-gpuimage/
[VI]: http://www.youtube.com/watch?v=cThYM20wj_M
