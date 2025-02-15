//
//  CommunityQuizViewController.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 26/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CommunityQuizViewController: UIViewController {
    
    var userRole: Role = .None

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var questionCountLabel: UILabel!
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sampleQuestionLabel1: UILabel!
    @IBOutlet weak var sampleQuestionLabel2: UILabel!
    @IBOutlet weak var sampleQuestionLabel3: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
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
        if userRole == .Favorite {
            removeFromFavorite()
        } else if userRole == .None {
            addToFavorite()
        }
        
        updateFavoriteButton()
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
    }
    
    //MARK: UI functions
    
    func updateUI() {
        setUserRole()
        
        sampleQuestionLabel1.isHidden = true
        sampleQuestionLabel2.isHidden = true
        sampleQuestionLabel3.isHidden = true
        
        categoryLabel.text = currentQuiz.getCategory()
        questionCountLabel.text = String(currentQuiz.questions.count)
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
    
    func updateFavoriteButton() {
        if userRole == .Owner || userRole == .Collaborator {
            self.favoriteButton.isHidden = true
        } else if userRole == .Favorite {
            self.favoriteButton.setBackgroundImage(UIImage(named: "Active Star"), for: .normal)
            self.favoriteButton.isHidden = false
        } else {
            self.favoriteButton.setBackgroundImage(UIImage(named: "Inactive Star"), for: .normal)
            self.favoriteButton.isHidden = false
        }
    }
    
    func setUserRole() {
        QuizListService.getRoleForUser(uid: UserService.currentUser(), quizId: currentQuizId) { (role) in
            if let fetchedRole = role {
                self.userRole = fetchedRole
                self.updateFavoriteButton()
            }
        }
    }
    
    //MARK: Favorite handling functions
    
    func addToFavorite() {
        QuizListService.addQuizToFavorites(for: UserService.currentUser(), quiz: currentQuizId)
        userRole = .Favorite
    }
    
    func removeFromFavorite() {
        QuizListService.removeQuizForUser(for: UserService.currentUser(), quiz: currentQuizId)
        userRole = .None
    }
}
