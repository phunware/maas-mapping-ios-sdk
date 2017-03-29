Pod::Spec.new do |s|
  s.name         = "PWMapKit"
  s.version      = "3.1.1"
  s.summary      = "Phunware Mapping SDK"
  s.homepage     = "http://phunware.github.io/maas-mapping-ios-sdk/"
  s.author       = { 'Phunware, Inc.' => 'http://www.phunware.com' }
  s.social_media_url = 'https://twitter.com/Phunware'

  s.platform     = :ios, '9.0'
  s.source       = { :git => "https://github.com/phunware/maas-mapping-ios-sdk.git", :tag => "v3.1.1" }
  s.license      = { :type => 'Copyright', :text => 'Copyright 2015 by Phunware Inc. All rights reserved.' }

  s.ios.vendored_frameworks = 'Framework/PWMapKit.framework'
  s.ios.dependency 'PWLocation'

  s.ios.frameworks = 'Security', 'CoreGraphics', 'QuartzCore', 'SystemConfiguration', 'MobileCoreServices', 'CoreTelephony', 'CoreLocation', 'MapKit'
  s.requires_arc = true
end