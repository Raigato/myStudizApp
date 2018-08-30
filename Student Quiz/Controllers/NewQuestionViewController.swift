//
//  NewQuestionViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 29/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit
import Firebase

class NewQuestionViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: LeftPaddedTextField!
    @IBOutlet weak var answerLabel: LeftPaddedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Segues handling
    
    @IBAction func moreQuestionButtonPressed(_ sender: UIButton) {
        if formIsValid() {
            appendQuestion()
            questionLabel.text = ""
            answerLabel.text = ""
            if currentQuizId != "" {
                currentQuiz.save(in: currentQuizId) { (quizId) in }
            } else {
                currentQuiz.privacy = .Private
                currentQuiz.save { (quizId) in
                    currentQuizId = quizId
                }
            }
        } else {
            Helpers.displayAlert(title: "Invalid info", message: "You must provide a question and an answer", with: self)
        }
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        // TODO: Bug - Need to click twice
        
        if formIsValid() {
            appendQuestion()
            if currentQuizId != "" {
                currentQuiz.save(in: currentQuizId) { (quizId) in
                    self.finishButtonAfterSave()
                }
            } else {
                currentQuiz.privacy = .Private
                currentQuiz.save { (quizId) in
                    currentQuizId = quizId
                    self.finishButtonAfterSave()
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
    }
    
    // MARK: Helper functions
    
    func formIsValid() -> Bool {
        if questionLabel.text != "" && answerLabel.text != "" {
            return true
        } else {
            return false
        }
    }
    
    func appendQuestion() {
        if questionLabel.text != "" && answerLabel.text != "" {
            currentQuiz.addQuestion(question: questionLabel.text!, answer: answerLabel.text!)
        }
    }
    
    func chooseSegue(role: Role) {
        // TODO: Adding more Segue
        
        if role == .Owner {
            performSegue(withIdentifier: "goToPrivacy", sender: self)
        } else {
            print("No Segue implemented yet")
        }
    }
    
    func finishButtonAfterSave() {
        if currentQuiz.questions.count < 1 {
            Helpers.displayAlert(title: "Invalid info", message: "You must add at least one question to go further", with: self)
        } else {
            QuizListService.getRoleForUser(uid: Auth.auth().currentUser!.uid, quizId: currentQuizId) { (role) in
                if let fetchedRole = role {
                    self.chooseSegue(role: fetchedRole)
                }
            }
        }
    }
}
