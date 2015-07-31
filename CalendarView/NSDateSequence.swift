//
//  MNFastDateEnumeration.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/3.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import Foundation

class NSDateSequence: SequenceType, GeneratorType {
    
    var calendar:NSCalendar!
    var fromDate:NSDate!
    var toDate:NSDate!
    var currentDate:NSDate!
    var unit:NSCalendarUnit!
    var components:NSDateComponents!
    
    init(fromDate:NSDate,toDate:NSDate,calendar:NSCalendar,unit:NSCalendarUnit) {
        self.fromDate   = fromDate
        self.toDate     = toDate
        self.calendar   = calendar
        self.unit       = unit
        self.components = self.calendar.components(unit, fromDate: self.fromDate, toDate: self.toDate, options: NSCalendarOptions.allZeros)
        self.currentDate = fromDate
    }
    
    func generate() -> NSDateSequence {
        return NSDateSequence(fromDate: fromDate, toDate: toDate, calendar: calendar, unit: unit)
    }
    
    func next() -> NSDate? {
        let c = currentDate
        currentDate = currentDate.nextFirstDateOfMonth()
        if c < toDate {
            return c
        }
        return nil
    }
}
