//
//  ViewController.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 21/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding padding to the Text Fields
        let emailPaddingView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 15, height: EmailTextField.frame.height)))
        EmailTextField.leftView = emailPaddingView
        EmailTextField.leftViewMode = UITextFieldViewMode.always
        
        let passwordPaddingView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 15, height: PasswordTextField.frame.height)))
        PasswordTextField.leftView = passwordPaddingView
        PasswordTextField.leftViewMode = UITextFieldViewMode.always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

