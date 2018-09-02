//
//  RunQuizViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 31/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class RunQuizViewController: UIViewController {
    // TODO: Add "alerts" on validate to notify the user
    
    var currentQuestionNo: Int = 0
    lazy var score: Int = 0
    lazy var questions: [(Question, Bool)] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: LeftPaddedTextField!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        setTitle()
        getQuestions()
        updateUI()
    }
    
    @IBAction func validateButtonPressed(_ sender: UIButton) {
        answerTextField.resignFirstResponder()
        if currentQuestionNo < questions.count - 1 {
            nextQuestion()
        } else {
            verifyAnswer()
            performSegue(withIdentifier: "goToResults", sender: self)
        }
    }
    
    // MARK: UI functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setTitle() {
        titleLabel.text = Helpers.reduceTitle(currentQuiz.title)
    }
    
    func updateUI() {
        // -- Reinit Form
        questionLabel.text = questions[currentQuestionNo].0.question
        answerTextField.text = ""
        
        // -- Update Progress
        scoreLabel.text = "Score: \(calculateScore()) %"
        // Format numbers
        var questionNo = ""
        if currentQuestionNo < 9 {
            questionNo = "0\(currentQuestionNo + 1)"
        } else {
            questionNo = "\(currentQuestionNo + 1)"
        }
        var numberOfQuestions = ""
        if questions.count < 9 {
            numberOfQuestions = "0\(questions.count)"
        } else {
            numberOfQuestions = "\(questions.count)"
        }
        progressLabel.text = "Question: \(questionNo)/\(numberOfQuestions)"
        progressBar.progress = Float(currentQuestionNo + 1)/Float(questions.count)
    }
    
    func verifyAnswer() {
        let rightAnswer = questions[currentQuestionNo].0.answer.lowercased().folding(options: .diacriticInsensitive, locale: .current).trimmingCharacters(in: .whitespaces)
        let userAnswer = answerTextField.text?.lowercased().folding(options: .diacriticInsensitive, locale: .current).trimmingCharacters(in: .whitespaces)
        
        if userAnswer == rightAnswer {
            score += 1
            questions[currentQuestionNo].1 = true
        }
    }
    
    func calculateScore() -> Int {
        return Int(Double(score)/Double(questions.count) * 100)
    }
    
    func nextQuestion() {
        verifyAnswer()
        currentQuestionNo += 1
        updateUI()
    }
    
    // MARK: Question handling functions
    
    func getScore() {
        
    }
    
    func getQuestions() {
        if currentQuiz.questions.count <= 20 {
            var questionArray = currentQuiz.questions
            while questions.count < currentQuiz.questions.count {
                let pick = Int(arc4random_uniform(UInt32(questionArray.count)))
                questions.append((questionArray[pick], false))
                questionArray.remove(at: pick)
            }
        } else {
            var questionArray = currentQuiz.questions
            while questions.count < 20 {
                let pick = Int(arc4random_uniform(UInt32(questionArray.count)))
                questions.append((questionArray[pick], false))
                questionArray.remove(at: pick)
            }
        }
    }
    
    // MARK: Segue Handling
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let nextView = segue.destination as! EndQuizViewController
            nextView.score = calculateScore()
            nextView.summary = questions
        }
    }
    
}

// MARK: - TextField extension

extension RunQuizViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // -- Handles the press of the return button on a textField
        
        textField.resignFirstResponder()
        return true
    }
}
