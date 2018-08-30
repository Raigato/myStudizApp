//
//  CollaboratorsViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 30/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CollaboratorsViewController: UIViewController {

    var collaborators: [(String, String, Bool)] = [("GG5b4ThKvrPGivA85AhlAhiuwUw2", "test2@gmail.com", true), ("msArIDm0qZSKU7JGpzOh2fTAWOi1", "test3@gmail.com", false)]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView layout
        tableView.backgroundColor = UIColor(red:0.21, green:0.31, blue:0.42, alpha:1.0)
        tableView.separatorStyle = .none
        
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
