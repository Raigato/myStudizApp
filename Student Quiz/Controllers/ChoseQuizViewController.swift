//
//  ChoseQuizViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 31/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class ChoseQuizViewController: UIViewController {
    
    var userRole: Role = .None

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectButtonsToDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTitle()
    }

    @IBAction func deleteButtonPressed(_ sender: UIButton) {     
        if userRole == .Owner {
            let alert = UIAlertController(title: "Quiz delete 🗑", message: "Are you sure you want to delete this awesome Quiz?", preferredStyle: .alert)
            let sayYes = UIAlertAction(title: "Yes", style: .default) { (action) in
                QuizService.deleteQuiz(by: UserService.currentUser(), quizId: currentQuizId)
                self.performSegue(withIdentifier: "fromChoseQuizToHome", sender: self)
            }
            let sayNo = UIAlertAction(title: "No", style: .default, handler: nil)
            
            alert.addAction(sayNo)
            alert.addAction(sayYes)
            present(alert, animated: true, completion: nil)
        }
        if userRole == .Collaborator {
            let alert = UIAlertController(title: "Quiz delete 🗑", message: "Are you sure you want to remove yourself from the collaborators of this awesome Quiz?", preferredStyle: .alert)
            let sayYes = UIAlertAction(title: "Yes", style: .default) { (action) in
                currentQuiz.deleteCollaborator(uid: UserService.currentUser())
                currentQuiz.save(in: currentQuizId, completion: { (quizId) in })
                QuizListService.removeQuizForUser(for: UserService.currentUser(), quiz: currentQuizId)
                self.performSegue(withIdentifier: "fromChoseQuizToHome", sender: self)
            }
            let sayNo = UIAlertAction(title: "No", style: .default, handler: nil)
            
            alert.addAction(sayNo)
            alert.addAction(sayYes)
            present(alert, animated: true, completion: nil)
        }
        
        if userRole == .Favorite {
            let alert = UIAlertController(title: "Delete from favorites ⭐", message: "Are you sure you want to remove this awesome Quiz from your favorites?", preferredStyle: .alert)
            let sayYes = UIAlertAction(title: "Yes", style: .default) { (action) in
                QuizListService.removeQuizForUser(for: UserService.currentUser(), quiz: currentQuizId)
                self.performSegue(withIdentifier: "fromChoseQuizToHome", sender: self)
            }
            let sayNo = UIAlertAction(title: "No", style: .default, handler: nil)
            
            alert.addAction(sayNo)
            alert.addAction(sayYes)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func runButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toRunQuiz", sender: self)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if userRole == .Owner {
            performSegue(withIdentifier: "fromEditToNewQuiz", sender: self)
        }
        if userRole == .Collaborator {
            performSegue(withIdentifier: "fromEditToNewQuestion", sender: self)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if userRole == .Owner {
            performSegue(withIdentifier: "fromShareToPrivacy", sender: self)
        }
    }
    
    // MARK: UI selection functions
    
    func setTitle() {
        titleLabel.text = Helpers.reduceTitle(currentQuiz.title)
    }
    
    func selectButtonsToDisplay() {
        QuizListService.getRoleForUser(uid: UserService.currentUser(), quizId: currentQuizId) { (role) in
            if let foundRole = role {
                self.userRole = foundRole
                
                // -- Select buttons according to the role
                if foundRole != .Owner {
                    self.shareButton.isHidden = true
                }
                
                if foundRole != .Owner && foundRole != .Collaborator {
                    self.editButton.isHidden = true
                }
                
                if foundRole != .Owner && foundRole != .Collaborator && foundRole != .Favorite {
                    self.deleteButton.isHidden = true
                }
            }
        }
    }
}
