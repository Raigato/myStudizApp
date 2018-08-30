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
}
