//
//  CollaboratorTableViewCell.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 30/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CollaboratorTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var checkbox: UIImageView!
    @IBOutlet weak var checkmark: UIImageView!
    
    func isChecked(_ checked: Bool) {
        checkmark.isHidden = !checked
    }
}
