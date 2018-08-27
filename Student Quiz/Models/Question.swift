//
//  Question.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 27/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

class Question {
    
    // MARK: - Properties and constructor
    
    var question: String
    var answer: String
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
    
    // MARK: - Convert to dictionary method
    
    func createDictionary() -> [String: String] {
        let dict = ["question": self.question, "answer": self.answer]
        return dict
    }
}
