//
//  SOMLocationManager.swift
//  SOMCore
//
//  Created by Julian Brehm on 2018-07-26.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

/** Manager for location information used by all SOM SDKs. */
public final class SOMLocationManager: NSObject {
    // MARK: public static variables
    public static var shared = SOMLocationManager() // Singleton
    // MARK: Public variables
    public var locationPermissionGranted = false // Indicates if the location permission is granted.
    public var locationUpdateEnabled = false // Indicates if location updates are enabled.
    public var currentLocation: CLLocation!
    public let lifetimeInSeconds = 15.0
    public var logBreadcrumbs: [String] = [String(describing: SOMLocationManager.self)]
    public lazy var locationManager = CLLocationManager() // Initialize it lazy, so only once
    // MARK: Public functions
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationManagerStatus()
    }
    public func setup() {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Singleton created.")
    }
    // MARK: Private functions
    internal func checkLocationManagerStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .restricted:
            self.locationPermissionGranted = false
            self.locationUpdateEnabled = false
            SOMLogger.log(.developer, self.logBreadcrumbs, "Authorization status restricted.")
        case .denied:
            self.locationPermissionGranted = false
            self.locationUpdateEnabled = false
            SOMLogger.log(.developer, self.logBreadcrumbs, "Authorization status denied.")
        case .notDetermined:
            self.locationPermissionGranted = false
            self.locationUpdateEnabled = false
            SOMLogger.log(.developer, self.logBreadcrumbs, "Authorization status >not determined<.")
            self.locationManager.requestWhenInUseAuthorization() // Request location authorization
        case .authorizedAlways:
            self.locationManager.startMonitoringSignificantLocationChanges() // Update location data periodically
            self.locationManager.requestLocation() // Request a location update
            self.locationPermissionGranted = true
            self.locationUpdateEnabled = true
            SOMLogger.log(.developer, self.logBreadcrumbs, "Authorization status >authorized always<.")
        case .authorizedWhenInUse:
            self.locationManager.startMonitoringSignificantLocationChanges() // Update location data periodically
            self.locationManager.requestLocation() // Request a location update
            self.locationPermissionGranted = true
            self.locationUpdateEnabled = true
            SOMLogger.log(.developer, self.logBreadcrumbs, "Authorization status >authorized when in use<.")
        }
    }
    internal func isLocationPermissionGranted() -> Bool {
        return self.locationPermissionGranted
    }
    internal func isLocationUpdateEnabled() -> Bool {
        return self.locationUpdateEnabled
    }
}
extension SOMLocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback >did update locations< triggered.")
        let location = locations.last!
        let eventDate = location.timestamp
        if fabs(eventDate.timeIntervalSinceNow) < self.lifetimeInSeconds {
            self.currentLocation = location
            SOMLogger.log(.developer, self.logBreadcrumbs, "Current location: %@", [location.debugDescription])
        } else {
            SOMLogger.log(.developer, self.logBreadcrumbs, "Callback >did update locations< received an old event.")
        }
    }
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted || status == .notDetermined {
            manager.stopMonitoringSignificantLocationChanges()
            self.currentLocation = nil
            self.locationPermissionGranted = false
            self.locationUpdateEnabled = false
            SOMLogger.log(.developer, self.logBreadcrumbs, "Location authorization status changed to >non granted<.")
        } else {
            manager.startMonitoringSignificantLocationChanges() // Update location data periodically
            self.locationManager.requestLocation() // Request a location update
            self.locationPermissionGranted = true
            self.locationUpdateEnabled = true
            SOMLogger.log(.developer, self.logBreadcrumbs, "Location authorization status changed to >granted<.")
        }
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopMonitoringSignificantLocationChanges()
        self.currentLocation = nil
        self.locationUpdateEnabled = false
        SOMLogger.log(.developer, self.logBreadcrumbs,
                      "Callback >did fail with error<, error: %@.", [error.localizedDescription])
    }
}
