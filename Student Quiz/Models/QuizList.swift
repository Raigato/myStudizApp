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
    case None
}

struct QuizRoleTuple {
    var quizId: String
    var role: Role
}

class QuizList {
    
    // MARK: - Properties and constructor
    
    var quizList: [QuizRoleTuple]

    init(quizList: [QuizRoleTuple]) {
        self.quizList = quizList
    }
    
    // MARK: - Get/Set enums
    
    static func getRole(role: Role) -> String {
        switch role {
        case .Owner:
            return "Owner"
        case .Collaborator:
            return "Collaborator"
        case .Favorite:
            return "Favorite"
        default:
            return "None"
        }
    }
    
    static func setRole(role: String) -> Role {
        switch role {
        case "Owner":
            return .Owner
        case "Collaborator":
            return .Collaborator
        case "Favorite":
            return .Favorite
        default:
            return .None
        }
    }
    
    // MARK: - Add methods
    
    func addQuiz(quizId: String, role: Role) {
        var foundAt = -1
        
        for (index, tuple) in self.quizList.enumerated() {
            if tuple.quizId == quizId {
                foundAt = index
            }
        }
        
        if foundAt > 0 {
            if self.quizList[foundAt].role != role {
                self.quizList[foundAt].role = role
            }
        } else {
            self.quizList.append(QuizRoleTuple(quizId: quizId, role: role))
        }

    }
    
    // MARK: - Convert to dictionary method
    
    func createDictionary() -> [String: Any] {
        
        var dict = [String: Any]()
        
        var newQuizList = [[String: String]]()
        for quiz in self.quizList {
            let newQuiz = ["quizId": quiz.quizId, "role": QuizList.getRole(role: quiz.role)]
            newQuizList.append(newQuiz)
        }
        
        dict["quizList"] = newQuizList
        
        return dict
        
    }
    
    // MARK: - Database management methods
    
    let quizListRef = Database.database().reference().child("QuizList")
    
    func save(for uid: String) {
        quizListRef.child(uid).setValue(self.createDictionary()) { (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("QuizList for \(uid) saved successfully!")
            }
        }
    }
}
