//
//  ReviewViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 02/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    var summary: [(Question, Bool)] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extenstion for TableView
extension ReviewViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        
        cell.questionLabel.text = summary[indexPath.row].0.question
        cell.answerLabel.text = summary[indexPath.row].0.answer
        cell.isRight(summary[indexPath.row].1)
        
        return cell
    }

}
