//
//  ViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 07/04/2021.
//

import UIKit
import RealityKit
import ARKit
import SwiftUI

class ViewController: UIViewController {
    
    var arView = ARView(frame: .zero)
    
    override func viewDidLoad() {
        setupConstraints()
        
        super.viewDidLoad()
        
        arView.session.delegate = self;
        
        setupARView()
        
        restartSession()
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        
    }
    
    func restartSession() {
        // Check geo-tracking location-based availability.
        ARGeoTrackingConfiguration.checkAvailability { (available, error) in
            if !available {
                let errorDescription = error?.localizedDescription ?? ""
                let recommendation = "Please try again in an area where geotracking is supported."
                let restartSession = UIAlertAction(title: "Restart Session", style: .default) { (_) in
                    self.restartSession()
                }
                //self.alertUser(withTitle: "Geotracking unavailable",
        //                       message: "\(errorDescription)\n\(recommendation)",
          //                     actions: [restartSession])
            }
        }
        
        
    }
    
    func setupConstraints(){
        self.arView.translatesAutoresizingMaskIntoConstraints = false
        self.arView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.arView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.arView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }


    func setupARView(){
        
        arView.automaticallyConfigureSession = false;
        let configuration = ARWorldTrackingConfiguration();
        configuration.planeDetection = [.horizontal];
        configuration.environmentTexturing = .automatic;
        
        // Re-run the ARKit session.
        //let geoTrackingConfig = ARGeoTrackingConfiguration()
        //geoTrackingConfig.planeDetection = [.horizontal]
        
        //arView.session.run(geoTrackingConfig)
        
        arView.scene.anchors.removeAll()
        
        arView.session.run(configuration)
        
    }
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer){
        
        let location = recognizer.location(in: arView)
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
  
        /*
        let coordinate = CLLocationCoordinate2D(latitude: 39.73954841, longitude: -8.80565608)
        let geoAnchor = ARGeoAnchor(name: "pinus_pinaster.usdz", coordinate: coordinate)
        print("Coordenadas: \(geoAnchor.coordinate.latitude)")
        self.arView.session.add(anchor: geoAnchor);
        */
        
        
        let point = SIMD3<Float>([0, 1, -2])
        
        arView.session.getGeoLocation(forPoint: point) {
            (coordinate, altitude, error) in
            let geoAnchor = ARGeoAnchor(name: "pinus_pinaster.usdz", coordinate: coordinate, altitude:
                altitude)
            print("Coordenadas: \(geoAnchor.coordinate.latitude)")
            self.arView.session.add(anchor: geoAnchor);
        }
        
        
        /*
        if let firstResult = results.first{
            let anchor = ARAnchor(name: "pinus_pinaster.usdz", transform: firstResult.worldTransform);
            arView.session.add(anchor: anchor);
        }else{
            print("Object placement failed - coudn't find surface")
        }
 */
 
    }
    
    func placeObject(named entityName: String, for anchor: ARAnchor){
        let entity = try! ModelEntity.load(named: entityName)
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.addChild(entity);
        arView.scene.addAnchor(anchorEntity);
        
        entity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation,.translation], for: entity as! Entity & HasCollision)
    }
    
}

extension ViewController: ARSessionDelegate{
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors{
            if let anchorName = anchor.name, anchorName == "pinus_pinaster.usdz"{
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
}

extension UIView {
    func addConstrained(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

/*
 
 let controlView = ContentView()
 
 let host = UIHostingController(rootView: controlView)
 navigationController?.pushViewController(host, animated:    true)
 
 */
