//
//  Review.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 27/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

class Review {
    
    var rating: Int
    var comment: String?
    
    init(rated rating: Int, comment: String = "") {
        self.rating = rating
        self.comment = comment
    }
    
}
