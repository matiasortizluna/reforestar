//
//  ProjectsDetailViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 27/04/2021.
//

import UIKit
import SwiftUI

class ProjectsDetailViewController: UIViewController {

    var titleReceived = ""
    let stringlatin : String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let projectsDetailContentView : UIHostingController<ProjectsDetailContentView> = UIHostingController(rootView: ProjectsDetailContentView(stringlatin: stringlatin!))
        
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
