//
//  UIImageViewExtensions.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import Foundation
import UIKit

extension UIImage {
    static func read(from directory: FileManager.SearchPathDirectory = .documentDirectory, name: String) -> UIImage {
        let url = URL.constructFilePath(in: directory, withName: "\(name).png").path
        let image = UIImage(contentsOfFile: url) ?? UIImage()
        image.accessibilityIdentifier = name
        return image
    }
    
    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let aspectWidth = rect.width / width
        let aspectHeight = rect.height / height
        let scaleFactor = aspectWidth > aspectHeight ? rect.size.height / height : rect.size.width / width

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func overlayImage(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()

        color.setFill()

        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        context?.setBlendMode(CGBlendMode.colorBurn)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.draw(self.cgImage!, in: rect)

        context?.setBlendMode(CGBlendMode.sourceIn)
        context?.addRect(rect)
        context?.drawPath(using: CGPathDrawingMode.fill)

        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return coloredImage
    }
}
