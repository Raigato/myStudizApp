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
    
    init(rated rating: String, comment: String = "") {
        self.rating = rating
        self.comment = comment
    }
    
    // MARK: - Convert to dictionary method
    
    func createDictionary() -> [String: String] {
        let dict = ["rating": self.rating, "comment": self.comment]
        return dict
    }
}
