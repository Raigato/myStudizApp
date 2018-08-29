//
//  NewQuestionViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 29/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class NewQuestionViewController: UIViewController {
    
    var currentQuiz = Quiz(createdby: "", entitled: "", description: "", on: .Misc, questions: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(currentQuiz.createDictionary())
    }

}
