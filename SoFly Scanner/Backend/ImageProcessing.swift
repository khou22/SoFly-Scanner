//
//  ImageProcessing.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

class ImageProcessing: NSObject, G8TesseractDelegate {
    
    // Scale the image
    static func prepareImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        // Use GPUImage's Adaptaive threshold
        
        // Initialize our adaptive threshold filter
        let stillImageFilter: GPUImageAdaptiveThresholdFilter = GPUImageAdaptiveThresholdFilter()
        
        stillImageFilter.blurRadiusInPixels = Options.GPUBlurRadius // Blur radius of the filter, defaults to 4.0
        
        var filteredImage: UIImage = stillImageFilter.image(byFilteringImage: image) // Make filtered image
//        filteredImage = image
        
        // Scale image
//        print("Old dimensions: \(image.size.width), \(image.size.height)")
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if filteredImage.size.width > filteredImage.size.height {
            scaleFactor = filteredImage.size.height / filteredImage.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = filteredImage.size.width / filteredImage.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        filteredImage.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        print("New dimensions: \(scaledImage?.size.width), \(scaledImage?.size.height)")
    
        return scaledImage!
    }

    // Execute Tesseract API
    static func performImageRecognition(image: UIImage) -> String {
        // Tesseract OCR
        let tesseract = G8Tesseract()
        tesseract.language = "eng"
        tesseract.delegate = self as! G8TesseractDelegate
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 120.0
        tesseract.image = image
        tesseract.recognize()
    
        return tesseract.recognizedText // Return text
    }
    
    func preprocessedImage(for tesseract: G8Tesseract!, sourceImage: UIImage!) -> UIImage! {
        return ImageProcessing.prepareImage(image: sourceImage, maxDimension: 640) // Return processed
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        NSLog("progress: %lu", tesseract.progress)
    }
    
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return false
    }
    
    static func testing(image: UIImage) -> String {
        let str = ImageProcessing.performImageRecognition(image: image)
        print(str) // Print raw text
        
        let preprocessed: String = NaturalLangProcessing.preprocess(text: str)
        let lemmatizedText = NaturalLangProcessing.lemmatize(text: preprocessed)
        
        // Print lematized
        var output = ""
        for (key, value) in lemmatizedText {
            output += key + ": " + value + "     "
        }
        print(output)
        
        // Test the NLP
        let year: String = NaturalLangProcessing.Year(text: preprocessed)
        let month: String = NaturalLangProcessing.Month(text: preprocessed)
        let time: String = NaturalLangProcessing.Time(text: preprocessed)

        print("Year: " + year)
        print("Month: " + month)
        print("Time: " + time)
        print(NaturalLangProcessing.getDate(text: preprocessed)) // Print the concatinated date
        
        return preprocessed
    }
}
