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
                    quizList.append(Helpers.createCommunityData(from: quiz))
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
                    quizList.append(Helpers.createCommunityData(from: quiz, consideringDate: true))
                }
            }
            
            completion(quizList)
        }
    }
    
}
