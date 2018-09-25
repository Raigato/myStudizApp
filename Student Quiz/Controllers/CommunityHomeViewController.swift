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
            
            getCommunityData { (quizList) in
                communityList.quizArray = quizList.sorted { $0.rating > $1.rating }
            }
        }
        
        if segue.identifier == "goToTrendingQuiz" {
            let communityList = segue.destination as! CommunityListViewController
            
            communityList.displayedTitle = "Trending"
            
            //TODO: Generate Quiz List
        }
    }
    
    func getCommunityData(completion: @escaping (([quizCellData]) -> ())) {
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

    func createCommunityData(from quiz: Quiz) -> quizCellData {
        func averageRating(reviews: [Review]) -> Double {
            if reviews.count == 0 {
                return 2.5
            }
            
            var sum: Double = 0.0
            
            for review in reviews {
                if let rating = Double(review.rating) {
                    sum += rating
                }
            }
            
            return sum / Double(reviews.count)
        }
        
        let quizData = quizCellData.init(title: quiz.title, category: quiz.getCategory(), author: quiz.creator, rating: averageRating(reviews: quiz.reviews), questions: quiz.questions.count)
        
        return quizData
    }
    
}
