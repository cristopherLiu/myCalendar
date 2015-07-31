//
//  MNCalendarView.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/3.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

@objc protocol CalendarViewDelegate : NSObjectProtocol{
    optional func calendarView(calendarView:CalendarView!, shouldSelectDate date:NSDate!) -> Bool
    optional func calendarView(calendarView: CalendarView!, didSelectDate date: NSDate!)
}

class CalendarView: UIView, UICollectionViewDataSource,  UICollectionViewDelegate{
    
    var collectionView:UICollectionView!
    var layout:UICollectionViewFlowLayout!
    var delegate:CalendarViewDelegate!
    
    private var _calendar:NSCalendar!
    var calendar:NSCalendar!{
        get{
            return _calendar
        }
        set{
            _calendar = newValue
            monthFormatter = NSDateFormatter()
            monthFormatter.locale = NSLocale(localeIdentifier: "zh_TW")
            monthFormatter.calendar = _calendar
            monthFormatter.dateFormat = "yyyy MMMM"
        }
    }
    var fromDate:NSDate!
    var toDate:NSDate!
    
    var getModel:()->DatePickerModel? = { return nil }
    
    var separatorColor:UIColor! //間隔線顏色
    
    var monthDates:[NSDate] = [] //月份list
    var weekdaySymbols:[String] = [] //星期list
    var daysInWeek:Int = 7
    var years:Double = 1
    var monthFormatter:NSDateFormatter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        calendar   = NSCalendar.currentCalendar()
        fromDate   = NSDate().beginningOfDay(calendar:calendar) //今日為起始時間
        toDate     = NSDate().dateByAddingTimeInterval(365 * years * 86400) //今日往後推一年份時間
        separatorColor = UIColor.ColorRGB(0x999999, alpha: 1) //預設間隔線顏色
        
        var layout = CalendarViewLayout()
        collectionView = UICollectionView(frame: CGRect.zeroRect, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerClass(CalendarHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CalendarHeaderView")
        collectionView.registerClass(CalendarViewWeekdayCell.self, forCellWithReuseIdentifier: "CalendarViewWeekdayCell")
        collectionView.registerClass(CalendarViewDayCell.self, forCellWithReuseIdentifier: "CalendarViewDayCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(self.collectionView)
        
        setDefultData()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        var views = ["collectionView":collectionView]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
    }
    
    func setDefultData(){
        var monthDates:[NSDate] = []
        
        var dates = NSDateSequence(
            fromDate: fromDate.firstDateOfMonth(calendar: calendar),
            toDate: toDate.firstDateOfMonth(calendar: calendar),
            calendar: calendar,
            unit: NSCalendarUnit.CalendarUnitMonth)
        
        for date in dates{
            monthDates.append(date)
        }
        
        self.monthDates = monthDates
        
        var formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "zh_TW")
        formatter.calendar = self.calendar
        self.weekdaySymbols = formatter.shortWeekdaySymbols as! [String] //星期標題
        
        self.collectionView.reloadData()
        self.setNeedsUpdateConstraints()
    }
    
    func firstVisibleDateOfMonth(var date:NSDate)->NSDate{
        
        date = date.firstDateOfMonth(calendar: calendar)
        
        var components = calendar.components(
            NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday,
            fromDate: date)
        
        var d = date.dateWithDay((-(components.weekday - 1) % self.daysInWeek),  calendar: calendar)
        return d.dateByAddingTimeInterval(NSTimeInterval(24*60*60))
    }
    
    func lastVisibleDateOfMonth(var date:NSDate)->NSDate{
        
        date = date.lastDateOfMonth(calendar: calendar)
        
        var components = calendar.components(
            NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday,
            fromDate: date)
        
        var d = (components.day + (daysInWeek - 1) - ((components.weekday - 1) % daysInWeek))
        return date.dateWithDay(d,  calendar: calendar)
    }
    
    func dateEnabled(date:NSDate)->Bool{
        if let delegate = delegate {
            if delegate.respondsToSelector("calendarView:shouldSelectDate:"){
                return delegate.calendarView!(self, shouldSelectDate: date)
            }
        }
        return true
    }
    
    func canSelectItemAtIndexPath(indexPath:NSIndexPath)->Bool{
        var cell = collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! CalendarViewCell
        
        var enabled = cell.enabled
        
        if cell.isKindOfClass(CalendarViewDayCell) && enabled{
            var dayCell = cell as! CalendarViewDayCell
            
            enabled = dateEnabled(dayCell.date)
        }
        
        return enabled
    }
    
    //pragma mark - UICollectionViewDataSource
    
    //number of sections
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return monthDates.count
    }
    
    //年月份headerView
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CalendarHeaderView", forIndexPath: indexPath) as! CalendarHeaderView
        headerView.backgroundColor = UIColor.ColorRGB(0xEBEBEB, alpha: 1)
        //headerView.titleLabel.text = self.monthFormatter.stringFromDate(monthDates[indexPath.section])
        headerView.date = monthDates[indexPath.section]
        
        return headerView
    }
    
    //number of items in the section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var monthDate:NSDate = self.monthDates[section]
        var components = calendar.components(
            NSCalendarUnit.CalendarUnitDay,
            fromDate: firstVisibleDateOfMonth(monthDate),
            toDate: lastVisibleDateOfMonth(monthDate),
            options: NSCalendarOptions.allZeros)
        
        //欄位 = 星期標題數 + 日期數
        return daysInWeek + components.day + 1
    }
    
    //定義每個cell內容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //前面7個為星期標題
        if indexPath.item < daysInWeek{
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarViewWeekdayCell", forIndexPath: indexPath) as! CalendarViewWeekdayCell
            cell.backgroundColor = UIColor.ColorRGB(0xEBEBEB, alpha: 1)
            cell.titleLabel.textColor = UIColor.ColorRGB(0x434A54, alpha: 0.8)
            cell.titleLabel.text = weekdaySymbols[indexPath.item]
            cell.separatorColor = self.separatorColor
            
            return cell
        }
        
        //日期cell
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarViewDayCell", forIndexPath: indexPath) as! CalendarViewDayCell
        
        cell.separatorColor = self.separatorColor
        
        //計算日期
        var monthDate:NSDate = monthDates[indexPath.section]
        var firstDateInMonth:NSDate = firstVisibleDateOfMonth(monthDate)
        var day:Int = indexPath.item - self.daysInWeek
        var components:NSDateComponents = self.calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: firstDateInMonth)
        components.day += day
        var date = calendar.dateFromComponents(components)
        
        cell.setDate(date!,  Month: monthDate,  Calendar: calendar)
        
        //取得狀態
        var status = getModel()?.getStatus(date!) //日期當前狀態
        
        //可以使用的日期cell
        if cell.enabled{
            cell.enabled = dateEnabled(date!)
            cell.setStatus(status!)
        }
        
        return cell
    }
    
    
    //pragma mark - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return canSelectItemAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return canSelectItemAtIndexPath(indexPath)
    }
    
    //選取後
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! CalendarViewCell
        
        if cell.isKindOfClass(CalendarViewDayCell) && cell.enabled{
            var dayCell = cell as! CalendarViewDayCell
            
            getModel()?.changeStatus(dayCell.date) //日期變更狀態
            
            if let delegate = delegate{
                if self.delegate.respondsToSelector("calendarView:didSelectDate:"){
                    self.delegate.calendarView!(self, didSelectDate: dayCell.date)
                }
            }
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var width:CGFloat = self.bounds.size.width
        var itemWidth  = CGFloat(roundf(Float(width) / Float(self.daysInWeek)))
        var itemHeight = CGFloat(indexPath.item < self.daysInWeek ? 30 : itemWidth)
        
        var weekday = indexPath.item % self.daysInWeek
        
        if weekday == self.daysInWeek - 1 {
            itemWidth = width - (itemWidth * CGFloat(self.daysInWeek - 1))
        }
        
        return CGSizeMake(itemWidth, itemHeight)
    }
}


