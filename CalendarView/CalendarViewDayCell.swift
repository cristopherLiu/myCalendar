//
//  MNCalendarViewDayCell.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/3.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewDayCell: CalendarViewCell{
    
    var calendar:NSCalendar!
    var date:NSDate!
    var month:NSDate!
    var Weekday:Int! = 0
    
    //是否可以選取
    override var enabled:Bool{
        didSet{
            titleLabel.textColor = enabled ? UIColor.ColorRGB(0x434A54, alpha: 1) : UIColor.ColorRGB(0x434A54, alpha: 0.4)
            backgroundColor = enabled ? UIColor.whiteColor() : UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDate(Date:NSDate , Month:NSDate , Calendar:NSCalendar){
        date = Date
        month = Month
        calendar = Calendar
        
        var components = Calendar.components(
            NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitWeekday | NSCalendarUnit.CalendarUnitDay,
            fromDate: Date)
        
        var monthComponents = Calendar.components(
            NSCalendarUnit.CalendarUnitMonth,
            fromDate: Month)
        
        Weekday = components.weekday
        titleLabel.text = "\(components.day)"
        self.enabled = monthComponents.month == components.month
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var context = UIGraphicsGetCurrentContext()
        
        var separatorColor = self.separatorColor.CGColor
        var size = self.bounds.size
        
        if Weekday != 7 {
            var pixel = 1 / UIScreen.mainScreen().scale
            ContextDrawLine(context,
                start: CGPointMake(size.width - pixel, pixel),
                end: CGPointMake(size.width - pixel, size.height),
                color: separatorColor,
                lineWidth: pixel);
        }
    }
}