Pod::Spec.new do |spec|
  spec.name = 'PWMapKit'
  spec.version = '3.16.1'
  spec.license = { :type => 'Copyright', :text => 'Copyright 2009-present Phunware Inc. All rights reserved.' }
  spec.summary = "Phunware's Mapping SDK for use with its Multiscreen-as-a-Service platform"
  spec.homepage = 'https://github.com/phunware/maas-mapping-ios-sdk/'
  spec.author = { 'Phunware, Inc.' => 'https://www.phunware.com' }
  spec.social_media_url = 'https://twitter.com/phunware'

  spec.platform = :ios, '15.5'
  spec.source = { :git => 'https://github.com/phunware/maas-mapping-ios-sdk.git', :tag => "#{spec.version}" }
  spec.documentation_url = 'https://phunware.github.io/maas-mapping-ios-sdk/'
  spec.cocoapods_version = '>= 1.12.0'

  spec.default_subspecs =
    'Core',
    'DeviceIdentity'

  spec.subspec 'Core' do |subspec|
    subspec.dependency 'PWLocation/Core', '~> 3.14.0'
    subspec.dependency 'PINCache', '~> 3.0.4'

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
    subspec.dependency 'PWLocation/DeviceIdentity', '~> 3.14.0'
  end

  spec.subspec 'LimitedDeviceIdentity' do |subspec|
    subspec.dependency 'PWMapKit/Core'
  end
end
