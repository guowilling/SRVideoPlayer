
Pod::Spec.new do |s|
s.name         = "SRVideoPlayer"
s.version      = "1.0.0"
s.summary      = "AVFoundation based video player, custom UI and easy to extend.(自定义视频播放器)"
s.description  = "Custom play interface. providing play, pause, full-screen and other functions. providing play progress bar, load progress bar etc; Slide left of the screen up or down to adjust the brightness, Slide right of the screen up or down to adjust the sound, Slide the screen left or right to adjust the play progress."
s.homepage     = "https://github.com/guowilling/SRVideoPlayer"
s.license      = "MIT"
s.author       = { "guowilling" => "guowilling90@gmail.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/guowilling/SRVideoPlayer.git", :tag => "#{s.version}" }
s.source_files = "SRVideoPlayer/*.{h,m}"
s.requires_arc = true
s.dependency 'Masonry', '~> 1.0.2'
end
