//
//  runQuizProgressView.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 31/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class runQuizProgressView: UIProgressView {

    var height: CGFloat = 1.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size: CGSize = CGSize(width: self.frame.size.height, height: height)
        return size
    }

}
