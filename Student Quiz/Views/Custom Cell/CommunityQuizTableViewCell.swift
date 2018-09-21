//
//  CommunityQuizTableViewCell.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 21/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CommunityQuizTableViewCell: UITableViewCell {

    @IBOutlet weak var quizNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var questionsCountLabel: UILabel!
    
    func setAuthor(_ author: String) {
        authorLabel.text = "by \(author)"
    }
    
}
