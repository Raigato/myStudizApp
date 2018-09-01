//
//  Helpers.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 29/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class Helpers {
    static func displayAlert(title: String, message: String, with view: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        view.present(alertController, animated: true, completion: nil)
    }
    
    static func reduceTitle(_ title: String) -> String {
        var titleArr = title.components(separatedBy: " ")
        if titleArr.count <= 1 {
            return title
        }
        let reducedTitle = titleArr[0] + " " + titleArr[1]
        if reducedTitle.count > 15 {
            return String(reducedTitle.prefix(15))
        } else {
            return reducedTitle
        }
    }
}
