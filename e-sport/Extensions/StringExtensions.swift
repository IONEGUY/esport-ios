//
//  SmARtApp.swift
//  SmARt
//
//  Created by MacBook on 2/3/21.
//

import Foundation
import UIKit

extension String {
    static var empty = ""

    func isEmptyOrWhitespace() -> Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }
    
    mutating func removingRegexMatches(pattern: String, replaceWith: String = .empty) {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: count)
            self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch { return }
    }
    
    func checkForUrls() -> [URL] {
        let types: NSTextCheckingResult.CheckingType = .link

        do {
            let detector = try NSDataDetector(types: types.rawValue)

            let matches = detector.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.count))
        
            return matches.compactMap({$0.url})
        } catch let error {
            debugPrint(error.localizedDescription)
        }

        return []
    }
}
