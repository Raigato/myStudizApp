//
//  ViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 21/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    //TODO: Forgotten password, Username, Remove No Thanks

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // -- Dismisses the keyboard when you touch the topbar
        
        self.view.endEditing(true)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        // -- Handles the press of the submitButton
        
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        
        // Verify the form
        if EmailTextField.text == "" || PasswordTextField.text == "" {
            Helpers.displayAlert(title: "Missing credentials", message: "You must provide both an email and a password", with: self)
        } else {
            if let email = EmailTextField.text {
                if let password = PasswordTextField.text {
                    // Create account
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        if error != nil {
                            let errorMessage = error!.localizedDescription
                            // If Error -> Sign in
                            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                if error != nil {
                                    Helpers.displayAlert(title: "Invalid credentials", message: errorMessage, with: self)
                                }
                                self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
                            })
                        } else {
                            self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
                        }
                    }
                }
            }
        }
    }
    
}

// MARK: - TextField extension

extension CreateAccountViewController : UITextFieldDelegate {
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

