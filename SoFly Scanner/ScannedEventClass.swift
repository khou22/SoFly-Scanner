//
//  ScannedEventClass.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation

class ScannedEvent {
    
    // MARK - Instance variables
    // Basic information
    var name: String
    var location: String
    var startDate: Date
    var endDate: Date
    
    // Not as important
    var summary: String
    var facebookLink: String
    
    // Initializer
    init(with name: String, location: String, startDate: Date, endDate: Date) {
        // Set instance variables
        self.name = name
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .long
        
        // Default values
        self.summary = "\(name) at \(location) from \(formatter.string(from: startDate)) to \(formatter.string(from: endDate))"
        self.facebookLink = "NA"
    }
    
}
