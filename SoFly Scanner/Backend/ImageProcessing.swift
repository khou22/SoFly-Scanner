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
    
    /*
    // URL: http://stackoverflow.com/questions/13511102/ios-tesseract-ocr-image-preperation
    static func prepareCameraImage(image: UIImage) -> UIImage {
        let d_colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let d_bytesPerRow: size_t = size_t(image.size.width * 4.0)
        let imgData: CUnsignedChar = CUnsignedChar(size_t(image.size.height) * d_bytesPerRow)
        
        let context = CGContext(data: imgData, width: image.size.width, height: image.size.height, bitsPerComponent: 8, bytesPerRow: d_bytesPerRow, space: d_colorSpace, bitmapInfo: .non)
        
        UIGraphicsPushContext(context)
        
        // These next two lines 'flip' the drawing so it doesn't appear upside-down.
        context.translateBy(x: 0.0, y: image.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Use UIImage's drawInRect: instead of the CGContextDrawImage function, otherwise you'll have issues when the source image is in portrait orientation.
        image.draw(in: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(image.size.width), height: CGFloat(image.size.height)))
        UIGraphicsPopContext()
        /*
         * At this point, we have the raw ARGB pixel data in the imgData buffer, so
         * we can perform whatever image processing here.
         */
        // After we've processed the raw data, turn it back into a UIImage instance.
        var new_img: CGImage = context.makeImage()
        var convertedImage = UIImage(cgImage: new_img)
        CGContextRelease(context)
//        free(imgData)
        return convertedImage

    } */
    
    // Scale the image
    static func prepareImage(image: UIImage) -> UIImage {
        let resetImage: UIImage = ImageHelper.resetImageData(image: image) // Remove extra data
        return adaptiveThreshold(image: scaleImage(image: resetImage, maxDimension: 640.0))
    }
    
    static func adaptiveThreshold(image: UIImage) -> UIImage {
        // Use GPUImage's Adaptive threshold
        
        // Initialize our adaptive threshold filter
        let stillImageFilter: GPUImageAdaptiveThresholdFilter = GPUImageAdaptiveThresholdFilter()
        
        stillImageFilter.blurRadiusInPixels = Options.GPUBlurRadius // Blur radius of the filter, defaults to 4.0
        
        let filteredImage: UIImage = stillImageFilter.image(byFilteringImage: image) // Make filtered image
        
        return filteredImage
    }
    
    static func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        // Scale image
        // print("Old dimensions: \(image.size.width), \(image.size.height)")
        
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
        
        // print("New dimensions: \(scaledImage?.size.width), \(scaledImage?.size.height)")
        
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
//        return ImageProcessing.prepareImage(image: sourceImage, maxDimension: 640) // Return processed
        return ImageProcessing.prepareImage(image: sourceImage).g8_blackAndWhite() // Return processed
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("progress: %lu", tesseract.progress) // Print progress
    }
    
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return false
    }
    
    static func testing(image: UIImage) -> String {
        let str = ImageProcessing.performImageRecognition(image: image)
//        print(str) // Print raw text
        
        let preprocessed: String = NaturalLangProcessing.preprocess(text: str)
        let lemmatizedText = NaturalLangProcessing.lemmatize(text: preprocessed)
        
        // Print lematized
        var output = ""
        for (key, value) in lemmatizedText {
            output += key + ": " + value + "     "
        }
//        print(output)
        
        // Test the NLP
        let year: String = NaturalLangProcessing.Year(text: preprocessed)
        let month: String = NaturalLangProcessing.Month(text: preprocessed)
        let time: String = NaturalLangProcessing.Time(text: preprocessed)

//        print("Year: " + year)
//        print("Month: " + month)
//        print("Time: " + time)
//        print(NaturalLangProcessing.getDate(text: preprocessed)) // Print the concatinated date
        
        print("Processing complete")
        
        return preprocessed
    }
}
