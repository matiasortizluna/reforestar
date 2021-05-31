import UIKit

class CatalogViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var myData:[String] = ["Primeiro","Segundo","Terceiro","Quarto","Quinto","Sexto","Septimo","Octavo","Noveno"]
    
    var treesCatalog:[String:NSDictionary] = [String():NSDictionary()]
    
    var titleToSend = ""
    
    override func viewDidLoad() {
        
        print(treesCatalog)
        
        // Do any additional setup after loading the view.
        //
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        super.viewDidLoad()

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
