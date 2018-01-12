Pod::Spec.new do |s|
  s.name             = "QuickResponseCode"
  s.version          = "1.1.0"
  s.summary          = "A tiny tiny Quick Response Code (QRCode) for iOS."
  s.homepage         = "https://github.com/Meniny/QuickResponseCode"
  s.license          = 'MIT'
  s.author           = { "Elias Abel" => "Meniny@qq.com" }
  s.source           = { :git => "https://github.com/Meniny/QuickResponseCode.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'QuickResponseCode/*.*'
  s.module_name = 'QuickResponseCode'
  s.public_header_files = 'QuickResponseCode/*.h'
  s.frameworks = 'Foundation', 'UIKit'
end
