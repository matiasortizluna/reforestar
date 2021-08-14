//
//  ProjectsViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 08/04/2021.
//

import UIKit
import Firebase
import SwiftyJSON
import SwiftUI

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var projectsTitles:[String] = []
    var filteredData: [String]!
    var projectInfoToSend :[String:String]=[:]
    var projects:Dictionary<String, Dictionary<String, Any>> = [:]
    var selectedProject:Dictionary<String, Dictionary<String, Any>> = [:]
    
    override func viewDidLoad() {
        //Load Default Information
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always

        //Retreive Projects Information
        self.getProjects()
        
        //Code to de delayed
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.filteredData = self.projectsTitles;
            
            //Additional setup after loading the view.
            self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.searchBar.delegate = self
        }
    }
    
    
    func getProjects(){
        
        self.projects = CurrentSession.sharedInstance.getProjecstFull()
        self.projectsTitles = CurrentSession.sharedInstance.getAllProjects()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        tableViewCell.nameLabelForCell.text = filteredData[indexPath.row];
        
        if(self.projectsTitles.contains(filteredData[indexPath.row])){
            let project_found = self.getProject(name: filteredData[indexPath.row])
            tableViewCell.treesValueLabel.text = project_found["trees"]
            tableViewCell.sizeValueLabel.text = project_found["size"]
            tableViewCell.statusLabel.text = project_found["status"]
        }
        
        return tableViewCell;
    }
    
    func getProject(name: String)->[String:String]{
        var data:[String:String]=[:]
        for project in self.projects{
            if(project.value["name"] as! String==name){
                data["name"]=(project.value["name"] as! String)
                data["trees"]="12"
                data["status"]=(project.value["availability"] as! String)
                //data["size"]=(project.value["size"] as! String)
                data["size"] = "0"
            }
        }
        return data
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText==""{
            filteredData=projectsTitles;
        }else{
            for data in projectsTitles {
                if data.lowercased().contains(searchText.lowercased()){
                    filteredData.append(data)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    //Default function for Table View to work
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 0;
        return filteredData.count;
    }
    
    func getProjectSelected(name: String)->[String:String]{
        var data:[String:String]=[:]
        for project in self.projects{
            if(project.value["name"] as! String==name){
                data["trees"]="12"
                /*
                if(project.value["trees"] != nil){
                    let trees:[Any] = project.value["trees"] as! Array
                    data["trees"]=String(trees.count)
                }
                */
                data["name"]=(project.value["name"] as! String)
                data["status"]=(project.value["availability"] as! String)
                data["size"]="12"
            }
        }
        return data
    }
    
    //When user select one item of the list
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Which title will send
        self.projectInfoToSend = self.getProjectSelected(name: filteredData[indexPath.row])
        //Prepare for next page
        performSegue(withIdentifier: "project_to_detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "project_to_detail" {
            //Create new View Controller
            let vc = segue.destination as! ProjectsDetailViewController
            //Pass Project Information to New Controller
            vc.title=self.projectInfoToSend["name"]
            //vc.label1.text = self.projectInfoToSend["trees"]
            //vc.label2.text = self.projectInfoToSend["status"]
            //vc.label3.text = self.projectInfoToSend["size"]
            
        }
    }
    
    //AUXILIAR FUNCTIONS FOR SEARCH BAR
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
}
