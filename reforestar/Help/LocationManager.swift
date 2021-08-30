//
//  LocationManager.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 26/06/2021.
//

import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    public let locationManager = CLLocationManager()
    @Published public var coordinates: CLLocation? = nil
    
    override init() {
        super.init()
        self.setupLocationParameters()
    }
    
    func setupLocationParameters(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            self.locationManager.startUpdatingLocation()
            //self.locationManager.requestLocation()
            
        }else{
            print("Location Service is disabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        //print("Found user's location: \(location)", "lat =", location.coordinate.latitude," long = ",location.coordinate.longitude)
        self.coordinates = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func askForUsersLocation(){
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestLocation()
        }else{
            print("Location Service is disabled")
        }
    }
    
}

