import Foundation
import SwiftUI
import ARKit
import Combine
import Firebase

class TreeCatalogModel{
    var latin_name:String
    var common_name:String
    var hasModel : Bool
    var description_tree : String
    var max_height : Int
    var min_height : Int
    var space_betwen : Int
    
    init(latin_name: String, common_name: String, hasModel: Bool, description_tree : String, max_height : Int, min_height : Int, space_betwen : Int) {
        self.latin_name=latin_name
        self.common_name=common_name
        self.hasModel = hasModel
        self.description_tree = description_tree
        self.max_height = max_height
        self.min_height = min_height
        self.space_betwen = space_betwen
    }
}

class ProjectModel{
    var project_name:String
    var project_description : String
    var project_status : String
    var project_trees : Int
    var project_areas : Int
    
    init(project_name:String, project_description : String, project_status : String, project_trees : Int, project_areas : Int) {
        self.project_name = project_name
        self.project_description = project_description
        self.project_status = project_status
        self.project_trees = project_trees
        self.project_areas = project_areas
    }
}

final class CurrentSession {
    
    private var selected_model_name : String = "Pinus pinaster"
    private var number_of_trees : Int = 1
    private var scale_compensation : Double = 1.0
    
    private var recent_anchor : ARAnchor? = nil
    private var current_scene_anchors : [ARAnchor] = []
    private var to_load_anchors : [ARAnchor] = []
    
    private var reforestation_plan : Bool = true
    
    private var selected_project : String? = nil
    
    public var projects_name : [String] = []
    public var projects_of_user : Dictionary<String, String> = [:]
    public var projects : [ProjectModel] = []
    
    public var catalog : [TreeCatalogModel] = []
    
    public var user : User? = nil
    
    public var ref : DatabaseReference? = nil
    
    public var areas : Dictionary<String, Any> = [:]
    
    public var user_location : CLLocationCoordinate2D = CLLocationCoordinate2D()
    public var desired_location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    static let sharedInstance: CurrentSession = {
        let instance = CurrentSession()
        return instance
    }()
    
    private init(){
        self.user = Auth.auth().currentUser
        sleep(1)
    }
    
    public func searchForProjectCatalog(project_name: String) -> Int {
        var index = -1
        for project in self.projects {
            index+=1
            if (project.project_name == project_name){
                return index
            }
        }
        return -1
    }
    
    public func searchForTreeCatalog(latin_name: String) -> Int {
        var index = -1
        for tree in self.catalog {
            index+=1
            if (tree.latin_name == latin_name){
                return index
            }
        }
        return -1
    }
    
    public func fetchTreeCatalog(){
        self.ref!.child("trees").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                let trees_catalog = snapshot.value as! Dictionary<String, Dictionary<String, Any>>
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    for tree in trees_catalog {
                        self.catalog.append(TreeCatalogModel(latin_name: tree.value["latin_name"] as! String, common_name: tree.value["common_name"] as! String, hasModel: tree.value["3dmodel"] != nil ? true : false, description_tree : tree.value["description"] as! String, max_height : Int(tree.value["max_height"] as! NSNumber), min_height : Int(tree.value["min_height"] as! NSNumber), space_betwen : Int(truncating: tree.value["space_between"] as! NSNumber)))
                    }
                    print(self.catalog.count)
                })
            }
            else {
                print("No data available")
            }
        }
    }
    
    public func fetchNameProjectsOfUser() {
        self.ref!.child("users/matiasarielol/projects").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.projects_of_user = snapshot.value as? Dictionary<String, String> ?? ["":""]
                    self.setSelectedProject(project: self.projects_of_user.keys.first ?? "Default")
                    for project in self.projects_of_user.keys {
                        self.projects_name.append(project )
                    }
                    self.fetchAreas()
                    self.fetchProjects()
                })
            }
            else {
                print("No data available")
            }
        }
        
    }
    
    public func fetchProjects() {
        for project_user in self.projects_name {
            self.ref!.child("projects/\(project_user)/").getData { (error, snapshot) in
                if let error = error {
                    print("Error getting data \(error)")
                }
                else if snapshot.exists() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        let project = snapshot.value as! Dictionary<String,Any>
                        let trees = project["trees"] != nil ? project["trees"] as! NSArray : []
                        let areas = project["areas"] != nil ? project["areas"] as! NSDictionary : [:]
                        self.projects.append(ProjectModel(project_name: project["name"] as! String, project_description: project["description"] as! String, project_status: project["status"] as! String, project_trees: trees.count, project_areas: areas.count))
                    })
                }
                else {
                    print("No data available")
                }
            }
        }
    }
    
    func fetchAreas() {
        for project_user in self.projects_name {
            self.ref!.child("projects/\(project_user)/areas").getData { (error, snapshot) in
                if let error = error {
                    print("Error getting data \(error)")
                }
                else if snapshot.exists() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        for area in snapshot.value as! Dictionary<String,Any> {
                            self.areas[area.key] = area.value as! NSArray
                        }
                    })
                }
                else {
                    print("No data of areas available")
                }
            }
        }
    }
    
    public func addLoadAnchors(anchors: [ARAnchor]){
        self.to_load_anchors = anchors
    }
    
    public func addLoadAnchor(anchor: ARAnchor){
        self.to_load_anchors.append(anchor)
    }
    
    public func cleanLoadAnchors(){
        self.to_load_anchors = []
    }
    
    public func getLoadAnchors() -> [ARAnchor]{
        return self.to_load_anchors
    }
    
    public func hasLoadAnchors() -> Bool {
        return self.to_load_anchors.count > 0 ? true : false
    }
    
    func getProjectsNames() -> [String] {
        return self.projects_name
    }
    
    func getProjecst() -> [ProjectModel] {
        return self.projects
    }
    
    func setSelectedProject(project: String) -> Void {
        self.selected_project = project
    }
    
    func getSelectedProject() -> String {
        return self.selected_project ?? "No project Associated"
    }
    
    func getDisplayName() -> String {
        if(self.user != nil){
            if(self.user?.displayName != nil && !(self.user?.displayName!.isEmpty)!){
                return self.user!.displayName!
            }
        }
        return "No Display Name"
    }
    
    func getEmail() -> String {
        return self.user != nil ? self.user!.email! : ""
    }
    
    /*
     func getImage() -> URL {
     return self.user != nil ? self.user!.photoURL! : URL(string: "")!
     }
     */
    
    func setUser(user: User){
        self.user = user
    }
    
    func removeUser(){
        self.user = nil
    }
    
    func setNewPassword(new: String) {
        self.user?.updatePassword(to: new, completion: { error in
            if let error = error {
                // An error happened.
            } else {
                // User re-authenticated.
            }
        })
    }
    
    func setNewEmail(new: String){
        self.user?.updateEmail(to: new, completion: { error in
            if let error = error {
                // An error happened.
            } else {
                // User re-authenticated.
            }
            
        })
    }
    
    func setNewDisplayName(new: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = new
        changeRequest?.commitChanges { error in
            print("Error updating display name: \(error?.localizedDescription)")
        }
    }
    
    //Auth.auth().sendPasswordReset(withEmail: email) { error in
    // ... }
    
    func toogleReforestationPlanOption()->Void {
        self.reforestation_plan.toggle()
    }
    
    func getReforestationPlanOption()->Bool {
        return self.reforestation_plan
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
        self.recent_anchor = anchor
    }
    
    func getLastAnchor() -> ARAnchor {
        return self.recent_anchor!
    }
    
    func removeLastAnchor() -> Void {
        self.recent_anchor = nil
    }
    
    public func appendSceneAnchor(scene_anchor : ARAnchor){
        self.current_scene_anchors.append(scene_anchor)
    }
    
    public func removeLast(){
        self.current_scene_anchors.removeLast()
    }
    
    public func removeAll(){
        self.current_scene_anchors.removeAll()
    }
    
    public func setSceneAnchors(scene_anchors : [ARAnchor]){
        self.current_scene_anchors = scene_anchors
    }
    
    public func getSceneAnchors() -> [ARAnchor]{
        return self.current_scene_anchors
    }
    
    public func getPositions()->[simd_float4x4]{
        var positions : [simd_float4x4] = []
        for anchor in self.current_scene_anchors{
            positions.append(anchor.transform)
        }
        return positions
    }
    
}


class CurrentSessionSwiftUI : ObservableObject {
    
    @Published var selectedModelName : String = "Pinus pinaster"
    @Published var scene_anchors : Int = 0
    
    @Published var projects : Dictionary<String, Dictionary<String,Any>> = [:]
    @Published var projects_names : [String] = []
    
    @Published var n_planted_trees_total : Int = 0
    @Published var n_areas_total : Int = 0
    
    @Published var loggedUser : User? = nil
    
    let notification_numberOfAnchors = Notification.Name("numberOfAnchors")
    var cancellable_numberOfAnchors: AnyCancellable?
    
    let notification_removeLastAnchor = Notification.Name("removeLastAnchor")
    var cancellable_removeLastAnchor: AnyCancellable?
    
    let notification_removeAllAnchors = Notification.Name("removeAllAnchors")
    var cancellable_removeAllAnchors: AnyCancellable?
    
    let ref = Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    
    var currentSceneManager = CurrentSession.sharedInstance
    
    init(){
        
        self.loggedUser = Auth.auth().currentUser
        
        self.getProjects()
        
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
    
    
    public func getProjects() {
        self.projects_names = CurrentSession.sharedInstance.getProjectsNames()
    
        for project in CurrentSession.sharedInstance.getProjecst() {
            if(project.project_areas != 0){
                self.n_areas_total += project.project_areas
            }
            if(project.project_trees != 0){
                self.n_planted_trees_total += project.project_trees
            } 
        }
    }
    
    public func cleanUserInformation(){
        self.n_areas_total = 0
        self.n_planted_trees_total = 0
        self.projects = [:]
    }
    
}

class UserFeedback : ObservableObject {
    
    @Published var title_string: String = "Title of message"
    @Published var title_color: Color = Color.dark_green

    @Published var icon_string: String = "lasso"
    @Published var text_string: String = "Text of the message associated to the title"
    @Published var text_color: Color = Color.dark_green
    
    @Published var back_color: Color = Color.light_beish
    
    @Published var show_message: Bool = false
    
    init(){
    }
    
}

