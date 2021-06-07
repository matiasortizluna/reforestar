//
//  PlacementSettings.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 01/06/2021.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject{
    // When the user selects a model
    @Published var selectedModel: TreesCatalogModel? {
        willSet(newValue){
            print("Setting selectedModel to \(String(describing: newValue?.latin_name))")
        }
    }
    
    // When the user confirms the model
    @Published var confirmedModel: TreesCatalogModel? {
        willSet(newValue){
            guard let model = newValue else {
                print("Clearing Information")
                return
            }
            print("Settin confirmedmodel to \(newValue?.latin_name)")
        }
    }
    
    var sceneObserver : Cancellable?
    
}
