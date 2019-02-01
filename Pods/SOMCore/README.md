Related repositories:
- https://github.com/SevenOneMedia/adtec-app-ios-podspecs
- https://github.com/SevenOneMedia/adtec-app-ios-mediation
- https://github.com/SevenOneMedia/adtec-app-ios-headerbiddig

# SevenOne Media - Public Core Classes for iOS SDKs

Each SDK developed by SevenOne Media implements the SOMCore library. It contains general features and functionalities.

It consists of the following public classes:

- `SOMLogger` A public logger that enables various log granularities.
- `SOMEnums` This public class consists of global enums (e.g. ad types).
- `SOMStructs` This public class contails global structs.
- `SOMShared` This pubic class consists of static variables that are globally accessible and maintained.
- `SOMLocationManager` A simple singleton class that provides the current user location (latitude/longuitude).
- `SOMConnectivityManager` A simple singleton class that provides the current connection type (e.g. WiFi).
- `SOMMediationAdapter` Root mediation custom adapter class for SOM adapter.
