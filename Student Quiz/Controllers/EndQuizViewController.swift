//
//  EndQuizViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 01/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class EndQuizViewController: UIViewController {
    
    var score: Int = 0
    var summary: [(Question, Bool)] = []
    var rating: Int = 0
    var comment: String = ""
    
    @IBOutlet var starButtons: [UIButton]!
    
    @IBOutlet weak var congratulationsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        congratulationsLabel.text = "Congratulations!\nYour score: \(score)%"
    }
    
    // MARK: Segue Handling
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToReview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToReview" {
            let reviewView = segue.destination as! ReviewViewController
            
            reviewView.summary = summary
        }
    }
    
    // MARK: Finish Button Handling
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        if rating > 0 {
            if comment != "" {
                currentQuiz.addReview(rated: String(rating), comment: comment)
            } else {
                currentQuiz.addReview(rated: String(rating))
            }
            currentQuiz.save { (quizId) in }
        }
    }
    
    // MARK: Star Buttons Handling
    @IBAction func starButtonPressed(_ sender: UIButton) {
        for button in starButtons {
            if button.tag <= sender.tag {
                button.setBackgroundImage(UIImage(named: "Active Star"), for: .normal)
            } else {
                button.setBackgroundImage(UIImage(named: "Inactive Star"), for: .normal)
            }
        }
    }
    
}
