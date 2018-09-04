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
    
    var role: Role = .Owner
    
    @IBOutlet weak var questionLabel: LeftPaddedTextField! // TODO: Are Text Fields
    @IBOutlet weak var answerLabel: LeftPaddedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.delegate = self
        answerLabel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: Test with other roles
        if currentQuizId != "" {
            QuizListService.getRoleForUser(uid: Auth.auth().currentUser!.uid, quizId: currentQuizId) { (role) in
                if let fetchedRole = role {
                    self.role = fetchedRole
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
            Helpers.displayAlert(title: "Forgot something? 🤷‍♂️", message: "You must provide a question and its answer", with: self)
        }
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        if formIsValid() {
            appendQuestion()
        }

        if currentQuiz.questions.count < 1 {
            Helpers.displayAlert(title: "A Quiz without Questions 🤔", message: "You must add at least one question (and its answer) to go further", with: self)
        } else if !formIsValid() && (questionLabel.text != "" || answerLabel.text != "") {
            Helpers.displayAlert(title: "Forgot something? 🤷‍♂️", message: "You must provide a question and its answer", with: self)
        } else {
            finishButtonHandler()
        }
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
        if role == .Owner {
            performSegue(withIdentifier: "goToPrivacy", sender: self)
        }
        if role == .Collaborator {
            performSegue(withIdentifier: "fromNewQuestionToChoseQuiz", sender: self)
        }
    }
    
    func finishButtonHandler() {
        if currentQuizId != "" {
            currentQuiz.save(in: currentQuizId) { (quizId) in
                self.chooseSegue(role: self.role)
            }
        } else {
            currentQuiz.privacy = .Private
            currentQuiz.save { (quizId) in
                currentQuizId = quizId
                self.chooseSegue(role: self.role)
            }
        }
    }
}

// MARK: - TextField extension

extension NewQuestionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // -- Handles the press of the return button on a textField
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
