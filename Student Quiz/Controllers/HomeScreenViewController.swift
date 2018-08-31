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

var currentQuizId: String = ""
var currentQuiz = Quiz(createdby: "", entitled: "", description: "", on: .Misc, questions: [])

class HomeScreenViewController: UIViewController {
    
    private let cellId = "QuizCell"
    var quizArray : [QuizRoleTuple] = []
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
            setUsername()
            fetchQuizList()
        } else {
            performSegue(withIdentifier: "goToSignUpScreen", sender: self)
        }
        
        currentQuizId = ""
        currentQuiz = Quiz(createdby: "", entitled: "", description: "", on: .Misc, questions: [])
    }
    
    
    // MARK: - Tests helper functions
    
    func logOutForTests() {
        // -- Log out the user for tests purposes
        
        do {
            try Auth.auth().signOut()
        } catch {
            // TODO: Changer ce print
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
        newQuiz1.save { (quizId) in }
    }
    
    // MARK: - Database functions
    
    func fetchQuizList() {
        spinners.present()
        QuizListService.observeQuizList(currentUserId) { (quizList) in
            if let array = quizList?.quizList {
                self.quizArray = array
                self.fetchTitleList()
                self.tableView.reloadData()
            }
            self.spinners.dismiss()
        }
    }
    
    func fetchTitleList() {
        for quiz in quizArray {
            QuizService.observeQuiz(quiz.quizId) { (quiz) in
                if let newQuiz = quiz {
                    self.titleArray.append(newQuiz.title)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setUsername() {
        UserService.getUserProfile(uid: currentUserId) { (user) in
            if user["username"] == "" {
                var textField = UITextField()
                let alert = UIAlertController(title: "No Username chosen yet 😕", message: "Please choose your username so you will be able to share Quizzes with your friends!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Choose username", style: .default, handler: { (action) in
                    if let newUsername = textField.text {
                        if newUsername == "" {
                            alert.title = "No Username entered 😏"
                            alert.message = "It seems that you tried to trick us!\nWould you mind setting a true username?"
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            UserService.usernameAlreadyExists(username: newUsername, completion: { (exists) in
                                if exists {
                                    alert.title = "Username already taken 😕"
                                    alert.message = "It seems that someone stole your username \(newUsername)!\nWould you mind setting a new one?"
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    UserService.createUserProfile(uid: self.currentUserId, email: user["email"]!, username: newUsername)
                                }
                            })
                        }
                    }
                })
                alert.addTextField(configurationHandler: { (alertTextField) in
                    alertTextField.placeholder = "Username"
                    textField = alertTextField
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
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
        cell.selectionStyle = .none
        
        cell.quizNameLabel.text = titleArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentQuizId = quizArray[indexPath.row].quizId
        QuizService.observeQuiz(currentQuizId) { (quiz) in
            if let foundQuiz = quiz {
                currentQuiz = foundQuiz
            }
        }
        performSegue(withIdentifier: "goToChoseQuiz", sender: self)
    }
}
