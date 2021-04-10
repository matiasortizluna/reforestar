//
//  ProjectsViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 08/04/2021.
//

import UIKit

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let myData = ["Primeiro","Segundo","Terceiro","Quarto","Quinto","Sexto","Septimo","Octavo","Noveno"]
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        filteredData = myData;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 0;
        return filteredData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        //tableViewCell.textLabel?.text = myData[indexPath.row]
        tableViewCell.nameLabelForCell.text = filteredData[indexPath.row];
        
        
        return tableViewCell;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText==""{
            filteredData=myData;
        }else{
            for data in myData {
                if data.lowercased().contains(searchText.lowercased()){
                    filteredData.append(data)
                }
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
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
