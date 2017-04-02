//
//  ImageHelper.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 4/1/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import ImageIO
import AVFoundation

class ImageHelper {
    static func resetImageData(image: UIImage) -> UIImage {
        let imageData: NSData = ImageHelper.removeExifData(data: UIImagePNGRepresentation(image) as! NSData)!
        return UIImage(data: imageData as Data)!
    }
    
    static func removeExifData(data: NSData) -> NSData? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            return nil
        }
        guard let type = CGImageSourceGetType(source) else {
            return nil
        }
        let count = CGImageSourceGetCount(source)
        let mutableData = NSMutableData(data: data as Data)
        guard let destination = CGImageDestinationCreateWithData(mutableData, type, count, nil) else {
            return nil
        }
        // Check the keys for what you need to remove
        // As per documentation, if you need a key removed, assign it kCFNull
        let removeExifProperties: Dictionary = [String(kCGImagePropertyExifDictionary) : kCFNull, String(kCGImagePropertyOrientation): kCFNull]
        
        for i in 0..<count {
            CGImageDestinationAddImageFromSource(destination, source, i, removeExifProperties as CFDictionary)
        }
        
        guard CGImageDestinationFinalize(destination) else {
            return nil
        }
        
        return mutableData
    }
}
