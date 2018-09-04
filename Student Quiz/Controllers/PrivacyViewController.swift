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
    
    @IBOutlet weak var sharedTitle: UILabel!
    @IBOutlet weak var sharedText: UILabel!
    
    @IBOutlet weak var privateTitle: UILabel!
    @IBOutlet weak var privateText: UILabel!
    
    @IBOutlet weak var separator: UIImageView!
    
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentChoice = currentQuiz.privacy
        updateUI(to: currentChoice)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        currentQuiz.privacy = currentChoice
        currentQuiz.save(in: currentQuizId) { (quizId) in }
        
        if currentChoice == .Shared {
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
    
    @IBAction func switchButtonPressed(_ sender: UIButton) {
        if sender.tag == 2 {
            currentChoice = .Shared
            switchButton.tag = 1
        } else if sender.tag == 1 {
            currentChoice = .Private
            switchButton.tag = 2
        }
        updateUI(to: currentChoice)
    }
    
    // MARK: Selector position functions
    
    func moveButtonToShared() {
        switchButton.frame.origin.x = sharedTitle.frame.origin.x - alpha
        switchButton.frame.origin.y = sharedTitle.frame.origin.y - alpha + 5
        switchButton.frame.size.width = separator.frame.width + (2 * alpha)
        switchButton.frame.size.height = sharedTitle.frame.height + sharedText.frame.height + (2 * alpha) + beta - 5
    }
    
    func moveButtonToPrivate() {
        switchButton.frame.origin.x = privateTitle.frame.origin.x - alpha
        switchButton.frame.origin.y = privateTitle.frame.origin.y - alpha + 5
        switchButton.frame.size.width = separator.frame.width + (2 * alpha)
        switchButton.frame.size.height = privateTitle.frame.height + privateText.frame.height + (2 * alpha) + beta - 5
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
    
    func updateUI(to privacy: Privacy) {
        switch privacy {
        case .Public:
            // TODO: Add Public privacy
            print("Not yet implemented")
        case .Shared:
            moveItToShared()
            moveButtonToPrivate()
        case .Private:
            moveItToPrivate()
            moveButtonToShared()
        }
    }
    
}
