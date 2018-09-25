//
//  CommunityListViewController.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 20/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

struct quizCellData {
    let title: String
    let category: String
    let author: String
    let rating: Double
    let questions: Int
}

class CommunityListViewController: UIViewController {
    
    private let cellId = "communityQuizCell"
    
    var displayedTitle: String = "View Title"
    
    var quizArray: [quizCellData] = []

    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView layout
        tableView.backgroundColor = UIColor(red:0.21, green:0.31, blue:0.42, alpha:1.0)
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        viewTitle.text = displayedTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK: TableView extension

extension CommunityListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommunityQuizTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.quizNameLabel.text = quizArray[indexPath.row].title
        cell.categoryLabel.text = quizArray[indexPath.row].category
        
        UserService.getUserProfile(uid: quizArray[indexPath.row].author) { (userInfo) in
            if let username = userInfo["username"] {
                cell.setAuthor(username)
            }
        }
        
        cell.ratingLabel.text = String(quizArray[indexPath.row].rating)
        cell.questionsCountLabel.text = String(quizArray[indexPath.row].questions)
        
        return cell
    }
}
