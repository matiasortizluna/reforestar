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
    
    var areas_user: [String:AnyObject] = [:]
    var vertexes: Dictionary<String,Any> = [:]
    var polygons: [MKPolygon] = []
    var areas_allowed:Dictionary<String, Dictionary<String, Any>> = [:]
    
    
    let areasContentView = UIHostingController(rootView: AreasContentView())
    
    
    func setupConstraints(){
        areasContentView.view.translatesAutoresizingMaskIntoConstraints = false
        areasContentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        areasContentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        areasContentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        areasContentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            //Add AR view with customed AR interface
            self.addChild(self.areasContentView)
            self.view.addSubview(self.areasContentView.view)
            self.setupConstraints()
            
        })
        
        /*
        getAreasInformation() { [weak self] result in
            self?.areas_allowed = result
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Code you want to be delayed
            
            self.createPolygonsFromAreas(areas: self.areas_allowed)
            print(self.polygons)
            
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
 */
    }
    
    func getAreasInformation(completion: @escaping (Dictionary<String, Dictionary<String, Any>>) -> ()) {
        let ref = Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let areas_ref = ref.child("areas")
        
        let areas_database = areas_ref.observe(.value, with: {snapshot in
            guard let areas = snapshot.value as? Dictionary<String, Dictionary<String, Any>> else {
                        print("Error in getting information about the Trees")
                        return
                    }
            
            var areas_default: Dictionary<String, Dictionary<String, Any>> = [:]
            var default_area: Bool = false
            for area in areas{
                default_area = area.value["default"] as! Bool
            
                if (default_area == true){
                    areas_default[area.key] = area.value
                }
            }
            completion(areas_default)
        })
    }
    
    func createPolygonsFromAreas(areas: Dictionary<String, Dictionary<String, Any>>){
        for area in areas {
            self.polygons.append(self.createPolygon(vertexs: area.value["vertexs"] as! [AnyObject]))
        }
    }
    
    func createPolygon(vertexs: [AnyObject])->MKPolygon{
        var polygon:MKPolygon = MKPolygon()

        if (!vertexs.isEmpty){
            var polygonCoordinates:[CLLocationCoordinate2D] = []
            for vertex in vertexs {
                
                polygonCoordinates.append(CLLocationCoordinate2D(latitude: vertex["latitude"]! as! CLLocationDegrees, longitude: vertex["longitude"]! as! CLLocationDegrees))
            }
            polygon = MKPolygon(coordinates: polygonCoordinates, count: polygonCoordinates.count)
        }
        return polygon
    }

}
   
extension MapsViewController{
    
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat.random(in: 0...1)
        let greenValue = CGFloat.random(in: 0...1)
        let blueValue = CGFloat.random(in: 0...1)
        
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        
        return randomColor
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard(overlay is MKPolygon || overlay is MKCircle) else { return MKOverlayRenderer() }
            
        if(overlay is MKPolygon){
            var renderer = MKPolygonRenderer.init(polygon: overlay as! MKPolygon)
            
            renderer.lineWidth = 2.0
            renderer.strokeColor = self.generateRandomColor()
            renderer.fillColor = self.generateRandomColor().withAlphaComponent(0.4)
            renderer.alpha = 0.4
            renderer.polygon.accessibilityLabel="Hello"
            renderer.accessibilityLabel="Hello"
            renderer.accessibilityRespondsToUserInteraction = true
            renderer.accessibilityPerformMagicTap()

                    
            return renderer
        }else if(overlay is MKCircle){
            var renderer = MKCircleRenderer.init(circle: overlay as! MKCircle)
            
            renderer.lineWidth = 1.0
            renderer.strokeColor = self.generateRandomColor()
            renderer.fillColor = self.generateRandomColor().withAlphaComponent(0.4)
            renderer.alpha = 0.9
                    
            return renderer
        }
        return MKOverlayRenderer()
        
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
