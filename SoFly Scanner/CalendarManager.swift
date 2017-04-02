//
//  CalendarManager.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 4/2/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import EventKit

class CalendarManager {
    
    let eventStore: EKEventStore = EKEventStore()
    
    // Request access to read and add calendar events
    func requestAccess(completion: @escaping (_ success: Bool) -> Void) {
        self.eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (error != nil) {
                print("Error \(String(describing: error))")
                completion(false)
            } else {
                //                print("Granted access \(granted)")
                completion(true)
            }
        })
    }
    
    func saveEvent(event: EKEvent) {
        do {
            try self.eventStore.save(event, span: .thisEvent) // Try to add to calendar
            
            print("Event added successfully")
        } catch let err as NSError {
            print("Event could not be added")
            print("An error occured \(err.localizedDescription)")
        }
    }
    
    func getEvents(day: Date) -> [EKEvent] {
        let start: Date = day.dateWithoutTime() // Current day
        let end: Date = start.addingTimeInterval(24.0 * 60.0 * 60.0) // Exactly one day after
        let calendars: [EKCalendar] = eventStore.calendars(for: .event) // For all calendars
        let predicate: NSPredicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
        let events: [EKEvent] = self.eventStore.events(matching: predicate) // Return events
        //        print("Retrieved \(events.count) events")
        return events
    }
}
