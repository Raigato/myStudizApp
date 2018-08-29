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
    
    var currentQuiz = Quiz(createdby: "", entitled: "", description: "", on: .Misc, questions: [])
    let dropper = Dropper(width: 320, height: 50)

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(currentQuiz.createDictionary())
        
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
    }

    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        if dropper.status == .hidden {
            dropper.showWithAnimation(0.15, options: Dropper.Alignment.left, button: categoryButton)
            dropper.items = Quiz.getAllCategories()
        } else {
            dropper.hideWithAnimation(0.15)
        }
    
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        // TODO: Prepare for Segue
        if titleTextField.text != "" && descriptionTextField.text != "" && categoryButton.titleLabel?.text != "" {
            currentQuiz = Quiz(createdby: Auth.auth().currentUser!.uid, entitled: titleTextField.text!, description: descriptionTextField.text!, on: QuizService.convertCategory(categoryButton.titleLabel?.text), questions: [])
            performSegue(withIdentifier: "goToAddQuestions", sender: self)
        } else {
            Helpers.displayAlert(title: "Invalid info", message: "You must provide a title, a description and a category", with: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddQuestions" {
            let nextViewController = segue.destination as! NewQuestionViewController
            nextViewController.currentQuiz = currentQuiz
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // -- Dismisses the keyboard when you touch the topbar
        
        self.view.endEditing(true)
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
