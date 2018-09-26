//
//  CommunityHomeViewController.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 20/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CommunityHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTopQuiz" {
            let communityList = segue.destination as! CommunityListViewController
            
            communityList.displayedTitle = "Top"
            
            getCommunityDataForTop { (quizList) in
                communityList.quizArray = quizList.sorted { $0.rating > $1.rating }
            }
        }
        
        if segue.identifier == "goToTrendingQuiz" {
            let communityList = segue.destination as! CommunityListViewController
            
            communityList.displayedTitle = "Trending"
            
            getCommunityDataForTrending { (quizList) in
                communityList.quizArray = quizList.sorted { $0.rating > $1.rating }
            }
        }
    }
    
    func getCommunityDataForTop(completion: @escaping (([quizCellData]) -> ())) {
        QuizService.getCommunityQuiz { (quizArray) in
            var quizList: [quizCellData] = []
            
            for fetchedQuiz in quizArray {
                if let quiz = fetchedQuiz {
                    quizList.append(self.createCommunityData(from: quiz))
                }
            }
            
            completion(quizList)
        }
    }
    
    func getCommunityDataForTrending(completion: @escaping (([quizCellData]) -> ())) {
        QuizService.getCommunityQuiz { (quizArray) in
            var quizList: [quizCellData] = []
            
            for fetchedQuiz in quizArray {
                if let quiz = fetchedQuiz {
                    quizList.append(self.createCommunityData(from: quiz, consideringDate: true))
                }
            }
            
            completion(quizList)
        }
    }

    func createCommunityData(from quiz: Quiz, consideringDate: Bool = false) -> quizCellData {
        func averageRating(reviews: [Review], consideringDate: Bool = false) -> Double {
            if reviews.count == 0 {
                return 2.5
            }
            
            var sum: Double = 0.0
            
            for review in reviews {
                if let rating = Double(review.rating) {
                    var trueRating = rating
                    if consideringDate {
                        let inteval = DateInterval(start: review.postingDate, end: Date()).duration / (24.0 * 3600.0)
                        trueRating -= inteval * 0.1
                        if trueRating < 0 {
                            trueRating = 0
                        }
                    }
                    sum += trueRating
                }
            }
            
            return round(10 * (sum / Double(reviews.count))) / 10
        }
        
        var rating = 0.0
        var displayedRating = 0.0
        
        displayedRating = averageRating(reviews: quiz.reviews)
        
        if consideringDate {
            rating = averageRating(reviews: quiz.reviews, consideringDate: true)
        } else {
            rating = displayedRating
        }
        
        if quiz.reviews.count == 0 {
            displayedRating = 0.0
        }
        
        let quizData = quizCellData.init(title: quiz.title, category: quiz.getCategory(), author: quiz.creator, rating: rating, displayedRating: displayedRating, questions: quiz.questions.count)
        
        return quizData
    }
    
}
