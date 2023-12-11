Pod::Spec.new do |s|
  s.name          = "Shift4"
  s.version       = "1.2.1"
  s.summary       = "iOS SDK for Shift4"
  s.description   = "Framework allows you to easily add Shift4 payments to your mobile apps."
  s.homepage      = "https://github.com/shift4developer/shift4-ios.git"
  s.license       = "MIT"
  s.author        = "shift4"
  s.platform      = :ios, "13.0"
  s.swift_version = "5.0"
  s.source        = {
    :git => "https://github.com/shift4developer/shift4-ios.git",
    :tag => "#{s.version}"
  }
  s.source_files        = "Shift4/Library/**/*.{h,m,swift}"
  s.vendored_frameworks = "Shift4/Shift43DS.xcframework"
  s.resources = 'Shift4/Library/Resources/**/*.{strings,png,ttf,xcassets}'
end
