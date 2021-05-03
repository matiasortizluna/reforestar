//
//  ViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 07/04/2021.
//

import UIKit
import RealityKit
import ARKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    var ref: DatabaseReference!
    //private let database = Firebase.Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/")
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        arView.session.delegate = self;
        
        setupARView()
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        
        //To delete anything with that key
        //database.child("Commentary").setValue(nil);
        
        ref = Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let object: [String: Any] = [
            "name": "Matias" as NSObject,
            "age": "14" as NSObject
        ]
        self.ref.child("MArcoOrtiz").setValue(nil)
        //self.ref.child("MArcoOrtiz").setValue(object)
        //re.child("MarcoOrtiz").setValue(object)
        
    }

    /*
    override func viewDidLoad() {
        super.viewDidLoad()
    }*/
    
    func setupARView(){
        
        arView.automaticallyConfigureSession = false;
        let configuration = ARWorldTrackingConfiguration();
        configuration.planeDetection = [.horizontal,.vertical];
        configuration.environmentTexturing = .automatic;
        arView.session.run(configuration)
        
    }
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer){
        
        let location = recognizer.location(in: arView)
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first{
            let anchor = ARAnchor(name: "tree1.obj", transform: firstResult.worldTransform);
            arView.session.add(anchor: anchor);
        }else{
            print("Object placement failed - coudn't find surface")
        }
    }
    
    func placeObject(named entityName: String, for anchor: ARAnchor){
        let entity = try! ModelEntity.load(named: entityName)
        
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.addChild(entity);
        arView.scene.addAnchor(anchorEntity);
        
        entity.generateCollisionShapes(recursive: true)
        //arView.installGestures([.rotation,.translation], for: entity as! Entity & HasCollision)
    }
    
}

extension ViewController: ARSessionDelegate{
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors{
            if let anchorName = anchor.name, anchorName == "tree1.obj"{
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
}


/*
 
 let controlView = ContentView()
 
 let host = UIHostingController(rootView: controlView)
 navigationController?.pushViewController(host, animated:    true)
 
 */
