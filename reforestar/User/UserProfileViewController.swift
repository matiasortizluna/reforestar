//
//  UserProfileViewController.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 07/04/2021.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        if(Auth.auth().currentUser == nil){
            print("Do you want to log in ?")
        }
    }
    
    
    /*
    @IBAction func didTapActionButton(_ sender: Any) {
        
        if(Auth.auth().currentUser == nil){
            
            Auth.auth().signIn(withEmail: "matiasarielortiz2001@gmail.com", password: "12345678") { [weak self] authResult, error in
                guard let strongSelf = self else {
                    print("Inside Strong Self 1")
                    return
                }
                guard error == nil else {
                    print("Error singing in. Creating account")
                    
                    Auth.auth().createUser(withEmail: "matiasariel2001@outlook.com", password: "12345678"){ [weak self] authResult, error in
                        guard let strongSelf = self else {
                            print("Inside Strong Self 2")
                            return
                        }
                        guard error == nil else {
                            print("Error creating account")
                            return
                        }
                        print("User created sucessfully")
                        return
                    }
    
                    return
                }
                print("You have signed in")
                return
            }
            
        }else{
            do {
                try Auth.auth().signOut()
                print("Signed out")
            } catch  {
                print("An error ocurred")
            }
            
        }
        
    }
 */
    
}
