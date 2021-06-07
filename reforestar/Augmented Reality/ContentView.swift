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
    @StateObject var placementSettings = PlacementSettings()
    
    @State var heightValue : Double = 0.0
    @State var minimumValue : Double = 1.0
    @State var maximumValue : Double = 10.0
    
    var body: some View {
        ZStack(alignment: .trailing){
            
            //Interface AR
            ARViewContainer()
            //ARViewWrapper()
            if(self.placementSettings.selectedModel == nil){
                //Interface AR
                InterfaceLayout(heightValue: $heightValue, minimumValue: $minimumValue, maximumValue: $maximumValue)
            }else{
                Spacer()
                PlacementView()
            }
            
        }.environmentObject(placementSettings)
    }
}

struct ARViewWrapper: UIViewControllerRepresentable{
    
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController()
    }
        
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var placementSettings:PlacementSettings
    
    func makeUIView(context: Context) -> some UIView {
        
        let arView  = ARView(frame: .zero)
        
        arView.automaticallyConfigureSession = false;
        let configuration = ARWorldTrackingConfiguration();
        configuration.planeDetection = [.horizontal];
        arView.session.run(configuration)
        
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, {(event) in
                self.updateScene(for: arView)}
        )

        return arView;
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    public func updateScene(for arView: ARView){
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity{
            self.place(modelEntity, in: arView)
            self.placementSettings.confirmedModel=nil
        }
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView){
        
        let clonedEntity = modelEntity.clone(recursive: true)
        
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: clonedEntity)
        
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        
        print(anchorEntity.anchor?.position as Any)
        arView.scene.addAnchor(anchorEntity)
        print(anchorEntity.anchor?.position as Any)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(PlacementSettings())
    }
}

extension ARView{
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        guard let touchInView = sender?.location(in: self) else {
            print("Failed on touch")
            return
        }
        
        let results = self.raycast(from: touchInView, allowing: .estimatedPlane, alignment: .horizontal)
        print(results)
        
        if let firstResult = results.first{
            //print(firstResult.worldTransform.translation)
            //let anchor = ARGeoAnchor(name: "pinus_pinaster.usdz", coordinate: firstResult.worldTransform.translation.x);
            let anchor = ARAnchor(name: "pinus_pinaster.usdz", transform: firstResult.worldTransform);
            self.session.add(anchor: anchor);
        }else{
            print("Object placement failed - coudn't find surface")
        }
        
    }
    
    func placeObject(named entityName: String, for anchor: ARAnchor){
        let entity = try! ModelEntity.load(named: entityName)
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.addChild(entity);
        self.scene.addAnchor(anchorEntity);
        
        entity.generateCollisionShapes(recursive: true)
        self.installGestures([.rotation,.translation], for: entity as! Entity & HasCollision)
        
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors{
            if let anchorName = anchor.name, anchorName == "pinus_pinaster.usdz"{
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
    
}
