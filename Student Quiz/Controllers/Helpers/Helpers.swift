//
//  Helpers.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 29/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class Helpers {
    
    static func getExtraflatString(_ str: String) -> String {
        return str.lowercased().folding(options: .diacriticInsensitive, locale: .current).removingWhitespaces().removingPunctuations()
    }
    
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
    
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func getStringFromDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    static func getDateFromString(from date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let formattedDate = dateFormatter.date(from: date) {
            return formattedDate
        }
        
        return Date(timeIntervalSince1970: 0)
    }
}

// MARK: - String extension

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func removingPunctuations() -> String {
        return components(separatedBy: .punctuationCharacters).joined()
    }
    
    // Distance for RunQuiz
    func distanceJaroWinkler(between target: String) -> Double {
        if self.count == 0 && target.count == 0 {
            return 1.0
        }
        
        if self.count < 4 || target.count < 4 {
            if self == target {
                return 1.0
            } else {
                return 0.0
            }
        }
        
        let matchingWindowSize = max(self.count, target.count) / 2 - 1
        var selfFlags = Array(repeating: false, count: self.count)
        var targetFlags = Array(repeating: false, count: target.count)
        
        // Count matching characters.
        var m: Double = 0
        for i in 0..<self.count {
            let left = max(0, i - matchingWindowSize)
            let right = min(target.count - 1, i + matchingWindowSize)
            
            if left <= right {
                for j in left...right {
                    // Already has a match, or does not match
                    let iIndex = self.index(self.startIndex, offsetBy: i)
                    let jIndex = target.index(target.startIndex, offsetBy: j)
                    if targetFlags[j] || self[iIndex] != target[jIndex] {
                        continue;
                    }
                    
                    m += 1
                    selfFlags[i] = true
                    targetFlags[j] = true
                    break
                }
            }
        }
        
        if m == 0.0 {
            return 0.0
        }
        
        // Count transposition.
        var t: Double = 0
        var k = 0
        for i in 0..<self.count {
            if (selfFlags[i] == false) {
                continue
            }
            while (targetFlags[k] == false) {
                k += 1
            }
            let iIndex = self.index(self.startIndex, offsetBy: i)
            let kIndex = target.index(target.startIndex, offsetBy: k)
            if (self[iIndex] != target[kIndex]) {
                t += 1
            }
            k += 1
        }
        t /= 2.0
        
        // Count common prefix.
        var l: Double = 0
        for i in 0..<4 {
            
            let iSelfIndex = self.index(self.startIndex, offsetBy: i)
            let iTargetIndex = target.index(target.startIndex, offsetBy: i)
            if self[iSelfIndex] == target[iTargetIndex] {
                l += 1
            } else {
                break
            }
        }
        
        let dj = (m / Double(self.count) + m / Double(target.count) + (m - t) / m) / 3
        
        let p = 0.1
        let dw = dj + l * p * (1 - dj)
        
        return dw;
    }
}

