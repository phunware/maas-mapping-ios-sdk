Pod::Spec.new do |spec|
  spec.name = 'PWMapKit'
  spec.version = '3.15.4'
  spec.license = { :type => 'Copyright', :text => 'Copyright 2009-present Phunware Inc. All rights reserved.' }
  spec.summary = "Phunware's Mapping SDK for use with its Multiscreen-as-a-Service platform"
  spec.homepage = 'https://github.com/phunware/maas-mapping-ios-sdk/'
  spec.author = { 'Phunware, Inc.' => 'https://www.phunware.com' }
  spec.social_media_url = 'https://twitter.com/phunware'
  
  spec.platform = :ios, '15.5'
  spec.source = { :git => "https://github.com/phunware/maas-mapping-ios-sdk.git", :tag => "#{spec.version}" }
  spec.documentation_url = 'https://phunware.github.io/maas-mapping-ios-sdk/'
  
  spec.default_subspecs =
    'Core',
    'DeviceIdentity'

  spec.subspec 'Core' do |subspec|
    subspec.dependency 'PWLocation/Core', '~> 3.13.2'
    subspec.dependency 'TMCache', '~> 2.1.0'

    subspec.vendored_frameworks = 'Frameworks/PWMapKit.xcframework'
    
    subspec.frameworks =
      'CoreGraphics',
      'CoreLocation',
      'CoreServices',
      'CoreTelephony',
      'MapKit',
      'QuartzCore',
      'Security',
      'SystemConfiguration'
  end

  spec.subspec 'DeviceIdentity' do |subspec|
    subspec.dependency 'PWMapKit/Core'
    subspec.dependency 'PWLocation/DeviceIdentity', '~> 3.13.2'
  end

  spec.subspec 'LimitedDeviceIdentity' do |subspec|
    subspec.dependency 'PWMapKit/Core'
  end
end
