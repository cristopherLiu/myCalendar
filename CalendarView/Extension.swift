//
//  Extension.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/3.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import Foundation
import UIKit


extension UIColor{
 
    class func ColorRGB(rgbValue: UInt,alpha:Double) -> UIColor{
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

public func >(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending
}

extension NSDate: Comparable { }

extension NSDate{
    
    class func Parse(dateString:String!)->NSDate?{
        if dateString == nil {
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.dateFromString(dateString) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let date = dateFormatter.dateFromString(dateString) {
            return date
        }
        return nil
    }
    
    func Day()->String{
        let day = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: self).day
        return String(format: "%02d", day)
    }
    
    func Week()->String{
        let Weekday = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: self).weekday
        let map = ["","日","一","二","三","四","五","六"]
        
        return map[Weekday]
    }
    
    func Month()->String{
        let month = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: self).month
        //let map = ["","1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
        
        return String(format: "%02d", month)
    }
    
    func Year()->String{
        let year = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear, fromDate: self).year
        return "\(year)"
    }
    
    func toShortString()->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.stringFromDate(self)
    }
    
    func toString()->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.stringFromDate(self)
    }
    
    func addMonths(month:Int)->NSDate{
        //let gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)! //ios7
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let offsetComponents = NSDateComponents()
        offsetComponents.month = month
        return gregorian.dateByAddingComponents(offsetComponents, toDate: NSDate(), options: NSCalendarOptions.allZeros)!
    }
    
    func addSecond(sec:Int)->NSDate{
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let offsetComponents = NSDateComponents()
        offsetComponents.second = sec
        return gregorian.dateByAddingComponents(offsetComponents, toDate: NSDate(), options: NSCalendarOptions.allZeros)!
    }
    
    func addDay(day:Int)->NSDate{
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let offsetComponents = NSDateComponents()
        offsetComponents.day = day
        return gregorian.dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendarOptions.allZeros)!
    }
    
    func firstDateOfMonth(calendar:NSCalendar! = NSCalendar.currentCalendar())->NSDate{
        var components = calendar.components(
            NSCalendarUnit.CalendarUnitYear |
                NSCalendarUnit.CalendarUnitMonth |
                NSCalendarUnit.CalendarUnitDay
            , fromDate: self)
        components.day = 1
        
        return calendar.dateFromComponents(components)!
    }
    
    func lastDateOfMonth(calendar:NSCalendar! = NSCalendar.currentCalendar())->NSDate{
        var components = calendar.components(
            NSCalendarUnit.CalendarUnitYear |
                NSCalendarUnit.CalendarUnitMonth |
                NSCalendarUnit.CalendarUnitDay
            , fromDate: self)
        components.day = 0
        components.month = components.month + 1
        
        return calendar.dateFromComponents(components)!
    }
    
    func beginningOfDay(calendar:NSCalendar! = NSCalendar.currentCalendar())->NSDate{
        var components = calendar.components(
            NSCalendarUnit.CalendarUnitYear |
                NSCalendarUnit.CalendarUnitMonth |
                NSCalendarUnit.CalendarUnitDay
            , fromDate: self)
        //components.hour = 0
        
        return calendar.dateFromComponents(components)!
    }
    
    func dateWithDay(day:Int , calendar:NSCalendar! = NSCalendar.currentCalendar())->NSDate{
        var components = calendar.components(
            NSCalendarUnit.CalendarUnitYear |
                NSCalendarUnit.CalendarUnitMonth |
                NSCalendarUnit.CalendarUnitDay
            , fromDate: self)
        components.day = day
        
        return calendar.dateFromComponents(components)!
    }
    
    func nextFirstDateOfMonth(calendar:NSCalendar! = NSCalendar.currentCalendar())->NSDate{
        var components = calendar.components(
            NSCalendarUnit.CalendarUnitYear |
                NSCalendarUnit.CalendarUnitMonth |
                NSCalendarUnit.CalendarUnitDay
            , fromDate: self)
        components.day = 1
        components.month = components.month + 1
        
        return calendar.dateFromComponents(components)!
    }
    
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear, fromDate: date, toDate: self, options: nil).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: date, toDate: self, options: nil).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: date, toDate: self, options: nil).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: date, toDate: self, options: nil).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: date, toDate: self, options: nil).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMinute, fromDate: date, toDate: self, options: nil).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond, fromDate: date, toDate: self, options: nil).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
    
    var datePart:NSDate{
        return self.beginningOfDay()
    }
}


extension UIView{
    
    class func dump(view:UIView){
        dump(view, level:0)
    }
    
    class func dump(view:UIView, level:Int){
        var s:String = String(count: level * 2, repeatedValue: (" " as Character))
        println("\(s)\(view)")
        for v in view.subviews {
            if v is UIView {
                dump((v as! UIView), level: level+1)
            }
        }
    }
}

extension UIImage {
    
    /**
    製作純色image
    
    :param: color 顏色
    
    :returns: 製作完成的image
    */
    class func imageWithColor(color:UIColor?) -> UIImage! {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()
        
        if let color = color {
            
            color.setFill()
        }
        else {
            
            UIColor.whiteColor().setFill()
        }
        
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}


    