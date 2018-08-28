//
//  HomeScreenViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 26/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit
import Firebase
import Spinners

class HomeScreenViewController: UIViewController {
    
    private let cellId = "QuizCell"
    var quizList : [QuizRoleTuple] = []
    var titleArray : [String] = []
    var currentUserId : String = ""
    
    @IBOutlet weak var tableView: UITableView!
    var spinners: Spinners!
    
    @IBAction func plusButtonClicked(_ sender: UIButton) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //logOutForTests()
        //createNewQuizForTests()

        // tableView layout
        tableView.backgroundColor = UIColor(red:0.21, green:0.31, blue:0.42, alpha:1.0)
        tableView.separatorStyle = .none
        
        // spinners setup
        spinners = Spinners(type: .bubble, with: self)
        spinners.setCustomSettings(borderColor: UIColor(red:0.25, green:0.76, blue:0.79, alpha:1), backgroundColor: UIColor(red:0.25, green:0.76, blue:0.79, alpha:0.6), alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.uid != nil {
            currentUserId = Auth.auth().currentUser!.uid
            fetchQuizList()
        } else {
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
    
    func createNewQuizForTests() {
        let newQuiz1 = Quiz(createdby: (Auth.auth().currentUser?.uid)!, entitled: "Math Quiz 101", description: "Just a math quiz", on: .Maths, questions: [], privacy: .Private)
        newQuiz1.collaborators.append("GG5b4ThKvrPGivA85AhlAhiuwUw2")
        newQuiz1.addQuestion(question: "What does make 1+1", answer: "2")
        newQuiz1.addQuestion(question: "Now, what does make 1*1", answer: "1")
        newQuiz1.addReview(rated: "4")
        newQuiz1.addReview(rated: "3", comment: "Moyen quoi")
        newQuiz1.save()
    }
    
    // MARK: - Database functions
    
    func fetchQuizList() {
        spinners.present()
        QuizListService.observeQuizList(currentUserId) { (quizList) in
            if let array = quizList?.quizList {
                self.quizList = array
                self.tableView.reloadData()
                self.fetchTitleList()
            }
            self.spinners.dismiss()
        }
    }
    
    func fetchTitleList() {
        for quiz in quizList {
            QuizService.observeQuiz(quiz.quizId) { (quiz) in
                if let newQuiz = quiz {
                    self.titleArray.append(newQuiz.title)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Extenstion for TableView
// TODO: Onclick Segue
extension HomeScreenViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! QuizTableViewCell

        cell.backgroundColor = .clear
        cell.quizNameLabel.text = titleArray[indexPath.row]
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
