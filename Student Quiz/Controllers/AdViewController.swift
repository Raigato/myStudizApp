//
//  AdViewController.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 27/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {
    
    var startAppAd: STAStartAppAd?

    override func viewDidLoad() {
        super.viewDidLoad()

        startAppAd = STAStartAppAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startAppAd!.load(withDelegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAppAd!.show()
    }

}

extension AdViewController: STADelegateProtocol {
    
    func didClose(_ ad: STAAbstractAd!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ChoseQuiz") as! ChoseQuizViewController
        present(vc, animated: false, completion: nil)
    }
}
