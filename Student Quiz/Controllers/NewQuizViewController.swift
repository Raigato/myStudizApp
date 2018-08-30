//
//  NewQuizViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 28/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit
import Firebase
import Dropper

class NewQuizViewController: UIViewController {
    
    let dropper = Dropper(width: 320, height: 50)

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dropper setup
        dropper.width = categoryButton.frame.width
        dropper.height = categoryButton.frame.height * 10
        dropper.cornerRadius = 5
        dropper.spacing = 0
        dropper.theme = .white
        dropper.cellColor = UIColor(red:0.37, green:0.37, blue:0.37, alpha:1.0)
        
        // Setting all required delegates
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        dropper.delegate = self
        
        // Button setting
        categoryButton.titleEdgeInsets.left = 15
        
        // Fill labels
        titleTextField.text = currentQuiz.title
        descriptionTextField.text = currentQuiz.description
        categoryButton.setTitle(currentQuiz.getCategory(), for: .normal)
    }
    
    // MARK: UI functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // -- Dismisses the keyboard when you touch the topbar
        
        self.view.endEditing(true)
    }
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        if dropper.status == .hidden {
            dropper.showWithAnimation(0.15, options: Dropper.Alignment.left, button: categoryButton)
            dropper.items = Quiz.getAllCategories()
        } else {
            dropper.hideWithAnimation(0.15)
        }
        
    }
    
    // MARK: Segue Handling
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if titleTextField.text != "" && descriptionTextField.text != "" && categoryButton.titleLabel?.text != "" {
            currentQuiz.creator = Auth.auth().currentUser!.uid
            currentQuiz.title = titleTextField.text!
            currentQuiz.description = descriptionTextField.text!
            currentQuiz.setCategory(category: categoryButton.titleLabel!.text!)
            
            if currentQuizId != "" {
                currentQuiz.save(in: currentQuizId) { (quizRed) in
                }
            }
            performSegue(withIdentifier: "goToAddQuestions", sender: self)
        } else {
            Helpers.displayAlert(title: "As it, your quiz won't be searchable 🕵️‍♀️", message: "You must provide a title, a description and a category", with: self)
        }
    }

}

// MARK: - TextField extension

extension NewQuizViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // -- Handles the press of the return button on a textField
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

// MARK: - Dropper extension

extension NewQuizViewController : DropperDelegate {
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        categoryButton.setTitle(contents, for: .normal)
    }
}
