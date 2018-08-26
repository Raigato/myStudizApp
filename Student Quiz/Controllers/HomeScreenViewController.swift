//
//  HomeScreenViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 26/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var uidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //logOutForTests()
        
        if let uid = Auth.auth().currentUser?.uid {
            uidLabel.text = uid
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // -- If user not logged in, redirect to account creation
        if Auth.auth().currentUser?.uid == nil {
            performSegue(withIdentifier: "goToSignUpScreen", sender: self)
        }
    }
    
    
    // MARK: - Tests helper functions
    
    func logOutForTests() {
        // -- Log out the user for tests purposes
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("ça bug tamer")
        }
    }
    
}
