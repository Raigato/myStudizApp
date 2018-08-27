//
//  QuizList.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 27/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import Firebase

// MARK: - Required enums and structs

enum Role {
    case Owner
    case Collaborator
    case Favorite
}

struct QuizRoleTuple {
    var quizId: String
    var role: Role
}

class QuizList {
    
    // MARK: - Properties and constructor
    
    var user: String
    var quizList: [QuizRoleTuple]

    init(user: String, quizList: [QuizRoleTuple]) {
        self.user = user
        self.quizList = quizList
    }
    
    // MARK: - Add methods
    
    func addQuiz(quizId: String, role: Role) {
        self.quizList.append(QuizRoleTuple(quizId: quizId, role: role))
    }
    
    // MARK: - Convert to dictionary method
    
    func createDictionary() -> [String: Any] {
        
        func getRole(role: Role) -> String {
            switch role {
            case .Owner:
                return "Owner"
            case .Collaborator:
                return "Collaborator"
            case .Favorite:
                return "Favorite"
            }
        }
        
        var dict = [String: Any]()
        dict["user"] = self.user
        
        var newQuizList = [[String: String]]()
        for quiz in self.quizList {
            let newQuiz = ["quizId": quiz.quizId, "role": getRole(role: quiz.role)]
            newQuizList.append(newQuiz)
        }
        
        dict["quizList"] = newQuizList
        
        return dict
        
    }
    
    // MARK: - Database management methods
    
    let quizListDB = Database.database().reference().child("QuizList")
    
    func save() {
        quizListDB.child(self.user).setValue(self.createDictionary()) { (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("QuizList for \(self.user) saved successfully!")
            }
        }
    }
}
