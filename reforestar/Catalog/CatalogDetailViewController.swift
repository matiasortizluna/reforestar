//
//  CatalogDetailViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 27/04/2021.
//

import UIKit
import SwiftUI

class CatalogDetailViewController: UIViewController {
    
    var latin_name : String? = ""
    var common_name: String? = ""
    var space_betwen: Int? = 0
    var min_height: Int? = 0
    var max_height: Int? = 0
    var description_tree: String? = ""
    var has3dmodel: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogDetailContentView : UIHostingController<CatalogDetailContentView> = UIHostingController(rootView: CatalogDetailContentView(catalog_latin_name: latin_name!, catalog_common_name: common_name!, catalog_space_betwen: self.space_betwen!, catalog_min_height: min_height!, catalog_max_height: max_height!, catalog_description_tree: description_tree!, catalog_has3dmodel: has3dmodel!))
        
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
