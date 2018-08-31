//
//  CollaboratorsViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 30/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CollaboratorsViewController: UIViewController {

    var displayedUsers: [(String, String, Bool)] = []
    lazy var allUsers: [(String, String, Bool)] = []
    
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
        loadAllUsers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // -- Dismisses the keyboard when you touch the topbar
        
        self.view.endEditing(true)
    }

    // MARK: Set Collaborators array function
    
    func setCollaborators() {
        displayedUsers = []
        for collaboratorId in currentQuiz.collaborators {
            UserService.getUserProfile(uid: collaboratorId) { (userInfo) in
                if userInfo != [:] {
                    self.displayedUsers.append((collaboratorId, userInfo["username"]!, true))
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Get All users
    
    func loadAllUsers() {
        allUsers = []
        UserService.getAllUsers { (users) in
            for user in users {
                if !UserService.isActiveUser(uid: user) {
                    let isCollab = currentQuiz.collaborators.contains(user)
                    UserService.getUserProfile(uid: user, completion: { (userInfo) in
                        if userInfo != [:] {
                            self.allUsers.append((user, userInfo["username"]!, isCollab))
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
    }
    
    // MARK: Add and Remove Collaborators
    
    func addCollaborator(uid: String) {
        currentQuiz.addCollaborator(uid: uid)
    }
    
    func removeCollaborator(uid: String) {
        currentQuiz.deleteCollaborator(uid: uid)
        QuizListService.removeQuizForUser(for: uid, quiz: currentQuizId)
    }
}

// MARK: TableView Extension

extension CollaboratorsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayedUsers.count > 0 {
            return displayedUsers.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorCell", for: indexPath) as! CollaboratorTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if displayedUsers.count > 0 {
            cell.checkbox.isHidden = false
            cell.checkmark.isHidden = false
            
            let collaborator = displayedUsers[indexPath.row]
            
            cell.isChecked(collaborator.2)
            cell.usernameLabel.text = "\(collaborator.1)"
        } else {
            cell.checkbox.isHidden = true
            cell.checkmark.isHidden = true
            cell.usernameLabel.text = "No users found"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collaborator = displayedUsers[indexPath.row]
        
        displayedUsers[indexPath.row].2 = !collaborator.2
        
        if !collaborator.2 {
            addCollaborator(uid: collaborator.0)
        } else {
            removeCollaborator(uid: collaborator.0)
        }
        loadAllUsers()
        currentQuiz.save(in: currentQuizId) { (quizId) in }
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldSize = textField.text?.count else { fatalError("Unable to get the size of the textField") }
        if textFieldSize <= 1 && string == "" {
            setCollaborators()
        } else {
            displayedUsers = []
            
            let newEntry = textField.text! + string
            
            for user in allUsers {
                if user.1.hasPrefix(newEntry) {
                    displayedUsers.append(user)
                }
            }
            tableView.reloadData()
        }
        return true
    }
}
