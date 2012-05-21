class AppDelegate < UIResponder
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)    
    viewController = JGViewController.alloc.init
    @window.rootViewController = viewController
    @window.makeKeyAndVisible
    true
  end
end
