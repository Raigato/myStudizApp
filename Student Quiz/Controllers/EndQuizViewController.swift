//
//  EndQuizViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 01/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class EndQuizViewController: UIViewController {
    
    var score: Int = 0
    var summary: [(Question, Bool)] = []
    var rating: Int = 0
    var comment: String = ""
    
    @IBOutlet var starButtons: [UIButton]!
    @IBOutlet weak var commentTextField: TopLeftPaddedTextField!
    @IBOutlet weak var congratulationsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        congratulationsLabel.text = "Congratulations!\nYour score: \(score)%"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Segue Handling
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToReview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToReview" {
            let reviewView = segue.destination as! ReviewViewController
            
            reviewView.summary = summary
        }
    }
    
    // MARK: Finish Button Handling
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        if rating > 0 {
            if let enteredComment = commentTextField.text {
                comment = enteredComment
            }
            if comment != "" {
                currentQuiz.addReview(by: UserService.currentUser(), rated: String(rating), comment: comment)
            } else {
                currentQuiz.addReview(by: UserService.currentUser(), rated: String(rating))
            }
            currentQuiz.save(in: currentQuizId) { (quizId) in }
        }
    }
    
    // MARK: Star Buttons Handling
    @IBAction func starButtonPressed(_ sender: UIButton) {
        rating = sender.tag
        updateUI()
    }
    
    func updateUI() {
        for button in starButtons {
            if button.tag <= rating {
                button.setBackgroundImage(UIImage(named: "Active Star"), for: .normal)
            } else {
                button.setBackgroundImage(UIImage(named: "Inactive Star"), for: .normal)
            }
        }
    }
}

// MARK: - TextField extension

extension EndQuizViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // -- Handles the press of the return button on a textField
        
        textField.resignFirstResponder()
        return true
    }
}
