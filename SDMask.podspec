Pod::Spec.new do |s|
  s.name         = "SDMask"
  s.version      = "1.0.1"
  s.summary      = 'A perfect iOS mask view that help you to present custom view.User dont need to care about animations and events.'
  s.homepage     = 'https://github.com/Meterwhite/SDMask'
  s.license      = 'MIT'
  s.author       = { "Meterwhite" => "meterwhite@outlook.com" }
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/Meterwhite/SDMask.git", :tag => s.version}
  s.source_files = 'SDMask/**/*.{h,m}'
end