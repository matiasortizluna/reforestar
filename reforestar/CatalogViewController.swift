import UIKit
import Firebase

class CatalogViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var myData = ["Primeiro","Segundo","Terceiro","Quarto","Quinto","Sexto","Septimo","Octavo","Noveno"]
    
    //var myData: [AnyObject] = []
    
    var titleToSend = ""
    
    func getCatalogInfo(){
        let ref = Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let catalog = ref.child("trees").observe(.value, with: {snapshot in
            guard let information = snapshot.value as? [AnyObject] else {
                print("ERRORORSROASOROR")
                return
            }
            print("This is infomation \(information)")
            for info in information {
                //print (info)
            }
            
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.getCatalogInfo()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 0;
        return myData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        //tableViewCell.textLabel?.text = myData[indexPath.row]
        tableViewCell.nameLabelForCell.text = myData[indexPath.row];
        
        return tableViewCell;
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.segmentedControl.isHidden=false;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.titleToSend = myData[indexPath.row]
        performSegue(withIdentifier: "catalog_to_detail", sender: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="catalog_to_detail"){
            let vc = segue.destination as! CatalogDetailViewController
            vc.title = self.titleToSend
            
        }
    }

    
}
