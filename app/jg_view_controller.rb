class JGViewController < UIViewController
  def loadView
    @v = GPUImageView.alloc.init
    self.view = @v
    @modes = [:ppf, :perlin, :crazy]
    @mode = 2
    @swipeRecognizer = UISwipeGestureRecognizer.new.initWithTarget(self, action:'handleSwipeFrom:')
    @swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight
  end

  def viewDidLoad
    super
    @camera = GPUImageVideoCamera.alloc.initWithSessionPreset(AVCaptureSessionPreset640x480, cameraPosition:AVCaptureDevicePositionBack)
    @camera.outputImageOrientation = UIInterfaceOrientationPortrait
    setupFilters
    @filter.addTarget(@v)
    @camera.startCameraCapture
    self.view.addGestureRecognizer(@swipeRecognizer)
  end

  def setupFilters
    case @modes[@mode]
    when :ppf
      @filter = GPUImagePolarPixellatePosterizeFilter.alloc.init
      @camera.addTarget(@filter)
    when :perlin
      @filter = GPUImageAlphaBlendFilter.alloc.init
      @perlin = GPUImagePerlinNoiseFilter.alloc.init
      @camera.addTarget(@filter)
      @camera.addTarget(@perlin)
      @perlin.addTarget(@filter)
      @filter.mix = 0.5
    when :crazy
      @filter = GPUImagePixellateCrazyFilter.alloc.init
      @camera.addTarget(@filter)
    end
  end

  def handleSwipeFrom(recognizer)
    NSLog("swipe")
  end

  def touchesBegan(touches, withEvent:event)
    handleTouch(touches)
  end

  def touchesMoved(touches, withEvent:event)
    handleTouch(touches)
  end

  def handleTouch(touches)
    location = touches.anyObject.locationInView(self.view)
    case @modes[@mode]
    when :ppf
      @filter.pixelSize = CGSizeMake(location.x / self.view.bounds.size.width * 0.5, location.y / self.view.bounds.size.height * 0.5)
    when :crazy
      @filter.scale = location.y / self.view.bounds.size.height * 8.0
    end    
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
    @camera.outputImageOrientation = interfaceOrientation unless !rotate or @camera.nil?
    rotate
  end
end
