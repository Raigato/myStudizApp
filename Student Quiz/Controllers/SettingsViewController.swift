//
//  SettingsViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 04/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        UserService.logOutUser(alertIn: self)
        dismiss(animated: true, completion: nil)
    }
    
}
