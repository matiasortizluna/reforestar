//
//  MapsViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 08/04/2021.
//

import UIKit
import MapKit
import CoreLocation

class MapsViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        let coordinates = CLLocationCoordinate2D(latitude: 39.612981, longitude: -8.662311);
        let region = CLCircularRegion(center: coordinates, radius: 5000, identifier: "geofence")
        let overlay = MKCircle(center: coordinates, radius: region.radius)
        
        let polygonCoordinates:[CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 39.892855, longitude: -8.956267),CLLocationCoordinate2D(latitude: 39.672288, longitude: -9.048278),CLLocationCoordinate2D(latitude: 39.720895, longitude: -8.972747),CLLocationCoordinate2D(latitude: 39.786354, longitude: -8.908202),CLLocationCoordinate2D(latitude: 39.822224, longitude: -8.893096)]
        
        
        let polygon = MKPolygon(coordinates: polygonCoordinates, count: polygonCoordinates.count)
        
        let overlays: [MKOverlay] = [overlay,polygon]
        
        mapView.addOverlays(overlays)
    }
    
    
}

extension MapsViewController{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard(overlay is MKPolygon || overlay is MKCircle) else { return MKOverlayRenderer() }
            
        if(overlay is MKPolygon){
            var renderer = MKPolygonRenderer.init(polygon: overlay as! MKPolygon)
            
            renderer.lineWidth = 1.0
            renderer.strokeColor = UIColor.red
            renderer.fillColor = UIColor.red.withAlphaComponent(0.4)
            renderer.alpha = 0.9
            renderer.accessibilityLabel="Hello"
            renderer.accessibilityRespondsToUserInteraction = true
            renderer.accessibilityPerformMagicTap()

                    
            return renderer
        }else if(overlay is MKCircle){
            var renderer = MKCircleRenderer.init(circle: overlay as! MKCircle)
            
            renderer.lineWidth = 1.0
            renderer.strokeColor = UIColor.blue
            renderer.fillColor = UIColor.blue.withAlphaComponent(0.4)
            renderer.alpha = 0.9
                    
            return renderer
        }
        return MKOverlayRenderer()
        
    }
    
}

