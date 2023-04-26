//
//  LocationManager.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/14/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Foundation
import MapKit
import Combine
import NisumNetwork
//  MARK: - Class
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    //  MARK: - Properties
    private var locationManager: CLLocationManager
    let objectWillChange = PassthroughSubject<Void, Never>()
    var locationUpdated : (() -> ()) = {}

    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var location: CLLocation? {
       willSet { objectWillChange.send() }
     }

    //  MARK: - Life Cycle
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private(set) var currentPlacemark : CLPlacemark! {
        didSet{
            self.locationUpdated()
        }
    }
        
    //  MARK: - Helper Methods
    func requestAuthorisation(always: Bool = false) {
        if always {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func fetchCurrentPlacemark(from location: CLLocation?) {
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placeMark = placemarks?.first {
                self.currentPlacemark = placeMark
            }
        }
    }
    
    //  MARK: - Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        print(self._authorizationStatus.projectedValue)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        if let currentLocation = manager.location {
            fetchCurrentPlacemark(from: currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        fetchCurrentPlacemark(from: location)
    }
}
