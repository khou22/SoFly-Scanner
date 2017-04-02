//
//  DateExtension.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 4/2/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation

extension Date {
    
    // Remove the time component of a Date type
    func dateWithoutTime() -> Date {
        let dateFormatter = DateFormatter() // Initialize new Date Formatter
        
        dateFormatter.dateStyle = .medium // Doesn't include time component
        let dateToPrint: NSString = dateFormatter.string(from: self) as NSString // Format into medium style string
        let dateNoTime = dateFormatter.date(from: dateToPrint as String) // Get a date from midnight that day
        
        return dateNoTime! // Return result
    }
    
}
