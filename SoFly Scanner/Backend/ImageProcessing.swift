//
//  ImageProcessing.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation

import  UIKit

func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
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
   image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
   let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
   UIGraphicsEndImageContext()
 return scaledImage
}


func performImageRecognition(image: UIImage) -> String {
	let tesseract = G8Tesseract()
	tesseract.language = "eng"
	tesseract.engineMode = .TesseractCubeCombined
	tesseract.pageSegmentationMode = .Auto
	tesseract.maximumRecognitionTime = 60.0
	tesseract.image = scaleImage(image, 640).g8_blackAndWhite()
	tesseract.recognize()
	return tesseract.recognizedText
}