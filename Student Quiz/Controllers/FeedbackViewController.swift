//
//  AskForReviewViewController.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 17/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

enum Feedback {
    case Happy
    case Confused
    case Unhappy
}

class FeedbackViewController: UIViewController {
    
    var feedback: Feedback = .Confused

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reviewButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if feedback == .Happy {
            reviewButton.isHidden = false
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let hasReviewed = true
        defaults.set(hasReviewed, forKey: "hasReviewed")
        
        let appID = "1436058850"
        //let urlStr = "itms-apps://itunes.apple.com/app/id\(appID)" // (Option 1) Open App Page
        let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)" // (Option 2) Open App Review Tab
        
        
        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func contactButtonPressed(_ sender: UIButton) {
        let email = "support@mystudiz.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func chooseMessage(feedback: Feedback) {
        var message = ""
        
        if feedback == .Happy {
            message = "We'd love to know how we can make Studiz even better - and would really appreciate if you left a review on the App Store."
        } else if feedback == .Confused {
            message = "If you're unsure about how to use Studiz, why not contact the Studiz team? We'd love to help you!"
        } else {
            message = "We'd love to know how we can make Studiz even better, and make your experience with Studiz a happy one!"
        }
        
        textLabel.text = message
    }
    
}
