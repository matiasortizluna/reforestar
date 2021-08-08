//
//  UserProfileViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 07/04/2021.
//

import UIKit
import Firebase
import SwiftUI

class UserProfileViewController: UIViewController {
    
    let userContentView = UIHostingController(rootView: UserProfileContentView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always

        if(Auth.auth().currentUser == nil){
            print("Do you want to log in ?")
        }
        
        //Add AR view with customed AR interface
        addChild(userContentView)
        view.addSubview(userContentView.view)
        setupConstraints()
        userContentView
    }
    
    func setupConstraints(){
        userContentView.view.translatesAutoresizingMaskIntoConstraints = false
        userContentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        userContentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        userContentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        userContentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}
