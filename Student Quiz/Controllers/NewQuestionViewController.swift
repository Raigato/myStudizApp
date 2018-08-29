//
//  NewQuestionViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 29/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

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
            shouldSave()
        } else {
            Helpers.displayAlert(title: "Invalid info", message: "You must provide a question and an answer", with: self)
        }
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        // TODO: Add Segue
        if formIsValid() {
            appendQuestion()
        }
        shouldSave()
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
    
    func shouldSave() {
        if currentQuizId != "" {
            currentQuiz.save(in: currentQuizId)
        } else {
            currentQuiz.privacy = .Private
            currentQuiz.save()
        }
    }
}
