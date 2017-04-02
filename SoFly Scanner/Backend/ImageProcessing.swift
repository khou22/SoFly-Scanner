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
import MobileCoreServices

class ImageProcessing: NSObject {
    
    static let monthDict = ["JANUARY": 01, "JAN": 01, "01" : 01, "1" :01,
                            "FEBRUARY": 02, "FEB": 02, "02" : 02, "2" :02,
                            "MARCH" : 03, "MAR": 03, "03": 03, "3":03,
                            "APRIL" : 04, "APR": 04, "04": 04, "4":04,
                            "MAY" : 05, "05": 05, "5":05,
                            "JUNE" : 06, "JUN": 06, "06": 06, "6":06,
                            "JULY" : 07, "JUL": 07, "07": 07, "7":07,
                            "AUGUST" : 08, "AUG":08, "08":08, "8":08,
                            "SEPTEMBER" : 09, "SEP": 09,"SEPT": 09, "09": 09, "9":09,
                            "OCTOBER" : 10, "OCT": 10,  "10":10,
                            "NOVEMBER" : 11, "NOV": 11, "11": 11,
                            "DECEMBER" : 12, "DEC": 12, "12": 12]
    
    static let dayDict = ["MONDAY": 01, "MON" : 01,
                          "TUESDAY": 02, "TUES" : 02,
                          "WEDNESDAY": 03, "WED" : 03,
                          "THURSDAY": 04, "THURS" : 04,
                          "FRIDAY": 05, "FRI": 05,
                          "SATURDAY": 06, "SAT" : 06,
                          "SUNDAY" : 07, "SUN": 07]
    
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
        let preppedImage: UIImage = adaptiveThreshold(image: scaleImage(image: resetImage, maxDimension: 640.0))
        
        let data = UIImagePNGRepresentation(preppedImage)
        let finalImage = UIImage(data: data!)!
        
        let returnImage: UIImage = finalImage.rotateImageByDegrees(90.0)

        /*
        // Create path.
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let filePath = paths[0] + "/Image.png"
        let url = URL(fileURLWithPath: filePath)
        
        // Save image.
        do {
            try data?.write(to: url)
        } catch {
            print(error)
        }
        
        let fm = FileManager.default
        let data2 = fm.contents(atPath: filePath)
        
        let returnImage: UIImage = UIImage(data: data2!)!
        
        UIImageWriteToSavedPhotosAlbum(returnImage, nil, nil, nil) // Save to camera roll
 */
        
        return returnImage
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
        let scaledImageData: NSData = UIImageJPEGRepresentation(scaledImage!, 0.5) as! NSData // 50% quality
        UIGraphicsEndImageContext()
        
        // print("New dimensions: \(scaledImage?.size.width), \(scaledImage?.size.height)")
        
        return UIImage(data: scaledImageData as! Data)!
    }

    // Execute Tesseract API
    static func performImageRecognition(image: UIImage) -> String {
        // Tesseract OCR
        let tesseract = G8Tesseract()
        tesseract.language = "eng"
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 120.0
        tesseract.image = ImageProcessing.prepareImage(image: image).g8_blackAndWhite() // Return processed
        tesseract.recognize()
    
        return tesseract.recognizedText // Return text
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("progress: %lu", tesseract.progress) // Print progress
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
//        print(output)
        
        // Test the NLP
        let year: String = NaturalLangProcessing.Year(text: preprocessed)
        let month: String = NaturalLangProcessing.Month(text: preprocessed)
        let time: String = NaturalLangProcessing.Time(text: preprocessed)

        print("Year: " + year)
        print("Month: " + month)
        print("Time: " + time)
//        print(NaturalLangProcessing.getDate(text: preprocessed)) // Print the concatinated date
        
        print("Processing complete")
        
        return preprocessed
    }
    
    static func cleanString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    static func process(image: UIImage) -> ScannedEvent {
        let rawText: String = ImageProcessing.performImageRecognition(image: image)
        let preprocessed: String = NaturalLangProcessing.preprocess(text: rawText)
        let lemmatizedText = NaturalLangProcessing.lemmatize(text: preprocessed)
        
        print(rawText)
        print(preprocessed)
        
        // Get date components
        let yearStr: String = NaturalLangProcessing.Year(text: preprocessed)
        var year: Int? = Int(yearStr)
        if (yearStr.contains("2017")) {
            year = 2017
        } else if (yearStr.contains("2016")) {
            year = 2016
        } else if (yearStr.contains("2015")) {
            year = 2015
        }
        
        let time: String = NaturalLangProcessing.Time(text: preprocessed) // Returns: 00:00, 00 AM
        
        let allDates: [String] = NaturalLangProcessing.PullDate(text: preprocessed) // Get all dates
        var dates: [Date] = [] // Empty
        for index in 0..<allDates.count { // Cycle through
            let date: String = allDates[index] // Get current date string
            
            let monthDay: [String] = date.characters.split{$0 == " "}.map(String.init) // Seperrated by ' '
            print(monthDay)
            let monthKey: String = cleanString(text: monthDay[0]).uppercased()
            print(monthKey)
            let monthValue: Int = self.monthDict[monthKey]!
            
            var dayValue: Int = 1
            if monthDay.count >= 2 {
                dayValue = Int(monthDay[1].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted))! // Get integer from string
            }
            
            print(time)
            var format = "h:mm"
            if ((time.range(of: "AM")) != nil || time.range(of: "PM") != nil) { // If there's an AM/PM
                
                if (time.range(of: ":") != nil) { // If there's a colon
                    format = "h:mm a"
                } else {
                    format = "h a"
                }
            }
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            print(format)
            
            let timeDate: Date = dateFormatter.date(from: time)! // Get time
            
            print(timeDate)
            
            let components = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: year, month: monthValue, day: dayValue, hour: Calendar.current.component(.hour, from: timeDate), minute: Calendar.current.component(.minute, from: timeDate), second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
            
            dates.append(components.date!) // Get and add date object
        }
        
        // Check if end date exists
        var endDate = dates[0].addingTimeInterval(2 * 60 * 60) // Default two hours long
        if dates.count >= 2 {
            endDate = dates[1]
        }
        
        let eventName: String = NaturalLangProcessing.getTitleEstimate(text: rawText)
        let location: String = NaturalLangProcessing.Location(lemmas: lemmatizedText)
        
        // Put into a date object
        let eventObj: ScannedEvent = ScannedEvent(with: eventName, location: location, startDate: dates[0], endDate: endDate, preprocessed: preprocessed)
        
        return eventObj // Return object
    }
}
