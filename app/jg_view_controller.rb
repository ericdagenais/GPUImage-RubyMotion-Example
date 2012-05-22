class JGViewController < UIViewController
  def loadView
    @v = GPUImageView.alloc.init
    self.view = @v
    @mode = :ppf
    #@mode = :perlin
  end

  def viewDidLoad
    super
    @vc = GPUImageVideoCamera.alloc.initWithSessionPreset(AVCaptureSessionPreset640x480, cameraPosition:AVCaptureDevicePositionBack)
    @vc.outputImageOrientation = UIInterfaceOrientationPortrait
    case @mode
    when :ppf
      @ppf = GPUImagePolarPixellatePosterizeFilter.alloc.init
      @vc.addTarget(@ppf)
      @ppf.addTarget(@v)
    when :perlin
      @bf = GPUImageAlphaBlendFilter.alloc.init
      @pn = GPUImagePerlinNoiseFilter.alloc.init
      @vc.addTarget(@bf)
      @vc.addTarget(@pn)
      @pn.addTarget(@bf)
      @bf.mix = 0.5
      @bf.addTarget(@v)
    end
    @vc.startCameraCapture
  end

  def touchesBegan(touches, withEvent:event)
    location = touches.anyObject.locationInView(self.view)
    @ppf.pixelSize = CGSizeMake(location.x / self.view.bounds.size.width * 0.5, location.y / self.view.bounds.size.height * 0.5) unless @ppf.nil?
  end

  def touchesMoved(touches, withEvent:event)
    location = touches.anyObject.locationInView(self.view)
    @ppf.pixelSize = CGSizeMake(location.x / self.view.bounds.size.width * 0.5, location.y / self.view.bounds.size.height * 0.5) unless @ppf.nil?
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
      rotate = interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown
    else
      case interfaceOrientation
      when UIInterfaceOrientationLandscapeRight
        interfaceOrientation = UIInterfaceOrientationLandscapeLeft
      end
      rotate = true
    end
    @vc.outputImageOrientation = interfaceOrientation unless !rotate or @vc.nil?
    rotate
  end
end
