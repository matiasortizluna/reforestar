//
//  ContentView.swift
//  ARSwiftUI
//
//  Created by Matias Ariel Ortiz Luna on 19/04/2021.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    
    @State var heightValue : Double = 0.0
    @State var minimumValue : Double = 1.0
    @State var maximumValue : Double = 10.0
    
    var body: some View {
        ZStack(alignment: .trailing){
            
            ARViewContainer()
            
            ControlView(heightValue: $heightValue, minimumValue: $minimumValue, maximumValue: $maximumValue)
            
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let arView  = ARView(frame: .zero)
        
        return arView;
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
