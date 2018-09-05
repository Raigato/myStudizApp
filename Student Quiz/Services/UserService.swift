//
//  UserService.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 30/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static func logOutUser(alertIn viewController: UIViewController) {
        do {
            try Auth.auth().signOut()
        } catch {
            Helpers.displayAlert(title: "Cannot Log Out", message: "An error has occured when trying to logout", with: viewController)
        }
    }
    
    static func passwordReset(withEmail email: String, alertIn viewController: UIViewController) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let errorMessage = error?.localizedDescription {
                Helpers.displayAlert(title: "Error sending Password Reset", message: "\(errorMessage)", with: viewController)
            }
        }
    }
    
    static func currentUser() -> String {
        if let user = Auth.auth().currentUser?.uid {
            return user
        }
        return ""
    }
    
    static func isActiveUser(uid: String) -> Bool {
        if uid == Auth.auth().currentUser?.uid {
            return true
        } else {
            return false
        }
    }
    
    static func usernameAlreadyExists(username: String, completion: @escaping ((_ exists: Bool) -> ())) {
        let usernameRef = Database.database().reference().child("username")
        
        usernameRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(username) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func deleteUsername(username: String) {
        let usernameRef = Database.database().reference().child("username").child(username)
        usernameRef.removeValue()
    }
    
    static func updateUserProfile(uid: String, newUserInfo: [String: String]) {
        let userRef = Database.database().reference().child("userProfile").child(uid)
        
        if let newUsername = newUserInfo["username"] {
            if newUsername != "" {
                let usernameRef = Database.database().reference().child("username").child(newUsername)
                usernameRef.setValue(uid)
            }
        }
        
        userRef.updateChildValues(newUserInfo)
    }
    
    static func createUserProfile(uid: String, email: String, username: String = "") {
        let userRef = Database.database().reference().child("userProfile").child(uid)
        
        if username != "" {
            let usernameRef = Database.database().reference().child("username").child(username)
            usernameRef.setValue(uid)
        }
        
        userRef.updateChildValues(["email": email, "username": username])
    }
    
    static func getUserProfile(uid: String, completion: @escaping ((_ userDict: [String: String]) -> ())) {
        let userRef = Database.database().reference().child("userProfile").child(uid)
        
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let userDict = snapshot.value as? [String: String] {
                completion(userDict)
            } else {
                completion([:])
            }
        }
    }
    
    static func getAllUsers(completion: @escaping ((_ userArray: [String]) -> ())) {
        let usersRef = Database.database().reference().child("userProfile")
        
        usersRef.observeSingleEvent(of: .value) { (snapshot) in
            var users: [String] = []
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                users.append(snap.key)
            }
            completion(users)
        }
    }
    
    static func deleteAccount(uid: String, completion: (() -> Void)) {
        // TODO: Make it work as designed
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        UserService.getUserProfile(uid: uid) { (userProfile) in
            if let username = userProfile["username"] {
                UserService.deleteUsername(username: username)
                let userRef = Database.database().reference().child("userProfile").child(uid)
                userRef.removeValue()
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        QuizListService.observeQuizList(uid) { (quizList) in
            if let quizArray = quizList?.quizList {
                for quiz in quizArray {
                    QuizService.deleteQuiz(by: uid, quizId: quiz.quizId)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let quizListRef = Database.database().reference().child("QuizList/\(uid)")
            quizListRef.removeValue()
            Auth.auth().currentUser?.delete(completion: { (error) in
                if let errorMessage = error?.localizedDescription {
                    print(errorMessage)
                } else {
                    print("Account Deleted")
                }
            })
        }
    }
}
