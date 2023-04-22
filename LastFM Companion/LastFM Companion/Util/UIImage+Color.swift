//
//  UIImage+Color.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 12.06.2021.
//

import UIKit

extension UIImage {
    /**
     Convenience initialiser that creates a `UIImage` instance using the specified `UIColor`.
     
     - Parameters:
        - color: The color to be transformed
        - size: The resulting image size
     
     - Returns: The constructed `UIImage` instance.
     */
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
