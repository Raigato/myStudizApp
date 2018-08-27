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
    
    private let cellId = "QuizCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //logOutForTests()

        // tableView layout
        tableView.backgroundColor = UIColor(red:0.21, green:0.31, blue:0.42, alpha:1.0)
        tableView.separatorStyle = .none
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

// MARK: - Extenstion for TableView
// TODO: Make it use Firebase
extension HomeScreenViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! QuizTableViewCell

        cell.backgroundColor = .clear
        cell.quizNameLabel.text = "Quiz \(indexPath.row + 1)"
        
        return cell
    }
}
