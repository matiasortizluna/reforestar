//
//  ContentView.swift
//  ARSwiftUI
//
//  Created by Matias Ariel Ortiz Luna on 19/04/2021.
//

import SwiftUI
import RealityKit
import ARKit
import UIKit

struct ContentView: View {
    
    @State var heightValue : Double = 1.0
    @State var minimumValue : Double = 1.0
    @State var maximumValue : Double = 10.0
    
    @ObservedObject public var locationManager  = LocationManager()
    
    var body: some View {
        let coordinate = self.locationManager.coordinates != nil ? self.locationManager.coordinates!.coordinate : CLLocationCoordinate2D()
        
        ZStack(){
            //Interface AR
            ARViewContainer()
            
            VStack(alignment: .center){
                Text("\(coordinate.latitude) : \(coordinate.longitude)")
                    .foregroundColor(Color.white)
                    .background(Color.green.opacity(0.25))
                    .padding()
                    .cornerRadius(20)
                Spacer()
            }
            
            HStack(alignment: .bottom){
                
                //Interface AR
                Spacer()
                InterfaceLayout(heightValue: $heightValue, minimumValue: $minimumValue, maximumValue: $maximumValue)
                
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView  = ARView(frame: .zero)
        
        arView.setupARView()
        arView.setupGestures()
        
        return arView;
    }
    
    
    func updateUIView(_ uiView: ARView
                      , context: Context) {
    }
    
}

extension ARView{
    
    func setupARView(){
        self.session.delegate = self
        
        self.automaticallyConfigureSession = false;
        let configuration = ARWorldTrackingConfiguration();
        configuration.planeDetection = [.horizontal,.vertical];
        configuration.environmentTexturing = .automatic;
        self.session.run(configuration)
    }
    
    func setupGestures() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer){
        let touchInView = recognizer.location(in: self)
        let results = self.raycast(from: touchInView, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first{
            
            var positions = ReforestationSettings().getPositionsThreeDimension(from: firstResult.worldTransform, for: 20)
            
            for index in 0...(positions.count-1) {
                
                positions[index] = ReforestationSettings().scaleObject(old_matrix: positions[index])
                
                //positions[index] = ReforestationSettings().rotateObject(old_matrix: positions[index])
                
                var anchor = ARAnchor(name: "quercus_suber", transform: positions[index]);
                self.session.add(anchor: anchor);
                
            }
            
        }else{
            print("Object placement failed - coudn't find surface")
        }
    }
    
    func placeObject(named entityName: String, for anchor: ARAnchor){
        let entity = try! ModelEntity.load(named: entityName)
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.addChild(entity);
        //anchorEntity.scale *= (1/100)
        
        //self.scene.addAnchor(anchorEntity)
        
        self.scene.anchors.append(anchorEntity)
        self.session.add(anchor: anchor)
        
        entity.generateCollisionShapes(recursive: true)
        //self.installGestures([.rotation,.translation], for: entity as! Entity & HasCollision)
    }
    
}

extension ARView: ARSessionDelegate{
    
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors{
            if let anchorName = anchor.name, anchorName == "quercus_suber"{
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
    
}
