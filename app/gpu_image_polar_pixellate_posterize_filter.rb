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

    #
    # The following code throws a runtime exception, see README.md for details:
    #
    # @pixelSizeUniform = self.filterProgram.uniformIndex("pixelSize")
    # @centerUniform = self.filterProgram.uniformIndex("center")
    #
    @pixelSizeUniform = self.filterProgram.uniformIndex2("pixelSize")
    @centerUniform = self.filterProgram.uniformIndex2("center")

    @pixelSizeData = FloatData.new([0.0,0.0])
    @centerData = FloatData.new([0.0,0.0])

    self.pixelSize = CGSizeMake(0.03, 0.03)
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
end
