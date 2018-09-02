//
//  ReviewTableViewCell.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 02/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    func isRight(_ isRight: Bool) {
        if isRight {
            answerLabel.textColor = UIColor(red:0.29, green:0.71, blue:0.26, alpha:1.0)
        } else {
            answerLabel.textColor = UIColor(red:0.70, green:0.23, blue:0.23, alpha:1.0)
        }
    }
}
