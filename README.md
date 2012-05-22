# A GPUImage RubyMotion iOS Example

An example to demonstrate the use of [GPUImage][GI] with [RubyMotion][RM]. This is based on the examples from the Indie Ambitions blog articles [Learning OpenGL with GPUImage][IA] and [Perlin Noise on GPU in GPUImage][IA2].

This needs to be run on a physical iPhone or iPad device with a camera to see the results. Running it in the simulator simply results in a black screen. [This video][VI] shows the effect of the image filter. See the blog article for more details. Swipe the screen left or right to change the current filter. Touch the screen to change the filter parameters.

### Quickstart

        git clone https://github.com/ericdagenais/GPUImage-RubyMotion-Example.git
        cd GPUImage-RubyMotion-Example
        git submodule init    # init vendor/GPUImage submodule
        git submodule update  # fetch vendor/GPUImage submodule
        rake                  # build and run in simulator to check for errors/exceptions
        vim Rakefile          # edit app.codesign_certificate
        rake device           # deploy to iPhone/iPad

### Dependencies

* XCode 4.x w/ iOS SDK 5.x
* RubyMotion

### Caveats

It seems that with the latest version of RubyMotion available at this time (v1.5), 2 small modifications need to be made to the GPUImage Objective-C sources to make the example work. The patch file is included (GPUImage_patch.diff).

#### RubyMotion v1.5 Limitations

* Protected Objective-C instance variables in a base class cannot be accessed from Ruby classes that derive from that class

* Certain Objective-C methods in vendor libraries cannot be called. For example, I could not call a public method that returned type "GLuint". Changing the return type to "unsigned int" did not help either. However, returning an object "NSNumber *" did allow me to successfully call the method from Ruby

2012-05-21: I was informed by Laurent that the 2nd issue would be fixed. He mentioned that he'll also think about the best way to expose Objective-C ivars in Ruby as the issue is a limitation of the RubyMotion/MacRuby runtime

### Details

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

        @pixelSizeUniform = self.filterProgram.uniformIndex2("pixelSize")
        @centerUniform = self.filterProgram.uniformIndex2("center")


[GI]: https://github.com/BradLarson/GPUImage
[RM]: http://www.rubymotion.com/
[IA]: http://indieambitions.com/idevblogaday/learning-opengl-gpuimage/
[IA2]: http://indieambitions.com/idevblogaday/perlin-noise-gpu-gpuimage/
[VI]: http://www.youtube.com/watch?v=cThYM20wj_M
