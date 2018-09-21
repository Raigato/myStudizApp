//
//  CommunityListViewController.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 20/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CommunityListViewController: UIViewController {
    
    private let cellId = "communityQuizCell"
    
    var displayedTitle: String = "View Title"
    
    let quizArray: [[String: String]] = [["name": "Test1", "category": "Maths", "author": "Sophia", "stars": "4.7", "questions": "25"]]

    @IBOutlet weak var viewTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        return cell
    }
}
