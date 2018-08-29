//
//  QuizListService.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 27/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import Foundation
import Firebase

class QuizListService {
    
    static func getRoleForUser(uid: String, quizId: String, completion: @escaping ((_ role: Role?) -> ())) {
        QuizListService.observeQuizList(uid) { (quizList) in
            if let tupleArray = quizList?.quizList {
                var role: Role = .None
                for tuple in tupleArray {
                    if tuple.quizId == quizId {
                        role = tuple.role
                    }
                }
                completion(role)
            }
        }
    }
    
    static func observeQuizList(_ uid: String, completion: @escaping ((_ quizList: QuizList?) -> ())) {
        let quizListRef = Database.database().reference().child("QuizList/\(uid)")
        
        quizListRef.observeSingleEvent(of: .value) { (snapshot) in
            let quizList: QuizList? = QuizList(quizList: [])
            
            if let dict = snapshot.value as? [String: Any] {
                if let quizArray = dict["quizList"] as? [[String: String]] {
                    for quiz in quizArray {
                        quizList?.addQuiz(quizId: quiz["quizId"]!, role: QuizList.setRole(role: quiz["role"]!))
                    }
                }

            }
            
            completion(quizList)
        }
    }
}
