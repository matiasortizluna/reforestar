//
//  SceneItems.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 01/07/2021.
//

import Foundation
import SwiftUI
import ARKit
import Combine
import Firebase

class SelectedModel : ObservableObject {
    
    @Published var selectedModelName : String = "quercus_suber"
    //@Published var numberOfTrees : Int = 1
    //@Published var scaleCompensation : Double = 1.0
    //private var last_anchor : ARAnchor? = nil
    //@Published var selectedProject : String? = nil
    //private var projects : [String] = [""]
    @Published var scene_anchors : Int = 0
    
    let notification_numberOfAnchors = Notification.Name("numberOfAnchors")
    var cancellable_numberOfAnchors: AnyCancellable?
    
    let notification_removeLastAnchor = Notification.Name("removeLastAnchor")
    var cancellable_removeLastAnchor: AnyCancellable?
    
    let notification_removeAllAnchors = Notification.Name("removeAllAnchors")
    var cancellable_removeAllAnchors: AnyCancellable?
    
    init(){
        
        self.cancellable_numberOfAnchors = NotificationCenter.default
            .publisher(for: self.notification_numberOfAnchors)
            .sink { value in
                print("Notification received from a publisher! \(value) \n to add number of anchors on scene")
                self.scene_anchors+=1
            }
        
        self.cancellable_removeLastAnchor = NotificationCenter.default
            .publisher(for: self.notification_removeLastAnchor)
            .sink { value in
                print("Notification received from a publisher! \(value) \n to rest 1 number of anchors on scene")
                self.scene_anchors-=1
            }
        
        self.cancellable_removeAllAnchors = NotificationCenter.default
            .publisher(for: self.notification_removeAllAnchors)
            .sink { value in
                print("Notification received from a publisher! \(value) \n to delete all number of anchors on scene")
                self.scene_anchors=0
            }
        
        
        
    }
}

class UserFeedback : ObservableObject {
    
    @Published  var message : String = "Message"
    
    init(){
    }
    
}

final class CurrentScene {
    
    private var selected_model_name : String = "quercus_suber"
    private var number_of_trees : Int = 1
    private var scale_compensation : Double = 1.0
    private var last_anchor : ARAnchor? = nil
    private var selected_project : String? = nil
    private var projects : [String] = [""]
    public var scene_anchors : [ARAnchor] = []
    
    public func getSceneAnchors() -> [ARAnchor]{
        return self.scene_anchors
    }
    
    static let sharedInstance: CurrentScene = {
        let instance = CurrentScene()
        
        return instance
    }()
    
    private init(){
        
        fetchAllProjects()
        sleep(1)
        
    }
    
    
    func setSelectedModelName(name: String){
        self.selected_model_name = name
    }
    
    func getSelectedModelName() -> String {
        return self.selected_model_name
    }
    
    func getNumberOfTrees() -> Int {
        return self.number_of_trees
    }
    
    func setNumberOfTrees(number: Int){
        self.number_of_trees = number
    }
    
    func getScaleCompensation() -> Double {
        return self.scale_compensation
    }
    
    func setScaleCompensation(number: Double) -> Void {
        self.scale_compensation = number
    }
    
    func setLastAnchor(anchor: ARAnchor) -> Void {
        self.last_anchor = anchor
    }
    
    func getLastAnchor() -> ARAnchor {
        return self.last_anchor!
    }
    
    func removeLastAnchor() -> Void {
        self.last_anchor = nil
    }
    
    public func appendSceneAnchor(scene_anchor : ARAnchor){
        self.scene_anchors.append(scene_anchor)
    }
    
    public func removeLast(){
        self.scene_anchors.removeLast()
    }
    
    public func removeAll(){
        self.scene_anchors.removeAll()
    }
    
    public func setSceneAnchors(scene_anchors : [ARAnchor]){
        self.scene_anchors = scene_anchors
    }
    
    public func getPositions()->[simd_float4x4]{
        var positions : [simd_float4x4] = []
        for anchor in self.scene_anchors{
            positions.append(anchor.transform)
        }
        return positions
    }
    
    func setSelectedProject(project: String) -> Void {
        self.selected_project = project
    }
    
    func getSelectedProject() -> String {
        return self.selected_project ?? "No project Associated"
    }
    
    func fetchAllProjects(){
        let ref = Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let project_database = ref.child("projects").observe(.value, with: {snapshot in
            guard let projects_retrieved = snapshot.value as? Dictionary<String, Dictionary<String, Any>> else {
                return
            }
            for project in projects_retrieved{
                self.projects.append(project.value["name"] as! String)
            }
            self.projects.remove(at: 0)
        })
        
        self.setSelectedProject(project: projects.last!)
    }
    
    func getAllProjects() -> [String] {
        return self.projects ?? [""]
    }
    
    
}

