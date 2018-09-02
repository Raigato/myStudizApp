//
//  QuizListService.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 27/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import Foundation
import Firebase

class QuizService {
    
    static func deleteQuiz(by uid: String, quizId: String) {
        QuizListService.getRoleForUser(uid: uid, quizId: quizId) { (role) in
            if let foundRole = role {
                if foundRole == .Owner {
                    let quizRref = Database.database().reference().child("Quiz/\(quizId)")
                    quizRref.removeValue()
                    UserService.getAllUsers(completion: { (users) in
                        for user in users {
                            QuizListService.removeQuizForUser(for: user, quiz: quizId)
                        }
                    })
                }
            }
        }
    }
    
    static func observeQuiz(_ quizId: String, completion: @escaping ((_ quiz: Quiz?) -> ())) {
        let quizRef = Database.database().reference().child("Quiz/\(quizId)")
        
        quizRef.observeSingleEvent(of: .value) { (snapshot) in
            let quiz: Quiz?
            
            if let dict = snapshot.value as? [String: Any] {
                
                let creator = dict["creator"] as? String
                let title = dict["title"] as? String
                let description = dict["description"] as? String
                let category = QuizService.convertCategory(dict["category"] as? String)
                let privacy = QuizService.convertPrivacy(dict["privacy"] as? String)
                
                quiz = Quiz(createdby: creator!, entitled: title!, description: description!, on: category, questions: [], privacy: privacy, collaborators: [], reviews: [])
                
                if let fetchedQuestions = dict["questions"] as? [[String: String]] {
                    for fetchedQuestion in fetchedQuestions {
                        quiz?.addQuestion(question: fetchedQuestion["question"]!, answer: fetchedQuestion["answer"]!)
                    }
                }
                
                if let fetchedCollaborators = dict["collaborators"] as? [String] {
                    for fetchedCollaborator in fetchedCollaborators {
                        quiz?.addCollaborator(uid: fetchedCollaborator)
                    }
                }
                
                if let fetchedReviews = dict["reviews"] as? [[String: String]] {
                    for fetchedReview in fetchedReviews {
                        if let user = fetchedReview["user"] {
                            if let rating = fetchedReview["rating"] {
                                if let comment = fetchedReview["comment"] {
                                    quiz?.addReview(by: user, rated: rating, comment: comment)
                                } else {
                                    quiz?.addReview(by: user, rated: rating)
                                }
                            }
                        }
                    }
                }
                
                completion(quiz)
            }
        }
    }
    
    static func convertPrivacy(_ privacy: String?) -> Privacy {
        switch privacy {
        case "Public":
            return .Public
        case "Shared":
            return .Shared
        default:
            return .Private
        }
    }
    
    static func convertCategory(_ category: String?) -> Category {
        switch category {
        case "Languages":
            return .Languages
        case "Maths":
            return .Maths
        case "History":
            return .History
        case "Geography":
            return .Geography
        case "Science":
            return .Science
        case "Literature":
            return .Literature
        case "Arts":
            return .Arts
        case "Business":
            return .Business
        case "Law":
            return .Law
        default:
            return .Misc
        }
    }
    
}
