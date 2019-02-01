Related repositories:
- https://github.com/SevenOneMedia/adtec-app-ios-podspecs
- https://github.com/SevenOneMedia/adtec-app-ios-core
- https://github.com/SevenOneMedia/adtec-app-ios-mediation

# SevenOne Media Headerbidding SDK for iOS

The SDK enables Header Bidding for display ads with SevenOne Media's partner networks. Once initialized, the SDK polls bids from the configured ad networks which must be consumed by the adding them as custom targeting to the display ad requests of the GMA SDK. If the yield of a bid is higher than of a direct-sold inventory, the GAM server will deliver the ad associated with the bid. This might lead to improved display ad revenue. The SDK must be initialized with a config on each app start. On every page load and page reload the SDK must be updated to refresh the bids if needed. Currently the YieldProbe and Amazon networks are implemented.

## Overview

To enable Header Bidding with your app, the following steps must be fullfilled:

1. Integrate the current version of SevenOne Media's Headerbidding SDK using CocoaPods.

2. Initialize the SDK with the Header Bidding config in your main controller on each app start.

3. Update the SDK on every page load and page reload to refresh the bids if needed.

4. Add the bid information for a specific slot to the custom targeting and perform the ad request.

## Integration

Please use [CocoaPods](https://guides.cocoapods.org/using/getting-started) to integrate the Headerbidding SDK with your iOS project. Simply add the following line to your project's Podfile:

```gradle
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/SevenOneMedia/adtec-app-ios-podspecs.git'
target 'YourApp' do
    use_frameworks!
    pod 'SOMHeaderbiddingSDK', 'x.x.x'
end
```
>**Note:** You must add both the CocoaPods `https://github.com/CocoaPods/Specs.git` and the SOM  `https://github.com/SevenOneMedia/adtec-app-ios-podspecs.git` Podspec repository as source to your Podfile.

>**Note:** The SOM SDK and Podspec are hosted on private GIT repositories. Please contact SevenOne Media to get access.

>**Note:** You can update the SDK by replacing the version tag in the Podfile and updating the Pod. Please replace  `x.x.x` with the version tag provided by SevenOne Media.

Run the following command to install or update the Pod: 

```cmd
pod install --repo-update
```

Once integrated, the SDK can be imported in each view controller in which it is to be used:

```swift
import SOMHeaderbiddingSDK
```
## Dependencies

The SDK is a static framework and has the following dependencies defined in its Pod-Specification: 
- `"SOMCore"`

Furthermore, the Amazon DTB SDK is manually delivered as vendored framework:
- `DTBiOSSDK.framework`

By installing the SDK using CocoaPods, the listed SDK is installed automatically.

## Initialization

The SDK must be initialized in your main controller on each app start before retrieving bids. In this step, the configuration of the ad networks is passed to the SDK. This configuration must be extracted from the ad config provided by SevenOne Media and hosted on an external FTP server. Please fetch the config every time the SDK is initialized to always be up-to-date. The Header Bidding configuration is stored under the following path:

> `SOM ad config` > `headerBidding`

Besides this configuration, the SDK must be initialized with the global NPA setting. Please see the GDPR section below for further information.

The SDK can be initialized using a config object of type `Any` or a `String` containing the information extracted from the ad config.

```swift
// Extract the Header Bidding configuration from SOM ad config.
let adConfigData = ... // Binary data received from a network request.
guard let adConfigJson = try? JSONSerialization.jsonObject(with: adConfigData, options: []) else {
    return
}
guard let adConfig = adConfigJson as? [String: Any] else {
    return
}
guard let headerBiddingConfig = adConfig["headerBidding"] as Any? else {
    return
}
// Initialize the SDK
HeaderBiddingSDK.shared.initialize(headerBiddingConfig, nonPersonalizedAdsEnabled: true/false)
```
```swift
let headerBiddingConfigString = "..." // HeaderBidding configuration as Json String.
// Initialize the SDK
HeaderBiddingSDK.shared.initialize(headerBiddingConfigString, nonPersonalizedAdsEnabled: true/false)
```

If needed, the following Boolean variable can be used to check whether the SDK is initialized or not:

```swift
HeaderBiddingSDK.shared.isInitialized
```

## GDPR

Regarding the GDPR, the parameter NPA (**N**on-**P**ersonalised **A**ds) must be passed to the SDK at initialization. In general, you must implement a global toggle in your app allowing the user to opt out from personalised ads (`npa = true`) or to opt in (`npa = false`). See [GDPR](https://sevenonemedia.github.io/adtec-se-docs/docs/app-gdpr.html) for more information about this topic.

The SDK must also be informed every time the NPA value changes, e.g. if the user opts out from personalized ads using the NPA toggle:

```swift
HeaderBiddingSDK.shared.enableNonPersonalisedAds(true/false)
```

## Update

You must update the Headerbidding SDK **on every page load and page reload** to refresh the bids for each ad slot.

```swift
HeaderBiddingSDK.shared.update() // Request a new bid for all configured slots if associated bid is expired.
```

## Ad Request

Before requesting a display ad using the Google Ads SDK, a bid for the specific slot must be retrieved. The SDK will return a dictionary which must be added to the custom targeting property of the DFP ad request associated with the ad slot. The dictionary will be empty if no bid is available for this slot.

To retrieve the bid information, please use the name associated with the ad slot. In general, bids for `banner`-, `rectangle`- and `interstitial`-ads can be requested. However, SevenOne Media will provide you with the configured ad slot names.

```swift
// Retrieve the bid targering using the slot name...
let ypTargeting = HeaderBiddingSDK.shared.getTargeting("banner")
```

```swift
let customTargeting = ... // Existing custom targeting e.g. Nugg.ad parameter.
// Retrieve the bid information as custom targeting.
let ypTargeting = HeaderBiddingSDK.shared.getTargeting("banner") // Retrieve targering for slot name 'banner'.
// Add bid information to the pre-existing custom targeting.
for (key, value) in ypTargeting {
    customTargeting[key] = value
}
// Build a DFP ad request
let request = DFPRequest()
request.customTargeting = customTargeting
// Perform DFP ad request
let banner = DFPBannerView(adSize: self.adSize)
banner.adUnitID = self.adUnitID
banner(request)
```

## Testing

Please contact SevenOne Media to get test slots for each configured network. 

The `SOMLogger` is used for logging purposes.
Each log messages is assigned one of the following log tags: `.debug`, `.developer`, `.developerError`, `.response`, `.request`

The Header Bidding SDK provides an interface to filter the log messages:

```swift
HeaderBiddingSDK.shared.filterLog([.debug])
```

Furthermore, an advanced debug mode can be activated displaying all log messages in the console output.

```swift
HeaderBiddingSDK.shared.enableDebugMode()
```

The log messages can be filtered in the console output by `HeaderBiddingSDK`
