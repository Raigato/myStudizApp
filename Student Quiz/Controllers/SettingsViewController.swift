//
//  SettingsViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 04/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    lazy var feedback: Feedback = .Happy

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Implement delete account functionnality
        deleteAccountButton.isHidden = true
        
        setTitleWithUsername()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showFeedbackPrompt()
    }
    
    // MARK: - Set username as title
    
    func setTitleWithUsername() {
        UserService.getUserProfile(uid: UserService.currentUser()) { (userProfile) in
            if let username = userProfile["username"] {
                if username.count < 12 {
                    self.titleLabel.text = "\(username)'s settings"
                } else if username.count < 18 {
                    self.titleLabel.text = "\(username)"
                } else {
                    self.titleLabel.text = "Settings"
                }
            }
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Change Password
    
    @IBAction func changePasswordButtonPressed(_ sender: UIButton) {
        if let email = Auth.auth().currentUser?.email {
            UserService.passwordReset(withEmail: email, alertIn: self)
            Helpers.displayAlert(title: "New Password Sent 📬", message: "We have sent you an email at \(email) so you can reinitialize your password", with: self)
        }
    }
    
    // MARK: - Change email
    
    @IBAction func changeEmailButtonPressed(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Email Change Requested ✉️", message: "Please enter your new email address", preferredStyle: .alert)
        let action = UIAlertAction(title: "Submit", style: .default) { (action) in
            if let email = textField.text {
                if !Helpers.isValidEmail(testStr: email) {
                    Helpers.displayAlert(title: "Invalid Email 👮‍♀️", message: "Please enter a valid email address", with: self)
                } else {
                    if let currentUserId = Auth.auth().currentUser?.uid {
                        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
                            if let errorMessage = error?.localizedDescription {
                                Helpers.displayAlert(title: "Error updating email 👮‍♀️", message: errorMessage, with: self)
                            } else {
                                UserService.updateUserProfile(uid: currentUserId, newUserInfo: ["email": email])
                                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                    print("Error sending the verification email")
                                })
                                Helpers.displayAlert(title: "New Email Update 📬", message: "We have just sent you an email at \(email) to verify your new email address", with: self)
                            }
                        })
                    }
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New mail address..."
            textField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Change username
    
    @IBAction func changeUsernameButtonPressed(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Username Requested 👨‍💻", message: "Please enter your new username", preferredStyle: .alert)
        let action = UIAlertAction(title: "Choose new username", style: .default, handler: { (action) in
            if let newUsername = textField.text {
                if newUsername == "" {
                    alert.title = "No Username entered 😏"
                    alert.message = "It seems that you tried to trick us!\nWould you mind setting a true username?"
                    self.present(alert, animated: true, completion: nil)
                } else if newUsername.count > 16 {
                    alert.title = "New Username too long 😏"
                    alert.message = "Size matters in our database, could you please shrinken your username a bit?"
                    self.present(alert, animated: true, completion: nil)
                } else {
                    UserService.usernameAlreadyExists(username: newUsername, completion: { (exists) in
                        if exists {
                            alert.title = "Username already taken 😕"
                            alert.message = "It seems that someone stole your username \(newUsername)!\nWould you mind setting a new one?"
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            if let currentUserId = Auth.auth().currentUser?.uid {
                                let dispatchGroup = DispatchGroup()
                                dispatchGroup.enter()
                                UserService.getUserProfile(uid: currentUserId, completion: { (userProfile) in
                                    dispatchGroup.leave()
                                    if let currentUsername = userProfile["username"] {
                                        UserService.deleteUsername(username: currentUsername)
                                    }
                                })
                                dispatchGroup.notify(queue: .main) {
                                    UserService.updateUserProfile(uid: currentUserId, newUserInfo: ["username": newUsername])
                                    Helpers.displayAlert(title: "Username Updated 👌 ", message: "Your username has been updated to \(newUsername)!", with: self)
                                    self.setTitleWithUsername()
                                }
                            }
                        }
                    })
                }
            }
        })
        alert.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "New username..."
            textField = alertTextField
        })
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Delete account
    
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
        if let currentUserId = Auth.auth().currentUser?.uid {
            let alert = UIAlertController(title: "Account Deletion ❌", message: "Are you sure you want to delete your Studiz Account?", preferredStyle: .alert)
            let sayYes = UIAlertAction(title: "Yes, I'm sure", style: .default) { (action) in
                UserService.deleteAccount(uid: currentUserId, completion: {
                    let alertAfterDelete = UIAlertController(title: "Account successfully deleted ✅", message: "Your account has been deleted. Hope we will see you again soon 😢", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertAfterDelete.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                })
            }
            alert.addAction(sayYes)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Logout
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        UserService.logOutUser(alertIn: self)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Feedback Prompt
    
    func shouldShowFeedback() -> Bool{
        return true
    }
    
    func showFeedbackPrompt() {
        if shouldShowFeedback() {
            let alert = UIAlertController(title: "", message: "How do you feel about Studiz?", preferredStyle: .actionSheet)
            let happy = UIAlertAction(title: "Happy 😁", style: .default) { (action) in
                self.goToFeedbackHandler(feedback: .Happy)
            }
            let confused = UIAlertAction(title: "Confused 🤨", style: .default) { (action) in
                self.goToFeedbackHandler(feedback: .Confused)
            }
            let unhappy = UIAlertAction(title: "Unhappy 🙁", style: .default) { (action) in
                self.goToFeedbackHandler(feedback: .Unhappy)
            }
            
            alert.addAction(happy)
            alert.addAction(confused)
            alert.addAction(unhappy)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func goToFeedbackHandler(feedback selectedFeedback: Feedback) {
        feedback = selectedFeedback
        performSegue(withIdentifier: "goToFeedback", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFeedback" {
            let feedbackView = segue.destination as! FeedbackViewController
            feedbackView.feedback = feedback
        }
    }
    
}
