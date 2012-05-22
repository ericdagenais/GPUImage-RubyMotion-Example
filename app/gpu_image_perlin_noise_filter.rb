class GPUImagePerlinNoiseFilter < GPUImageFilter
  def init
    return nil unless initWithFragmentShaderFromFile("perlin_noise")

    self.scale = 8.0 

    @colorStart = FloatData.new([0.0, 0.0, 0.0, 1.0])
    @colorFinish = FloatData.new([1.0, 1.0, 1.0, 1.0])
    self.setFloatVec4(@colorStart.ptr, forUniform:"colorStart")
    self.setFloatVec4(@colorFinish.ptr, forUniform:"colorFinish") 

    self
  end

  def scale=(s)
    self.setFloat(s, forUniform:"scale")
  end
end
