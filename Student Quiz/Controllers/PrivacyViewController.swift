//
//  PrivacyViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 29/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {
    
    var alpha: CGFloat = 15.0 // Padding inside the selection rect
    var beta: CGFloat = 5.0 // Margin between Title and Text
    
    var currentChoice: Privacy = .Private

    @IBOutlet weak var selectorImage: UIImageView!
    
    @IBOutlet weak var publicTitle: UILabel!
    @IBOutlet weak var publicText: UILabel!
    
    @IBOutlet weak var sharedTitle: UILabel!
    @IBOutlet weak var sharedText: UILabel!
    
    @IBOutlet weak var privateTitle: UILabel!
    @IBOutlet weak var privateText: UILabel!
    
    @IBOutlet weak var separator: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentChoice = currentQuiz.privacy
        updateUI()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        currentQuiz.privacy = currentChoice
        currentQuiz.save(in: currentQuizId) { (quizId) in }
        
        if currentChoice == .Shared || currentChoice == .Public {
            performSegue(withIdentifier: "goToCollaborators", sender: self)
        }
        
        if currentChoice == .Private {
            for collaborator in currentQuiz.collaborators {
                currentQuiz.deleteCollaborator(uid: collaborator)
                QuizListService.removeQuizForUser(for: collaborator, quiz: currentQuizId)
            }
            performSegue(withIdentifier: "goToChoseQuizFromPrivate", sender: self)
        }
    }
    
    // MARK: Buttons handling
    
    @IBAction func publicButtonPressed(_ sender: UIButton) {
        currentChoice = .Public
        updateUI()
    }
    
    @IBAction func sharedButtonClicked(_ sender: UIButton) {
        currentChoice = .Shared
        updateUI()
    }
    
    @IBAction func privateButtonClicked(_ sender: Any) {
        currentChoice = .Private
        updateUI()
    }
    
    // MARK: Selector position functions
    
    func moveItToPublic() {
        selectorImage.frame.origin.x = publicTitle.frame.origin.x - alpha
        selectorImage.frame.origin.y = publicTitle.frame.origin.y - alpha + 10
        selectorImage.frame.size.width = separator.frame.width + (2 * alpha)
        selectorImage.frame.size.height = publicTitle.frame.height + publicText.frame.height + (2 * alpha) + beta - 5
    }
    
    func moveItToShared() {
        selectorImage.frame.origin.x = sharedTitle.frame.origin.x - alpha
        selectorImage.frame.origin.y = sharedTitle.frame.origin.y - alpha + 5
        selectorImage.frame.size.width = separator.frame.width + (2 * alpha)
        selectorImage.frame.size.height = sharedTitle.frame.height + sharedText.frame.height + (2 * alpha) + beta - 5
    }
    
    func moveItToPrivate() {
        selectorImage.frame.origin.x = privateTitle.frame.origin.x - alpha
        selectorImage.frame.origin.y = privateTitle.frame.origin.y - alpha + 5
        selectorImage.frame.size.width = separator.frame.width + (2 * alpha)
        selectorImage.frame.size.height = privateTitle.frame.height + privateText.frame.height + (2 * alpha) + beta - 5
    }
    
    // MARK: Update UI
    
    func updateUI() {
        switch currentChoice {
            case .Public:
                moveItToPublic()
            case .Shared:
                moveItToShared()
            case .Private:
                moveItToPrivate()
        }
    }
    
}
