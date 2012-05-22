class JGViewController < UIViewController
  def viewDidLoad
    super
    @vc = GPUImageVideoCamera.alloc.initWithSessionPreset(AVCaptureSessionPreset640x480, cameraPosition:AVCaptureDevicePositionBack)
    @vc.outputImageOrientation = UIInterfaceOrientationPortrait
    @ppf = GPUImagePolarPixellatePosterizeFilter.alloc.init
    @vc.addTarget(@ppf)
    v = GPUImageView.alloc.init
    @ppf.addTarget(v)
    self.view = v
    @vc.startCameraCapture
  end

  def touchesBegan(touches, withEvent:event)
    location = touches.anyObject.locationInView(self.view)
    @ppf.pixelSize = CGSizeMake(location.x / self.view.bounds.size.width * 0.5, location.y / self.view.bounds.size.height * 0.5)
  end

  def touchesMoved(touches, withEvent:event)
    location = touches.anyObject.locationInView(self.view)
    @ppf.pixelSize = CGSizeMake(location.x / self.view.bounds.size.width * 0.5, location.y / self.view.bounds.size.height * 0.5)
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
