import UIKit
import Firebase

class CatalogViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var treesNames:[String] = []
    var filteredData: [String]!
    var trees:Dictionary<String, Dictionary<String, Any>> = [:]
    var treesInfoToSend :[String:String]=[:]
    var selectedTree:Dictionary<String, Dictionary<String, Any>> = [:]
    
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
        let ref = Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let project_database = ref.child("trees").observe(.value, with: {snapshot in
            guard let trees_retrieved = snapshot.value as? Dictionary<String, Dictionary<String, Any>> else {
                return
            }
            for tree in trees_retrieved{
                self.selectedTree[tree.key] = tree.value
                self.treesNames.append(tree.value["latin_name"] as! String)
            }
        })
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
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 0;
        return treesNames.count;
    }

    
}
