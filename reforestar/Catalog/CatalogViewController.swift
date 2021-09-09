import UIKit
import Firebase
import SwiftUI

class CatalogViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var trees:Dictionary<String, Dictionary<String, Any>> = [:]
    var treesLatinNames:[String] = []
    var treesCommonNames:[String] = []
    
    var treesInfoToSend :[String:String]=[:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.getTrees()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            self.tableView.register(UINib(nibName: "CatalogTableViewCell", bundle: nil), forCellReuseIdentifier: "CatalogTableViewCell")
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
        
    }
    
    
    func getTrees(){
        
        for tree in CurrentSession.sharedInstance.catalog{
            self.treesLatinNames.append(tree.latin_name)
            self.treesCommonNames.append(tree.common_name)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "CatalogTableViewCell", for: indexPath) as! CatalogTableViewCell
        tableViewCell.latin_name_label.text = treesLatinNames[indexPath.row]
        tableViewCell.common_name_label.text = treesCommonNames[indexPath.row]
        tableViewCell.image_tree.image = UIImage(named: treesLatinNames[indexPath.row])
        return tableViewCell;
    }
    
    //Prepare to create new View Controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.treesInfoToSend["latin_name"] = treesLatinNames[indexPath.row]
        performSegue(withIdentifier: "catalog_to_detail", sender: true)
    }
    
    //Create New Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="catalog_to_detail"){
            let vc = segue.destination as! CatalogDetailViewController
            vc.title = self.treesInfoToSend["latin_name"]
            vc.latin_name = self.treesInfoToSend["latin_name"] ?? "Latin Name"
            
            let indexTree = CurrentSession.sharedInstance.searchForTreeCatalog(latin_name: self.treesInfoToSend["latin_name"]!)
            
            vc.common_name = CurrentSession.sharedInstance.catalog[indexTree].common_name
            vc.description_tree = CurrentSession.sharedInstance.catalog[indexTree].description_tree
            vc.has3dmodel = CurrentSession.sharedInstance.catalog[indexTree].hasModel
            vc.max_height = CurrentSession.sharedInstance.catalog[indexTree].max_height
            vc.min_height = CurrentSession.sharedInstance.catalog[indexTree].min_height
            vc.space_betwen = CurrentSession.sharedInstance.catalog[indexTree].space_betwen
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treesLatinNames.count;
    }
    
}
