//
//  AugmentedRealityViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 25/05/2021.
//

import UIKit
import SwiftUI
import RealityKit
import CoreLocation
import ARKit

class AugmentedRealityViewController: UIViewController {
    
    let arContentView = UIHostingController(rootView: ARContentView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add AR view with customed AR interface
        addChild(arContentView)
        view.addSubview(arContentView.view)
        setupConstraints()
    }
    
    func setupConstraints(){
        arContentView.view.translatesAutoresizingMaskIntoConstraints = false
        arContentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        arContentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        arContentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        arContentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}
