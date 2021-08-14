//
//  CatalogDetailViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 27/04/2021.
//

import UIKit
import SwiftUI

class CatalogDetailViewController: UIViewController {

    var titleLatin : String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogDetailContentView : UIHostingController<CatalogDetailContentView> = UIHostingController(rootView: CatalogDetailContentView(stringlatin: titleLatin!))
        
        //Add AR view with customed AR interface
        addChild(catalogDetailContentView)
        view.addSubview(catalogDetailContentView.view)

        catalogDetailContentView.view.translatesAutoresizingMaskIntoConstraints = false
        catalogDetailContentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        catalogDetailContentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        catalogDetailContentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        catalogDetailContentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    

 
     
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
