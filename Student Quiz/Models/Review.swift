//
//  Review.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 27/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

class Review {
    
    // MARK: - Properties and constructor
    
    var rating: String
    var comment: String
    var user: String
    var postingDate: Date
    
    init(by user: String, rated rating: String, comment: String = "", postedOn postingDate: Date = Date()) {
        self.rating = rating
        self.comment = comment
        self.user = user
        self.postingDate = postingDate
    }
    
    // MARK: - Convert to dictionary method
    
    func createDictionary() -> [String: String] {
        if self.comment == "" {
            return ["rating": self.rating, "user": self.user, "postingDate": Helpers.getStringFromDate(from: self.postingDate)]
        } else {
            return ["rating": self.rating, "comment": self.comment, "user": self.user, "postingDate": Helpers.getStringFromDate(from: self.postingDate)]
        }
    }
}
