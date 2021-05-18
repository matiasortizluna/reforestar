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


class MapsViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var areas_vertex: [AnyObject] = []
    var areas_allowed: [AnyObject] = []
    var areas_user: [AnyObject] = []
    var vertexes: [AnyObject] = []
    var areas: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getAreasAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
           // Code you want to be delayed
            self.joinAreasAndVertexes()
            //print(self.areas)
            
            let polygons=self.createPolygons(areas: self.areas)
            
            let overlays: [MKOverlay] = polygons
            
            //Request Location Permission to user
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //Update user's location
            self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            self.mapView.delegate = self
            
            print(polygons)
            self.mapView.addOverlays(overlays)
            
            
        }
        
    }
    
    func joinAreasAndVertexes(){
        if(self.areas_allowed.isEmpty && self.areas_user.isEmpty){
            //alert saying there is no areas to show
            print("No areas")
        }else{
            for area_a in self.areas_allowed {
                self.areas.append(self.getVertexesFromArea(area: area_a, areas_vertex: self.areas_vertex, vertexes: self.vertexes))
            }
            for area_u in self.areas_user {
                self.areas.append(self.getVertexesFromArea(area: area_u, areas_vertex: self.areas_vertex, vertexes: self.vertexes))
            }
        }
    }
    
    func getVertexesFromArea(area: AnyObject, areas_vertex: [AnyObject], vertexes: [AnyObject]) -> JSON{
        
        var area_info: JSON = []
        var vertexes_info: [AnyObject] = []
        
        for area_vertex in areas_vertex{
            if(area["id"] as! Int==area_vertex["id_area"] as! Int){
                if(!vertexes.isEmpty){
                    for vertex in vertexes{
                        if(area_vertex["id_vertex"] as! Int == vertex["id"] as! Int){
                            vertexes_info.append(vertex)
                        }
                    }
                    area_info = ["area": area, "vertexes": vertexes_info]
                }
                
            }
            
        }
        return area_info
    }
    
    func getAreas(){
        let ref = Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let areas_database = ref.child("areas").observe(.value, with: {snapshot in
            guard let payloads = snapshot.value as? [AnyObject] else {
                return
            }
            
            for payload in payloads{
                if(payload["default"] as! Int==1){
                    self.areas_allowed.append(payload)
                }else{
                    self.areas_user.append(payload)
                }
            }
            
        })
        
    }
    
    func getAreasVertex(){
        let ref = Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let areas_database = ref.child("areas_vertex").observe(.value, with: {snapshot in
            guard let payload = snapshot.value as? [AnyObject] else {
                return
            }
            self.areas_vertex = payload
        })
    }
    
    func getVertexes(){
        let ref = Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let areas_database = ref.child("vertexs").observe(.value, with: {snapshot in
            guard let payload = snapshot.value as? [AnyObject] else {
                return
            }
            self.vertexes = payload
        })
    }
    
    func getAreasAll(){
        self.getAreas()
        self.getAreasVertex()
        self.getVertexes()
    }
    
    func createPolygons(areas: [JSON]) -> [MKPolygon]{
        
        var polygons: [MKPolygon] = []
        
        for area in areas{
            if(area.exists() && !area["vertexes"].isEmpty){
                var polygonCoordinates:[CLLocationCoordinate2D] = []
                for vertex in area["vertexes"].arrayValue{
                    
                    polygonCoordinates.append(CLLocationCoordinate2D(latitude: vertex["latitude"].rawValue as! CLLocationDegrees, longitude: vertex["longitude"].rawValue as! CLLocationDegrees))
                    
                }
                var polygon = MKPolygon(coordinates: polygonCoordinates, count: polygonCoordinates.count)
                
                polygons.append(polygon)
            }
            
        }
        
        return polygons
    }
        
    }
    
    
    func createCircle() -> MKOverlay{
        let coordinates = CLLocationCoordinate2D(latitude: 39.612981, longitude: -8.662311);
        let region = CLCircularRegion(center: coordinates, radius: 5000, identifier: "geofence")
        let overlay = MKCircle(center: coordinates, radius: region.radius)
        return overlay
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

