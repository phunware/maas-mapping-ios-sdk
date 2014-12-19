PWMapKit SDK for iOS
====================

*Version 2.3.0*

PWMapKit is a comprehensive indoor mapping and wayfinding SDK that allows easy integration with Phunware's indoor maps and Location Based Services (LBS). Visit http://maas.phunware.com/ for more details and to sign up.



### Requirements

- MaaS Core v1.3.0 or greater
- iOS 7.0 or greater
- Xcode 6 or greater



### Installation

PWMapKit has a dependency on MaaSCore.framework, which is available here: https://github.com/phunware/maas-core-ios-sdk and PWLocation.framework, which is available here: https://github.com/phunware/maas-location-ios-sdk

It is recommended that you add the MaaS frameworks to the Vendor/Phunware directory, then, add the MaaSCore.framework and PWMapKit.framework to your Xcode project.

The following frameworks are required:
 - `MaaSCore.framework`
 - `PWLocation.framework`

Alternatively you can install PWMapKit using [CocoaPods](http://www.cocoapods.org) by adding the following line to your Podfile:
```
pod PWMapKit
```

---

### Documentation

PWMapKit documentation is included in the the repository's Documents folder as both HTML and as a .docset. You can also find the latest documentation here: http://phunware.github.io/maas-mapping-ios-sdk/



### Sample Application

PWMapKit comes with a sample application ready to use. However, you will need to update the application with your MaaS credentials and location provider information.

1. Update your MaaS credentials and setup the building identifier in `PWMapKitSampleInfo.plist`.
2. Update the localtion provider initializers in `PWViewController.m`


---

### Integration

The primary methods and objects in PWMapKit revolve around creating a map view, displaying annotations, displaying a user's location and navigation.

Review these wiki articles to familiarize yourself with the commonly used operations:

**Routing**
- [Routing Between Points of Interest](https://github.com/phunware/maas-mapping-ios-sdk/wiki/Routing-between-points-of-interest)
- [Routing From Your Current Location](https://github.com/phunware/maas-mapping-ios-sdk/wiki/Routing-From-Your-Current-Location)

**Annotations**
- [Showing Building Annotations](https://github.com/phunware/maas-mapping-ios-sdk/wiki/Showing-Building-Annotations)
- [Implementing Custom Annotations](https://github.com/phunware/maas-mapping-ios-sdk/wiki/Implementing-Custom-Annotations)

**Other**
- [Zoom Workaround: Usage & Limitations](https://github.com/phunware/maas-mapping-ios-sdk/wiki/Zoom-Workaround:-Usage-&-Limitations)
- [Enabling Blue Dot](https://github.com/phunware/maas-mapping-ios-sdk/wiki/Enabling-Blue-Dot)
- [Indoor User Tracking Modes](https://github.com/phunware/maas-mapping-ios-sdk/wiki/Indoor-User-Tracking-Modes)
- [Setting Up Your Map View](https://github.com/phunware/maas-mapping-ios-sdk/wiki/Setting-Up-Your-Map-View)
- [Zoom Levels: What You Need To Know](https://github.com/phunware/maas-mapping-ios-sdk/wiki/Zoom-Levels:-What-You-Need-To-Know)


---

### Attribution

PWMapKit uses the following third-party components. All components are prefixed so you don't have to worry about namespace collisions.

| Component | Description | License |
|:---------:|:-----------:|:-------:|
| [SVPulsingAnnotationView](https://github.com/samvermette/SVPulsingAnnotationView)| A customizable MKUserLocationView replica for your iOS app. | [MIT](https://github.com/samvermette/SVPulsingAnnotationView/blob/master/LICENSE.txt) |
