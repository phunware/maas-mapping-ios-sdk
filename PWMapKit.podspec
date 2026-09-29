Pod::Spec.new do |spec|
  spec.name = 'PWMapKit'
  spec.version = '3.17.0'
  spec.license = { :type => 'Copyright', :text => 'Copyright 2009-present Phunware Inc. All rights reserved.' }
  spec.summary = "Phunware's Mapping SDK for use with its Multiscreen-as-a-Service platform"
  spec.homepage = 'https://github.com/phunware/maas-mapping-ios-sdk/'
  spec.author = { 'Phunware, Inc.' => 'https://www.phunware.com' }
  spec.social_media_url = 'https://twitter.com/phunware'

  spec.platform = :ios, '15.5'
  spec.source = { :git => 'https://github.com/phunware/maas-mapping-ios-sdk.git', :tag => "#{spec.version}" }
  spec.documentation_url = 'https://phunware.github.io/maas-mapping-ios-sdk/'
  spec.cocoapods_version = '>= 1.16.2'

  spec.default_subspecs =
    'Core',
    'DeviceIdentity'

  spec.subspec 'Core' do |subspec|
    subspec.dependency 'PWLocation/Core', '~> 3.15.0'
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
    subspec.dependency 'PWLocation/DeviceIdentity', '~> 3.15.0'
  end

  spec.subspec 'LimitedDeviceIdentity' do |subspec|
    subspec.dependency 'PWMapKit/Core'
  end

  # Frameworks linked with static libraries
  spec.subspec 'CoreStaticLinks' do |subspec|
    subspec.dependency 'PWLocation/CoreStaticLinks', '~> 3.15.0'

    subspec.vendored_frameworks = 'FrameworksStaticLinks/PWMapKit.xcframework'
  end

  spec.subspec 'LimitedDeviceIdentityStaticLinks' do |subspec|
    subspec.dependency 'PWMapKit/CoreStaticLinks'
  end
end
