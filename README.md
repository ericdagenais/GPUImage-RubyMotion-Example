# A GPUImage RubyMotion iOS Example

An example to demonstrate the use of [GPUImage][GI] with [RubyMotion][RM]. This is based on the examples from the Indie Ambitions blog articles [Learning OpenGL with GPUImage][IA] and [Perlin Noise on GPU in GPUImage][IA2].

This needs to be run on a physical iPhone or iPad device with a camera to see the results. Running it in the simulator simply results in a black screen. [This video][VI] shows the effect of one of the image filters. See the blog articles for more details. Swipe the screen left or right to change the current filter. Touch the screen to change the filter parameters.

### Quickstart

        git clone https://github.com/ericdagenais/GPUImage-RubyMotion-Example.git
        cd GPUImage-RubyMotion-Example
        git submodule update --init  # fetch vendor/GPUImage submodule
        rake                         # build and run in simulator to check for errors/exceptions
        vim Rakefile                 # edit app.codesign_certificate
        rake device                  # deploy to iPhone/iPad

### Dependencies

* XCode 4.x w/ iOS SDK 5.x
* RubyMotion

[GI]: https://github.com/BradLarson/GPUImage
[RM]: http://www.rubymotion.com/
[IA]: http://indieambitions.com/idevblogaday/learning-opengl-gpuimage/
[IA2]: http://indieambitions.com/idevblogaday/perlin-noise-gpu-gpuimage/
[VI]: http://www.youtube.com/watch?v=cThYM20wj_M
