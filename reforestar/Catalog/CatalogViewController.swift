import UIKit
import Firebase
import SwiftUI

class CatalogViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var trees:Dictionary<String, Dictionary<String, Any>> = [:]
    var treesNames:[String] = []
    
    var filteredData: [String]!
    var treesInfoToSend :[String:String]=[:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.getTrees()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            // Do any additional setup after loading the view.
            self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
        
    }
    
    
    func getTrees(){
        
        for tree in CurrentSession.sharedInstance.catalog{
            self.treesNames.append(tree.latin_name)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        //tableViewCell.textLabel?.text = myData[indexPath.row]
        tableViewCell.nameLabelForCell.text = treesNames[indexPath.row];
        
        return tableViewCell;
    }
    
    //Prepare to create new View Controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.treesInfoToSend["latin_name"] = treesNames[indexPath.row]
        performSegue(withIdentifier: "catalog_to_detail", sender: true)
    }
    
    //Create New Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="catalog_to_detail"){
            let vc = segue.destination as! CatalogDetailViewController
            vc.title = self.treesInfoToSend["latin_name"]
            vc.titleLatin = self.treesInfoToSend["latin_name"] ?? "FEO"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 0;
        return treesNames.count;
    }
    
    
}
