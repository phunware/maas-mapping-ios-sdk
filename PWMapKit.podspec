Pod::Spec.new do |s|
  s.name         = "PWMapKit"
  s.version      = "3.8.2"
  s.summary      = "Phunware Mapping SDK"
  s.homepage     = "http://phunware.github.io/maas-mapping-ios-sdk/"
  s.author       = { 'Phunware, Inc.' => 'http://www.phunware.com' }
  s.social_media_url = 'https://twitter.com/Phunware'

  s.platform     = :ios, '10.0'
  s.source       = { :git => "https://github.com/phunware/maas-mapping-ios-sdk.git", :tag => "v3.8.2" }
  s.license      = { :type => 'Copyright', :text => 'Copyright 2015 by Phunware Inc. All rights reserved.' }

  s.ios.vendored_frameworks = 'Framework/PWMapKit.framework'
  
  s.default_subspec = 'all-frameworks'

  s.subspec 'all-frameworks' do |sub|
    sub.dependency 'PWLocation', '~> 3.8.0'
  end

  s.subspec 'NoAds' do |sub|
    sub.dependency 'PWLocation/NoAds', '~> 3.8.0'
  end

  s.ios.frameworks = 'Security', 'CoreGraphics', 'QuartzCore', 'SystemConfiguration', 'MobileCoreServices', 'CoreTelephony', 'CoreLocation', 'MapKit'
  s.requires_arc = true
end
