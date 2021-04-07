//
//  UserProfileViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 07/04/2021.
//

import UIKit

class UserProfileViewController: UIViewController {

    
    @IBOutlet weak var configuration_item: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapConfigurationItem(){
        navigationController?.pushViewController(ConfigurationViewController(), animated: true)
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
