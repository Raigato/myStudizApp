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
    
    //TODO: Forgotten password, Add email verification

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
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Password requested 🤷‍♀️", message: "Please an enter your email to receive a new password", preferredStyle: .alert)
        let action = UIAlertAction(title: "Submit", style: .default) { (action) in
            if let email = textField.text {
                if !Helpers.isValidEmail(testStr: email) {
                    Helpers.displayAlert(title: "Invalid Email 👮‍♀️", message: "Please enter a valid email address", with: self)
                } else {
                    UserService.passwordReset(withEmail: email, alertIn: self)
                    Helpers.displayAlert(title: "New Password Sent 📬", message: "We have sent you an email at \(email) so you can reinitialize your password", with: self)
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Email address..."
            textField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        // -- Handles the press of the submitButton
        
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        
        // Verify the form
        if EmailTextField.text == "" || PasswordTextField.text == "" {
            Helpers.displayAlert(title: "Missing credentials 👮‍♀️", message: "You must provide both an email and a password", with: self)
        } else {
            guard let email = EmailTextField.text, let password = PasswordTextField.text else {
                Helpers.displayAlert(title: "Missing credentials 👮‍♀️", message: "You must provide both an email and a password", with: self)
                return
            }

            // Create account
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    let errorMessage = error!.localizedDescription
                    // If Error -> Sign in
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                        if error != nil {
                            Helpers.displayAlert(title: "Invalid credentials 👮‍♂️", message: errorMessage, with: self)
                        }
                        self.dismiss(animated: true, completion: nil)
                    })
                } else {
                    UserService.createUserProfile(uid: result!.user.uid, email: email)
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        print("Error sending the verification email")
                    })
                    self.dismiss(animated: true, completion: nil)
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

