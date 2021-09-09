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
    var projects: [ProjectModel] = []
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
            self.tableView.register(UINib(nibName: "ProjectsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectsTableViewCell")
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.searchBar.delegate = self
        }
    }
    
    
    func getProjects(){
        
        for project in CurrentSession.sharedInstance.getProjecst() {
            let trees = project.project_trees
            let areas = project.project_areas
            self.projects.append(ProjectModel(project_name: project.project_name, project_description: project.project_description, project_status: project.project_status, project_trees: trees, project_areas: areas))
        }
        self.projectsTitles = CurrentSession.sharedInstance.getProjectsNames()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProjectsTableViewCell", for: indexPath) as! ProjectsTableViewCell
        tableViewCell.projects_name_label.text = filteredData[indexPath.row];
        
        if(self.projectsTitles.contains(filteredData[indexPath.row])){
            let project_found = self.getProject(name: filteredData[indexPath.row])
            tableViewCell.projects_trees_value.text = project_found["trees"]
            tableViewCell.projects_status_value.text = project_found["status"]
        }
        
        return tableViewCell;
    }
    
    func getProject(name: String)->[String:String]{
        var data:[String:String]=[:]
        for project in self.projects {
            if(project.project_name == name){
                data["name"] = project.project_name
                data["trees"] = String(project.project_trees)
                data["status"] = project.project_status
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
        return filteredData.count;
    }
    
    func getProjectSelected(name: String)->[String:String]{
        var data:[String:String]=[:]
        for project in self.projects{
            if(project.project_name == name){
                data["name"] = project.project_name
                data["trees"] = String(project.project_trees)
                data["status"] = project.project_status
            }
        }
        return data
    }
    
    //When user select one item of the list
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.projectInfoToSend = self.getProjectSelected(name: filteredData[indexPath.row])
        performSegue(withIdentifier: "project_to_detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "project_to_detail" {
            //Create new View Controller
            let vc = segue.destination as! ProjectsDetailViewController
            vc.title=self.projectInfoToSend["name"]
            let index_project = CurrentSession.sharedInstance.searchForProjectCatalog(project_name: vc.title!)
            
            vc.project_areas = self.projects[index_project].project_areas
            vc.project_trees = self.projects[index_project].project_trees
            vc.project_description = self.projects[index_project].project_description
            vc.project_status = self.projects[index_project].project_status
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
