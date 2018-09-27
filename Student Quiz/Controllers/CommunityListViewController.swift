//
//  CommunityListViewController.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 20/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit
import Spinners

struct quizCellData {
    let id: String
    let title: String
    let category: String
    let author: String
    let rating: Double
    let displayedRating: Double
    let questions: Int
}

class CommunityListViewController: UIViewController {
    
    private let cellId = "communityQuizCell"
    
    var displayedTitle: String = "View Title"
    
    var quizArray: [quizCellData] = []
    var displayedQuizzes: [quizCellData] = []

    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarTextField: SearchPaddedTextField!
    var spinners: Spinners!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarTextField.delegate = self
        
        // tableView layout
        tableView.backgroundColor = UIColor(red:0.21, green:0.31, blue:0.42, alpha:1.0)
        tableView.separatorStyle = .none
        
        // spinners setup
        spinners = Spinners(type: .bubble, with: self)
        spinners.setCustomSettings(borderColor: UIColor(red:0.25, green:0.76, blue:0.79, alpha:1), backgroundColor: UIColor(red:0.25, green:0.76, blue:0.79, alpha:0.6), alpha: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        spinners.present()
        viewTitle.text = displayedTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setDisplayedQuizzes()
        spinners.dismiss()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Set displayedQuizzes array
    
    func setDisplayedQuizzes() {
        displayedQuizzes = quizArray
        tableView.reloadData()
    }

}

//MARK: TableView extension

extension CommunityListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedQuizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommunityQuizTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.quizNameLabel.text = displayedQuizzes[indexPath.row].title
        cell.categoryLabel.text = displayedQuizzes[indexPath.row].category
        
        UserService.getUserProfile(uid: displayedQuizzes[indexPath.row].author) { (userInfo) in
            if let username = userInfo["username"] {
                cell.setAuthor(username)
            }
        }
        
        cell.ratingLabel.text = String(displayedQuizzes[indexPath.row].displayedRating)
        cell.questionsCountLabel.text = String(displayedQuizzes[indexPath.row].questions)
        
        return cell
    }
}

// MARK: - TextField extension

extension CommunityListViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // -- Handles the press of the return button on a textField
        
        textField.resignFirstResponder()
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldSize = textField.text?.count else { fatalError("Unable to get the size of the textField") }
        if textFieldSize <= 1 && string == "" {
            setDisplayedQuizzes()
        } else {
            displayedQuizzes = []
            
            let newEntry = Helpers.getExtraflatString(textField.text! + string)
            
            for quiz in quizArray {
                var shouldBeAdded = false
                if Helpers.getExtraflatString(quiz.title).range(of: newEntry) != nil {
                    shouldBeAdded = true
                } else if Helpers.getExtraflatString(quiz.category).range(of: newEntry) != nil {
                    shouldBeAdded = true
                } //TODO: Add for Author
                
                if shouldBeAdded {
                    displayedQuizzes.append(quiz)
                }
            }
            tableView.reloadData()
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentQuizId = quizArray[indexPath.row].id
        QuizService.observeQuiz(currentQuizId) { (quiz) in
            if let foundQuiz = quiz {
                currentQuiz = foundQuiz
                self.performSegue(withIdentifier: "goToCommunityQuiz", sender: self)
            }
        }
    }
}
