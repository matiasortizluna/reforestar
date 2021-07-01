//
//  TreesCatalogModel.swift
//  ARSwiftUI
//
//  Created by Matias Ariel Ortiz Luna on 31/05/2021.
//

import SwiftUI
import RealityKit
import Combine

class TreesCatalogModel{
    var latin_name:String
    var common_name:String
    var image:UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    private var cancellable: AnyCancellable?
    
    init(latin_name:String, common_name:String,scaleCompensation:Float = 1.0) {
        self.latin_name=latin_name
        self.common_name=common_name
        self.image = UIImage(named: latin_name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    
    func asyncLoadModelEntity(){
        let filename = self.latin_name+".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: {loadCompletion in
                switch loadCompletion{
                case .failure(let error): print("Unable to load modelEntity for \(filename) Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: {modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                print("modelEntity for \(self.latin_name) has been loaded")
            })
    } 
    
}

struct TreeCatalogModels{
    var all: [TreesCatalogModel] = []
    
    init() {
        let pinus_pinea = TreesCatalogModel(latin_name: "pinus_pinea", common_name: "pinus_pinea_common",scaleCompensation: 3/100)
        let pinus_pinaster = TreesCatalogModel(latin_name: "pinus_pinaster", common_name: "pinus_pinaster_common",scaleCompensation: 3/100)
        let eucalyptus = TreesCatalogModel(latin_name: "eucalyptus", common_name: "eucalyptus_common",scaleCompensation: 3/100)
        let quercus_suber = TreesCatalogModel(latin_name: "quercus_suber", common_name: "quercus_suber_common",scaleCompensation: 3/100)
        
        self.all += [pinus_pinea,pinus_pinaster,eucalyptus,quercus_suber]
    }
    
    func getAll() -> [TreesCatalogModel]{
        return self.all
    }
    
    func getCount()->Int{
        return self.all.count
    }
}
