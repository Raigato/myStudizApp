//
//  CommunityListViewController.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 20/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

//TODO: For test only
struct cellData {
    let name: String
    let category: String
    let author: String
    let rating: String
    let questions: String
}

class CommunityListViewController: UIViewController {
    
    private let cellId = "communityQuizCell"
    
    var displayedTitle: String = "View Title"
    
    let quizArray: [cellData] = [cellData.init(name: "Test1", category: "Maths", author: "Amanda", rating: "4.7", questions: "38"),
                                 cellData.init(name: "Test2", category: "Literature", author: "John", rating: "3.8", questions: "52")]

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
        cell.quizNameLabel.text = quizArray[indexPath.row].name
        cell.categoryLabel.text = quizArray[indexPath.row].category
        cell.setAuthor(quizArray[indexPath.row].author)
        cell.ratingLabel.text = quizArray[indexPath.row].rating
        cell.questionsCountLabel.text = quizArray[indexPath.row].questions
        
        return cell
    }
}
