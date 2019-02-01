Related repositories:
- https://github.com/SevenOneMedia/adtec-app-ios-podspecs
- https://github.com/SevenOneMedia/adtec-app-ios-core
- https://github.com/SevenOneMedia/adtec-app-ios-headerbiddig

# SevenOne Media Mediation SDK for iOS

The SDK consists of custom adapter classes serving as extension of the Google Mobile Ads SDK (GMA SDK). The SDK enables client-side mediation for display ads with custom partner networks of SevenOne Media. Each adapter is responsible for a specific ad network. The adapter classes are dynamically instantiated by the GMA SDK during runtime using their class names. The framework name concatenated with the class name is used for this purpose (e.g. “SOMMediationSDK.SOMYieldprobeAdapter”). The class names must be specified in the corresponding Yield Group on Google AdManager (GAM). A Yield Group contains a list of networks with additional parameter e.g. the above-mentioned class name and additional parameters for each network. Once an adapter is called by the GMA SDK, it is responsible of retrieving and rendering the associated ad for the corresponding ad network. The network list is processed in a descending order. If a network does not deliver an ad, the GMA SDK skips it and continues with the next network on the list. In the current version, adapters for the Amazon, Yieldlab and Smaato ad networks are implemented. For this purpose, the Amazon and Smaato SDK is implemented and deployed with the Mediation SDK. It also delivers an adapter for MoPub using the MoPub SDK.

## Integration

Please use [CocoaPods](https://guides.cocoapods.org/using/getting-started) to integrate the Mediation SDK into your iOS project. Simply add the following line to your project's Podfile:

```gradle
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/SevenOneMedia/adtec-app-ios-podspecs.git'
target 'YourApp' do
    use_frameworks!
    pod 'SOMMediationSDK', 'x.x.x'
end
```
>**Note:** You must add both the CocoaPods `https://github.com/CocoaPods/Specs.git` and the SOM  `https://github.com/SevenOneMedia/adtec-app-ios-podspecs.git` Podspec repository as source to your Podfile.

>**Note:** The SOM SDK and Podspec are hosted on private GIT repositories. Please contact SevenOne Media to get access.

>**Note:** You can update the SDK by replacing the version tag in the Podfile and updating the Pod. Please replace  `x.x.x` with the version tag provided by SevenOne Media.

Run the following command to install or update the Pod: 

```cmd
pod install --repo-update
```

## Dependencies

The SDK is a static framework and has the following dependencies defined in its Pod-Specification: 
- `"SOMCore"`
- `"Google-Mobile-Ads-SDK"`
- `"SmaatoSDK"`
- `"GoogleMobileAdsMediationMoPub"`

By installing the SDK using CocoaPods, the listed SDKs are installed automatically.
