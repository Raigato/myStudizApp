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
    
    override func viewWillAppear(_ animated: Bool) {
        currentUserId = ""
        quizArray = []
        titleArray = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.uid != nil {
            currentUserId = Auth.auth().currentUser!.uid
            checkUserProfile()
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
        
        UserService.logOutUser(alertIn: self)
    }
    
    func createNewQuizForTests() {
        let newQuiz1 = Quiz(createdby: (Auth.auth().currentUser?.uid)!, entitled: "Math Quiz 101", description: "Just a math quiz", on: .Maths, questions: [], privacy: .Private)
        newQuiz1.collaborators.append("GG5b4ThKvrPGivA85AhlAhiuwUw2")
        newQuiz1.addQuestion(question: "What does make 1+1", answer: "2")
        newQuiz1.addQuestion(question: "Now, what does make 1*1", answer: "1")
        newQuiz1.addReview(by: currentUserId, rated: "4")
        newQuiz1.addReview(by: currentUserId, rated: "3", comment: "Moyen quoi")
        newQuiz1.save { (quizId) in }
    }
    
    // MARK: - Database functions
    
    func fetchQuizList() {
        spinners.present()
        quizArray = []
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
        titleArray = []
        for quiz in quizArray {
            QuizService.observeQuiz(quiz.quizId) { (quiz) in
                if let newQuiz = quiz {
                    self.titleArray.append(newQuiz.title)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func checkUserProfile() {
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
                        } else if newUsername.count > 16 {
                            alert.title = "New Username too long 😏"
                            alert.message = "Size matters in our database, could you please shrinken your username a bit?"
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
            } else {
                Auth.auth().currentUser?.reload(completion: { (err) in
                    if err != nil {
                        UserService.logOutUser(alertIn: self)
                        self.performSegue(withIdentifier: "goToSignUpScreen", sender: self)
                    } else {
                        if let emailIsVerified = Auth.auth().currentUser?.isEmailVerified {
                            if !emailIsVerified {
                                let defaults = UserDefaults.standard
                                
                                if let lastCheck = defaults.object(forKey: "lastEmailVerificationChecked") as? Date {
                                    let wasntCheckFor = DateInterval(start: lastCheck, end: Date()).duration / (24.0 * 3600.0)
                                    
                                    if wasntCheckFor > 1 {
                                        let alert = UIAlertController(title: "Email not verified yet 👮‍♀️", message: "It seems that you have not yet verified your email address.\nWould you like us to send you a new verification email?", preferredStyle: .alert)
                                        
                                        let pressYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                                            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                                if let errorMessage = error?.localizedDescription {
                                                    print("\(errorMessage)")
                                                }
                                            })
                                        })
                                        
                                        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                                        alert.addAction(pressYes)
                                        
                                        self.present(alert, animated: true) {
                                            let date = Date()
                                            defaults.set(date, forKey: "lastEmailVerificationChecked")
                                        }
                                    }
                                }
                            }
                        }
                    }
                })
            }
        }
    }
}

// MARK: - Extenstion for TableView
extension HomeScreenViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if titleArray.count < 1 {
            return 1
        }
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! QuizTableViewCell
        
        if titleArray.count < 1 {
            cell.backgroundColor = .clear
            cell.backgroundImage.isHidden = true
            cell.selectionStyle = .none
            cell.quizNameLabel.text = "Press + to create a new Quiz"
            cell.quizNameLabel.font = cell.quizNameLabel.font.withSize(20)
            cell.quizNameLabel.textAlignment = .center
        } else {
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.backgroundImage.isHidden = false
            cell.quizNameLabel.font = cell.quizNameLabel.font.withSize(30)
            cell.quizNameLabel.textAlignment = .left
            
            cell.quizNameLabel.text = titleArray[indexPath.row]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if titleArray.count > 0 {
            currentQuizId = quizArray[indexPath.row].quizId
            QuizService.observeQuiz(currentQuizId) { (quiz) in
                if let foundQuiz = quiz {
                    currentQuiz = foundQuiz
                    self.performSegue(withIdentifier: "fromHomeToChoseQuiz", sender: self)
                }
            }
        }
    }
}
