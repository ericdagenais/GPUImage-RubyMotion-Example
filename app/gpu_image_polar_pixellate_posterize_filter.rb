class GPUImagePolarPixellatePosterizeFilter < GPUImageFilter
  def init
    return nil unless initWithFragmentShaderFromFile("polar_pixellate_posterize")

    self.pixelSize = CGSizeMake(0.03, 0.03)
    self.center = CGPointMake(0.5, 0.5)
    
    self
  end

  def pixelSize=(p)
    self.setSize(p, forUniform:"pixelSize")
  end

  def center=(c)
    self.setPoint(c, forUniform:"center")    
  end
end
