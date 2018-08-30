//
//  CollaboratorsViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 30/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CollaboratorsViewController: UIViewController {

    var collaborators: [(String, String, Bool)] = []
    
    @IBOutlet weak var searchBarTextField: SearchPaddedTextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarTextField.delegate = self
        
        // tableView layout
        tableView.backgroundColor = UIColor(red:0.21, green:0.31, blue:0.42, alpha:1.0)
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCollaborators()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // -- Dismisses the keyboard when you touch the topbar
        
        self.view.endEditing(true)
    }

    // MARK: Set Collaborators array function
    
    func setCollaborators() {
        for collaboratorId in currentQuiz.collaborators {
            UserService.getUserProfile(uid: collaboratorId) { (userInfo) in
                if userInfo != [:] {
                    print((collaboratorId, userInfo["username"]!, true))
                    self.collaborators.append((collaboratorId, userInfo["username"]!, true))
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

// MARK: TableView Extension

extension CollaboratorsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collaborators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorCell", for: indexPath) as! CollaboratorTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let collaborator = collaborators[indexPath.row]
        
        cell.isChecked(collaborator.2)
        cell.usernameLabel.text = "\(collaborator.1)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collaborator = collaborators[indexPath.row]
        
        collaborators[indexPath.row].2 = !collaborator.2
        
        if !collaborator.2 {
            currentQuiz.addCollaborator(uid: collaborator.0)
        } else {
            currentQuiz.deleteCollaborator(uid: collaborator.0)
        }
        
        tableView.reloadData()
    }
}

// MARK: - TextField extension

extension CollaboratorsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // -- Handles the press of the return button on a textField
        textField.resignFirstResponder()
        return false
    }
}
