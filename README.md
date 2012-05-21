
An example to demonstrate the use of [GI][GPUImage] with [RubyMotion][RM]. This is based on the example from the Indie Ambitions blog article [Learning OpenGL with GPUImage][IA].

Caveats:
It seems that with the latest version of RubyMotion available at this time (v1.4), at least 2 small patches need to be applied to the GPUImage Objective-C sources to make the example work. This repository includes the patched GPUImage sources under vendor/GPUImage and the patch file is also included (GPUImage_patch.diff).

The following code thrown a runtime exception, see below for details and workaround:
  @pixelSizeUniform = self.filterProgram.uniformIndex("pixelSize")
  centerUniform = self.filterProgram.uniformIndex("center")

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

[GI]: https://github.com/BradLarson/GPUImage
[RM]: http://www.rubymotion.com/
[IA]: http://indieambitions.com/idevblogaday/learning-opengl-gpuimage/
