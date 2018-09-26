//
//  CommunityQuizViewController.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 26/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CommunityQuizViewController: UIViewController {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sampleQuestionLabel1: UILabel!
    @IBOutlet weak var sampleQuestionLabel2: UILabel!
    @IBOutlet weak var sampleQuestionLabel3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
    }
    
    //MARK: UI functions
    
    func updateUI() {
        sampleQuestionLabel1.isHidden = true
        sampleQuestionLabel2.isHidden = true
        sampleQuestionLabel3.isHidden = true
        
        categoryLabel.text = currentQuiz.getCategory()
        quizTitleLabel.text = currentQuiz.title
        UserService.getUserProfile(uid: currentQuiz.creator) { (userInfo) in
            if let username = userInfo["username"] {
                self.authorLabel.text = username
            }
        }
        descriptionLabel.text = currentQuiz.description
        
        let sampleQuestions = getSampleQuestions()
        
        if sampleQuestions.count > 0 {
            sampleQuestionLabel1.text = sampleQuestions[0]
            sampleQuestionLabel1.isHidden = false
        }
        if sampleQuestions.count > 1 {
            sampleQuestionLabel2.text = sampleQuestions[1]
            sampleQuestionLabel2.isHidden = false
        }
        if sampleQuestions.count > 2 {
            sampleQuestionLabel3.text = sampleQuestions[2]
            sampleQuestionLabel3.isHidden = false
        }
        
    }
    
    func getSampleQuestions() -> [String] {
        var sampleQuestions: [String] = []
        
        if currentQuiz.questions.count <= 3 {
            for question in currentQuiz.questions {
                sampleQuestions.append(question.question)
            }
        } else {
            var questionSet = currentQuiz.questions
            while sampleQuestions.count < 3 {
                let pick = Int(arc4random_uniform(UInt32(questionSet.count)))
                sampleQuestions.append(questionSet[pick].question)
                questionSet.remove(at: pick)
            }
        }
        
        return sampleQuestions
    }
}
