Pod::Spec.new do |s|
  s.name         = "PWMapKit"
  s.version      = "3.11.0"
  s.summary      = "Phunware's Mapping SDK for use with its Multiscreen-as-a-Service platform"
  s.homepage     = "http://phunware.github.io/maas-mapping-ios-sdk/"
  s.author       = { 'Phunware, Inc.' => 'http://www.phunware.com' }
  s.social_media_url = 'https://twitter.com/Phunware'

  s.platform     = :ios, '10.0'
  s.source       = { :git => "https://github.com/phunware/maas-mapping-ios-sdk.git", :tag => "v#{s.version}" }
  s.license      = { :type => 'Copyright', :text => 'Copyright 2009-present Phunware Inc. All rights reserved.' }

  s.ios.vendored_frameworks = 'Frameworks/PWMapKit.xcframework'
  
  s.default_subspec = 'all-frameworks'

  s.subspec 'all-frameworks' do |sub|
    sub.dependency 'PWLocation', '~> 3.10.0'
  end

  s.subspec 'LimitedDeviceIdentity' do |sub|
    sub.ios.vendored_frameworks = 'Frameworks/PWMapKit.xcframework'
    sub.dependency 'PWLocation/LimitedDeviceIdentity', '~> 3.10.0'
  end

  s.ios.frameworks = 'Security', 'CoreGraphics', 'QuartzCore', 'SystemConfiguration', 'MobileCoreServices', 'CoreTelephony', 'CoreLocation', 'MapKit'
  s.requires_arc = true
end
