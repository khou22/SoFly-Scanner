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
        let data = UIImageJPEGRepresentation(image, 0.5)
        let imagePt = UIImage(data: data!)
        
        let imageData: NSData = ImageHelper.removeExifData(data: UIImagePNGRepresentation(imagePt!) as! NSData)!
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

extension UIImage {
    
    public func rotateImageByDegrees(_ degrees: CGFloat) -> UIImage {
        
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: self.size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        // Rotate the image context
        bitmap?.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        
        let cgimage:CGImage  = bitmap!.makeImage()!
        return UIImage(cgImage: cgimage)
    }
}
