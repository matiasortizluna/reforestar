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
    
    let contentView = UIHostingController(rootView: ContentView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add AR view with customed AR interface
        addChild(contentView)
        view.addSubview(contentView.view)
        setupConstraints()
    }
    
    func setupConstraints(){
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}
