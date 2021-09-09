//
//  MapsViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 08/04/2021.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import SwiftyJSON
import SwiftUI

class MapsViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var vertexes: Dictionary<String,Any> = [:]
    var polygons: [MKPolygon] = []
    var all_areas:Dictionary<String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.getAreasInformation()
            self.createPolygonsFromAreas(areas: self.all_areas)
            let overlays : [MKOverlay] = self.polygons
            self.mapView.addOverlays(overlays)
        })
        
        //Request Location Permission to user
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //Update user's location
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        self.mapView.setRegion(MKCoordinateRegion(center: self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 41.15, longitude: -8.61024), latitudinalMeters: 100, longitudinalMeters: 100), animated: true)
        self.mapView.showsCompass = true
        self.mapView.showsScale = true
        self.mapView.showsBuildings = true
        
        self.mapView.layer.cornerRadius = 20.0
        self.mapView.layer.borderColor = Color.dark_green.cgColor
        self.mapView.layer.borderWidth = 4.0
    }
    
    func getAreasInformation() {
        
        self.all_areas = CurrentSession.sharedInstance.areas
        //print("Areas : \(CurrentSession.sharedInstance.areas)")
    }
    
    func createPolygonsFromAreas(areas: Dictionary<String, Any>){
        for area in areas {
            self.polygons.append(self.createPolygon(vertexs: area.value as! NSArray))
        }
    }
    
    func createPolygon(vertexs: NSArray)->MKPolygon{
        var polygon:MKPolygon = MKPolygon()
        var polygonCoordinates:[CLLocationCoordinate2D] = []
        for vertex in vertexs {
            let vertex_dictionary = vertex as! Dictionary<String, Any>
            polygonCoordinates.append(CLLocationCoordinate2D(latitude: vertex_dictionary["latitude"]! as! CLLocationDegrees, longitude: vertex_dictionary["longitude"]! as! CLLocationDegrees))
        }
        polygon = MKPolygon(coordinates: polygonCoordinates, count: polygonCoordinates.count)
        return polygon
    }
    
}

extension MapsViewController{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard(overlay is MKPolygon || overlay is MKCircle) else { return MKOverlayRenderer() }
        if(overlay is MKPolygon){
            let renderer = MKPolygonRenderer.init(polygon: overlay as! MKPolygon)
            renderer.fillColor = self.generateRandomColor().withAlphaComponent(0.4)
            renderer.lineWidth = 2.0
            renderer.strokeColor = renderer.fillColor
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat.random(in: 0...1)
        let greenValue = CGFloat.random(in: 0...1)
        let blueValue = CGFloat.random(in: 0...1)
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        return randomColor
    }
}


/*
 
 func createCircle() -> MKOverlay{
 let coordinates = CLLocationCoordinate2D(latitude: 39.612981, longitude: -8.662311);
 let region = CLCircularRegion(center: coordinates, radius: 5000, identifier: "geofence")
 let overlay = MKCircle(center: coordinates, radius: region.radius)
 return overlay
 }
 
 */
