class GPUImagePolarPixellatePosterizeFilter < GPUImageFilter
  def init
    kGPUImagePolarPixellatePosterizeFragmentShaderString = <<eos
 varying highp vec2 textureCoordinate;
 uniform highp vec2 center;
 uniform highp vec2 pixelSize;
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     highp vec2 normCoord = 2.0 * textureCoordinate - 1.0;
     highp vec2 normCenter = 2.0 * center - 1.0;
     
     normCoord -= normCenter;
     
     highp float r = length(normCoord); // to polar coords
     highp float phi = atan(normCoord.y, normCoord.x); // to polar coords
     
     r = r - mod(r, pixelSize.x) + 0.03;
     phi = phi - mod(phi, pixelSize.y);
     
     normCoord.x = r * cos(phi);
     normCoord.y = r * sin(phi);
     
     normCoord += normCenter;
     
     mediump vec2 textureCoordinateToUse = normCoord / 2.0 + 0.5;
     mediump vec4 color = texture2D(inputImageTexture, textureCoordinateToUse );
     
     color = color - mod(color, 0.1);
     gl_FragColor = color;
 }
eos
    return nil unless initWithFragmentShaderFromString(kGPUImagePolarPixellatePosterizeFragmentShaderString)

    # The following code thrown a runtime exception, see below for details and workaround:
    #
    # @pixelSizeUniform = self.filterProgram.uniformIndex("pixelSize")
    # @centerUniform = self.filterProgram.uniformIndex("center")
    #

    # 2 workarounds are needed and require patching the GPUImage Objective-C library
    # to use self.filterProgram and self.filterProgram.uniformIndex
    #
    # 1. "filterProgram" is a protected instance variable of GPUImageFilter. Both the ruby syntax
    #    @filterProgram and self.filterProgram return nil when using the vanilla GPUImage libray.
    #    GPUImageFilter.{h,m} had to be modified to expose a public getter method "filterProgram"
    #
    #    GPUImageFilter.h:
    #    - (GLProgram *)filterProgram; // RubyMotion workaround
    #
    # 2. "uniformIndex" defined in GLProgram.h should work as is, but throws a run-time exception:
    #    GLProgram.h:
    #    - (GLuint)uniformIndex:(NSString *)uniformName;
    #    Exception: Objective-C stub for message `uniformIndex:' type `I@:@' not precompiled. Make sure you properly link with the framework or library that defines this message
    #
    #    GLProgram.{h,m} had to be modified to insert a method called uniformIndex2 which returned
    #    type NSNumber* instead of GLuint:
    #    GLProgram.h:
    #    - (NSNumber *)uniformIndex2:(NSString *)uniformName; // RubyMotion workaround

    @pixelSizeUniform = self.filterProgram.uniformIndex2("pixelSize").unsignedIntValue
    @centerUniform = self.filterProgram.uniformIndex2("center").unsignedIntValue

    @pixelSizeData = FloatData.new([0.0,0.0])
    @centerData = FloatData.new([0.0,0.0])

    self.pixelSize = CGSizeMake(0.05, 0.05)
    self.center = CGPointMake(0.5, 0.5)

    self
  end

  def pixelSize=(p)
    @pixelSize = p
    GPUImageOpenGLESContext.useImageProcessingContext
    self.filterProgram.use
    @pixelSizeData.set_data([@pixelSize.width, @pixelSize.height])
    glUniform2fv(@pixelSizeUniform, 1, @pixelSizeData.ptr)
  end

  def center=(c)
    @center = c
    GPUImageOpenGLESContext.useImageProcessingContext
    self.filterProgram.use
    @centerData.set_data([@center.x, @center.y])
    glUniform2fv(@centerUniform, 1, @centerData.ptr)
  end

  def pixelSize
    @pixelSize
  end

  def center
    @center
  end
end
