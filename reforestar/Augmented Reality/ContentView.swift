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
                //ARViewWrapper()
                if(self.placementSettings.selectedModel == nil){
                    //Interface AR
                    Spacer()
                    InterfaceLayout(heightValue: $heightValue, minimumValue: $minimumValue, maximumValue: $maximumValue)
                }else{
                    PlacementView()
                }
            }.environmentObject(placementSettings)
        }
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
        
        arView.setupGestures()
        /*
         self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, {(event) in
         self.updateScene(for: arView)}
         )*/
        
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
        arView.scene.addAnchor(anchorEntity)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(PlacementSettings())
    }
}

extension ARView{
    
    func setupGestures() {
        self.session.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let touchInView = sender?.location(in: self) else {
            print("Failed on touch")
            return
        }
        
        let results = self.raycast(from: touchInView, allowing: .estimatedPlane, alignment: .horizontal)
        if let firstResult = results.last{
            let anchor = ARAnchor(name: "quercus_suber.usdz", transform: firstResult.worldTransform);
            print(anchor.name)
            print("First \(anchor.transform)")
            self.session.add(anchor: anchor);
            print("Second \(anchor.transform)")
        }else{
            print("Object placement failed - coudn't find surface")
        }
        
        
        /*
         let coordinate = CLLocationCoordinate2D(latitude: 39.73954841, longitude: -8.80565608)
         let geoAnchor = ARGeoAnchor(name: "quercus_suber.usdz", coordinate: coordinate)
         print("Coordenadas: \(geoAnchor.coordinate.latitude)")
         self.session.add(anchor: geoAnchor);
         */
        
        /*
         let point = SIMD3<Float>([0, 1, -2])
         self.session.getGeoLocation(forPoint: point) {
         (coordinate, altitude, error) in
         let geoAnchor = ARGeoAnchor(name: "quercus_suber.usdz", coordinate: coordinate, altitude:
         altitude)
         print("Coordenadas: \(geoAnchor.coordinate.latitude)")
         self.session.add(anchor: geoAnchor);
         }
         */
        
    }
    
}

extension ARView: ARSessionDelegate{
    
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("REached session")
        for anchor in anchors{
            if let anchorName = anchor.name, anchorName == "quercus_suber.usdz"{
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
    
    func placeObject(named entityName: String, for anchor: ARAnchor){
        let entity = try! ModelEntity.load(named: entityName)
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        print("anchor entity \(anchorEntity.name)")
        anchorEntity.addChild(entity);
        print("Third \(anchor.transform)")
        self.session.add(anchor: anchor)
        print("Forth \(anchor.transform)")
        self.scene.anchors.append(anchorEntity)
        print("Fifth \(anchor.transform)")
        //self.scene.addAnchor(anchorEntity)
        entity.generateCollisionShapes(recursive: true)
        //self.installGestures([.rotation,.translation], for: entity as! Entity & HasCollision)
    }
}
