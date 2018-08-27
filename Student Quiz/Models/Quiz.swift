//
//  Quiz.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 27/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import Firebase

// MARK: - Required enums

enum Category {
    case Languages
    case Maths
    case History
    case Geography
    case Science
    case Literature
    case Arts
    case Business
    case Law
    case Misc
}

enum Privacy {
    case Public
    case Shared
    case Private
}

class Quiz {
    
    // MARK: - Properties and constructor
    
    var creator: String
    var title: String
    var description: String
    var category: Category
    var questions: [Question]
    var privacy: Privacy
    var collaborators: [String]
    var reviews: [Review]
    
    init(createdby creator: String, entitled title: String, description: String, on category: Category, questions: [Question], privacy: Privacy, collaborators: [String] = [], reviews: [Review] = []) {
        self.creator = creator
        self.title = title
        self.description = description
        self.category = category
        self.questions = questions
        self.privacy = privacy
        self.collaborators = collaborators
        self.reviews = reviews
    }
    
    // MARK: - Get/Set enum methods
    
    // -- GET
    func getCategory() -> String {
        switch self.category {
        case .Languages:
            return "Languages"
        case .Maths:
            return "Maths"
        case .History:
            return "History"
        case .Geography:
            return "Geography"
        case .Science:
            return "Science"
        case .Literature:
            return "Literature"
        case .Arts:
            return "Arts"
        case .Business:
            return "Business"
        case .Law:
            return "Law"
        case .Misc:
            return "Misc"
        }
    }
    
    func getPrivacy() -> String {
        switch self.privacy {
        case .Public:
            return "Public"
        case .Shared:
            return "Shared"
        case .Private:
            return "Private"
        }
    }
    
    // -- SET
    func setCategory(category: String) {
        switch category {
        case "Languages":
            self.category = .Languages
        case "Maths":
            self.category = .Maths
        case "History":
            self.category = .History
        case "Geography":
            self.category = .Geography
        case "Science":
            self.category = .Science
        case "Literature":
            self.category = .Literature
        case "Arts":
            self.category = .Arts
        case "Business":
            self.category = .Business
        case "Law":
            self.category = .Law
        default:
            self.category = .Misc
        }
    }
    
    func setPrivacy(privacy: String) {
        switch privacy {
        case "Public":
            self.privacy = .Public
        case "Shared":
            self.privacy = .Shared
        default:
            self.privacy = .Private
        }
    }
    
    // MARK: - Add methods
    
    func addQuestion(question: String, answer: String) {
        let newQuestion = Question(question: question, answer: answer)
        self.questions.append(newQuestion)
    }
    
    func addCollaborator(uid: String) {
        self.collaborators.append(uid)
    }
    
    func addReview(rated rating: String, comment: String = "") {
        let newReview = Review(rated: rating, comment: comment)
        self.reviews.append(newReview)
    }
    
    // MARK: - Convert to dictionary method
    
    func createDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["creator"] = self.creator
        dict["title"] = self.title
        dict["description"] = self.description
        dict["category"] = self.getCategory()
        
        var questionList = [[String: String]]()
        for question in self.questions {
            questionList.append(question.createDictionary())
        }
        dict["questions"] = questionList
        
        dict["privacy"] = self.getPrivacy()
        dict["collaborators"] = self.collaborators
        
        var reviewList = [[String: String]]()
        for review in self.reviews {
            reviewList.append(review.createDictionary())
        }
        dict["reviews"] = reviewList
        
        return dict
    }
    
    // MARK: - Database management methods
    
    let quizDB = Database.database().reference().child("Quiz")
    
    func saveInList(id: String) {
        // TODO: Fetch before save
        
        func saveListForUser(uid: String, role: Role) {
            let newList = QuizList(user: uid, quizList: [QuizRoleTuple(quizId: id, role: role)])
            newList.save()
        }
        
        saveListForUser(uid: self.creator, role: .Owner)
        
        for collaborator in self.collaborators {
            saveListForUser(uid: collaborator, role: .Collaborator)
        }
    }
    
    func save() {
        quizDB.childByAutoId().setValue(self.createDictionary()) { (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("Quiz \(reference.key) saved successfully!")
                self.saveInList(id: reference.key)
            }
        }
    }

}
