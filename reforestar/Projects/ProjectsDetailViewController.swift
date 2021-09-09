//
//  ProjectsDetailViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 27/04/2021.
//

import UIKit
import SwiftUI

class ProjectsDetailViewController: UIViewController {

    //var titleReceived = ""
    var project_name : String? = ""
    var project_description : String? = ""
    var project_status : String? = ""
    var project_trees : Int? = 0
    var project_areas : Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let projectsDetailContentView : UIHostingController<ProjectsDetailContentView> = UIHostingController(rootView: ProjectsDetailContentView(project_name: self.project_name!, project_description: self.project_description!, project_status: self.project_status!, project_trees: self.project_trees!, project_areas: self.project_areas!))
        
        //Add AR view with customed AR interface
        addChild(projectsDetailContentView)
        view.addSubview(projectsDetailContentView.view)
 
        projectsDetailContentView.view.translatesAutoresizingMaskIntoConstraints = false
        projectsDetailContentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        projectsDetailContentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        projectsDetailContentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        projectsDetailContentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //self.title = self.titleReceived

        // Do any additional setup after loading the view.
    }
    
    
    
    
}
