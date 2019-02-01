# Installation

## CocoaPods

You can integrate the SDK directly with CocoaPods by addressing git. For example:


```
target 'NuggAdExample' do
	pod 'NuggAd', git: 'https://ubergit.office.nugg.ad/nuggad-sdk/ios.git', tag: '3.1.0'
end

```

# Configure as a sub-project

## Set as a git Submodule

In terminal, cd to the project root and run

```
git submodule add git@ubergit.office.nugg.ad:nuggad-sdk/ios.git Vendor/NuggAd
```

## Setup in Xcode

1. Locate the `nuggAdLib.xcodeproj` file within the cloned submodule

2. Drag `nuggAdLib.xcodeproj` into your project drawer

3. Select your application's target

4. Go to the *Build Phases* tab

5. Under *Link Binary With Libraries* press **+**

6. Select `libnuggAdlib.a` and click *Add*

7. Select the **Build Settings** tab

8. Search for `Header Search Paths`

9. In the `Header Search Paths` Setting, set it to `$(SRCROOT)/Vendor/NuggAd/nuggAdLib`

10. In the *Build Phases* tab select Target Dependencies and make sure that nuggAdLib is added

11. Under **Link Binary With Libraries** ensure that you have added `AdSupport.framework`


