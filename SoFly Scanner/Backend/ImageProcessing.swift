//
//  ImageProcessing.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit
import SwiftOCR

class ImageProcessing {
    
    // Scale the image
    static func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        print("Old dimensions: \(image.size.width), \(image.size.height)")
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print("New dimensions: \(scaledImage?.size.width), \(scaledImage?.size.height)")
    
        return scaledImage!
    }

    // Execute Tesseract API
    static func performImageRecognition(image: UIImage) -> String {
        // SwiftOCR
        let swiftOCRInstance = SwiftOCR()
        swiftOCRInstance.recognize(image, { recognizedString in
            print("\nSwift OCR")
            print(recognizedString) // Return text
        })

        // Tesseract OCR
        let tesseract = G8Tesseract()
        tesseract.language = "eng"
        tesseract.engineMode = .cubeOnly
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 120.0
        tesseract.image = scaleImage(image: image, maxDimension: 640).g8_blackAndWhite()
        tesseract.recognize()
    
        return tesseract.recognizedText // Return text
    }
}
