class GPUImagePixellateCrazyFilter < GPUImageFilter
  def init
    return nil unless initWithFragmentShaderFromFile("pixellate_crazy")

    self.fractionalWidthOfAPixel = 0.05
    self.scale = 4.0

    self
  end

  def fractionalWidthOfAPixel=(w)
    self.setFloat(w, forUniform:"fractionalWidthOfPixel")
  end

  def scale=(s)
    self.setFloat(s, forUniform:"scale")
  end
end
