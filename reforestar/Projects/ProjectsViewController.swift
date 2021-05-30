//
//  ProjectsViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 08/04/2021.
//

import UIKit
import Firebase
import SwiftyJSON

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let myData = ["Primeiro","Segundo","Terceiro","Quarto","Quinto","Sexto","Septimo","Octavo","Noveno"]
    
    var filteredData: [String]!
    var titleToSend = ""
    var projects: [AnyObject] = []
    
    override func viewDidLoad() {
        //Load Default Information
        super.viewDidLoad()
        //Retreive Projects Information
        self.getProjects()
        
        //Code to de delayed
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
         
        //print(self.projects)
        
        //Additional setup after loading the view.
            
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        self.filteredData = self.myData;

        }
        
    }
    
    func getProjects(){
        let ref = Database.database(url: "https://reforestar-database-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let project_database = ref.child("projects").observe(.value, with: {snapshot in
            guard let payloads = snapshot.value as? [AnyObject] else {
                return
            }
            for payload in payloads{
                self.projects.append(payload)
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 0;
        //Return filtered data.
        return filteredData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        //tableViewCell.textLabel?.text = myData[indexPath.row]
        tableViewCell.nameLabelForCell.text = filteredData[indexPath.row];
        
        let data = self.fillCellInformation(name: filteredData[indexPath.row]);
        
        print(data["trees"] as AnyObject)
        //tableViewCell.treesValueLabel.text = data["trees"] as? String
        
        return tableViewCell;
    }
    
    func fillCellInformation(name: String) -> AnyObject{
        var project_sent: AnyObject = [] as AnyObject
        for project in self.projects {
            if(project["full_name"] as! String==name){
                project_sent = project
            }
        }
        return project_sent;
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me")
        self.titleToSend = filteredData[indexPath.row]
        
        performSegue(withIdentifier: "project_to_detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "project_to_detail" {
            
            var vc = segue.destination as! ProjectsDetailViewController
            //vc.titleReceived=self.titleToSend
            vc.title=self.titleToSend
        }
    }
    
}
