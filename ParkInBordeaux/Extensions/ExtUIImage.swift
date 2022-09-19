//
//  ExtUIImage.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 14/09/2022.
//

import Foundation
import UIKit

extension UIImage {
    /// Give the ability to resize en image while the scale ration is being preserved
    /// - Parameter targetSize: Size the output image must be
    /// - Returns: The resized imaged
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        return scaledImage
    }
}
