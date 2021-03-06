class JGViewController < UIViewController
  def loadView
    @v = GPUImageView.alloc.init
    self.view = @v
    @modes = [:ppf, :perlin, :crazy]
    @mode = 0
    @swipeLeftRecognizer = UISwipeGestureRecognizer.new.initWithTarget(self, action:'handleLeftSwipeFrom:')
    @swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft
    @swipeRightRecognizer = UISwipeGestureRecognizer.new.initWithTarget(self, action:'handleRightSwipeFrom:')
    @swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight
  end

  def viewDidLoad
    super
    @camera = GPUImageVideoCamera.alloc.initWithSessionPreset(AVCaptureSessionPreset640x480, cameraPosition:AVCaptureDevicePositionBack)
    @camera.outputImageOrientation = UIInterfaceOrientationPortrait
    setupFilters
    @camera.startCameraCapture
    self.view.addGestureRecognizer(@swipeLeftRecognizer)
    self.view.addGestureRecognizer(@swipeRightRecognizer)
  end

  def setupFilters
    case @modes[@mode]
    when :ppf
      if @ppf.nil?
        @ppf = GPUImagePolarPixellatePosterizeFilter.alloc.init
      end
      @camera.addTarget(@ppf)
      @filter = @ppf
    when :perlin
      if @blend.nil?
        @blend = GPUImageAlphaBlendFilter.alloc.init
        @perlin = GPUImagePerlinNoiseFilter.alloc.init
        @perlin.addTarget(@blend)
        @blend.mix = 0.5
      end
      @camera.addTarget(@blend)
      @camera.addTarget(@perlin)
      @filter = @blend
    when :crazy
      if @crazy.nil?
        @crazy = GPUImagePixellateCrazyFilter.alloc.init
      end
      @camera.addTarget(@crazy)
      @filter = @crazy
    else
      NSLog("Invalid filter")
    end
    @filter.addTarget(self.view)
  end

  def tearDown
    @camera.removeAllTargets
    @filter.removeAllTargets
  end

  def handleLeftSwipeFrom(recognizer)
    tearDown
    @mode = (@mode += 1) % @modes.count
    setupFilters
  end

  def handleRightSwipeFrom(recognizer)
    tearDown
    @mode = (@mode > 0) ? (@mode -= 1) : (@modes.count-1)
    setupFilters
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
    when :perlin
      @perlin.scale = location.y / self.view.bounds.size.height * 16.0
    when :crazy
      @filter.scale = location.y / self.view.bounds.size.height * 8.0
    end    
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
      rotate = interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown
    else
      rotate = true
    end
    case interfaceOrientation
    when UIInterfaceOrientationLandscapeRight
      interfaceOrientation = UIInterfaceOrientationLandscapeLeft
    end
    @camera.outputImageOrientation = interfaceOrientation unless !rotate or @camera.nil?
    rotate
  end
end
