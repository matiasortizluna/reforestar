//
//  AugmentedRealityViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 25/05/2021.
//

import UIKit
import SwiftUI
import RealityKit
import CoreLocation
import ARKit

class AugmentedRealityViewController: UIViewController, CLLocationManagerDelegate {

    let contentView = UIHostingController(rootView: ContentView())
    
    let locationManager = CLLocationManager()
    public var user_longitude = ""
    public var user_latitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //self.locationManager.startUpdatingLocation()
            self.locationManager.requestLocation()
        }else{
            print("Location Serice is disabled")
        }
        
        //Add AR view with customed AR interface
        addChild(contentView)
        view.addSubview(contentView.view)
        setupConstraints()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)", "lat =", location.coordinate.latitude," long = ",location.coordinate.longitude)
            self.user_latitude = "My Lat:" + String(location.coordinate.latitude)
            self.user_longitude = "My Long:" + String(location.coordinate.longitude)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to find user's location: \(error.localizedDescription)")
      }
    
    func setupConstraints(){
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}
