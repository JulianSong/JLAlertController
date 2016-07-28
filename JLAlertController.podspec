Pod::Spec.new do |s|
  s.name             = 'JLAlertController'
  s.version          = '0.1.1'
  s.summary          = 'A alert view.'
  s.description      = <<-DESC
Popover style alert view.
                       DESC
  s.homepage         = 'https://github.com/JulianSong/JLAlertController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'julian.song' => 'geeksong@gmail.com' }
  s.source           = { :git => 'https://github.com/JulianSong/JLAlertController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'JLAlertController/Classes/*'
  s.public_header_files = 'JLAlertController/Classes/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'JLTransitioning'
end
