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

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        
        // Adding padding to the Text Fields
        let emailPaddingView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 15, height: EmailTextField.frame.height)))
        EmailTextField.leftView = emailPaddingView
        EmailTextField.leftViewMode = UITextFieldViewMode.always
        
        let passwordPaddingView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 15, height: PasswordTextField.frame.height)))
        PasswordTextField.leftView = passwordPaddingView
        PasswordTextField.leftViewMode = UITextFieldViewMode.always
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // -- Dismisses the keyboard when you touch the topbar
        
        self.view.endEditing(true)
    }

    @IBAction func noThanksPressed(_ sender: UIButton) {
        // -- Handles the press of the noThanksButton
        
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        
        performSegue(withIdentifier: "goToHomeScreen", sender: self)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        // -- Handles the press of the submitButton
        
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        
        // Verify the form
        if EmailTextField.text == "" || PasswordTextField.text == "" {
            displayAlert(title: "Missing credentials", message: "You must provide both an email and a password")
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
                                    self.displayAlert(title: "Invalid credentials", message: errorMessage)
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
    
    // MARK: - helper functions
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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

