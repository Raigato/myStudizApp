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
    
    static func getUserName(uid: String) {
        let userRef = Database.database().reference().child("users").child(uid)
        
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
        }
    }
}
