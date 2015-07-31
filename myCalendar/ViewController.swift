//
//  ViewController.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/2.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,CalendarViewDelegate{

    var calendarView:CalendarView!
    var btn = UIButton()
    
    var datePickerModel:DatePickerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.ColorRGB(0xEBEBEB, alpha: 1) //背景色
        
        calendarView = CalendarView(frame: CGRectZero)
        calendarView.separatorColor = UIColor.ColorRGB(0x6CC6D5, alpha: 1) //間隔線顏色
        calendarView.collectionView.backgroundColor = UIColor.clearColor()
        calendarView.delegate = self
        calendarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(calendarView)
        
        btn.setTitle("確認", forState: UIControlState.Normal)
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage.imageWithColor(UIColor.ColorRGB(0x6CC6D5, alpha: 1)), forState: UIControlState.Normal)
        btn.addTarget(self, action: "outPut", forControlEvents: UIControlEvents.TouchUpInside)
        btn.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(btn)
        
        //設定已使用日期
        var set = DateSet()
        
//        var newValue1 = DayStatus()
//        newValue1.value = dStatus.AllUsed
//        var dayOff1 = DayOff(date: NSDate().addDay(5), offType: newValue1)
//        set.add(dayOff1)
//        
//        var newValue2 = DayStatus()
//        newValue2.value = dStatus.HalfUsed
//        var dayOff2 = DayOff(date: NSDate().addDay(7), offType: newValue2)
//        set.add(dayOff2)
//        
//        var newValue3 = DayStatus()
//        newValue3.value = dStatus.HalfUsed
//        var dayOff3 = DayOff(date: NSDate().addDay(21), offType: newValue3)
//        set.add(dayOff3)
        
        datePickerModel = DatePickerModel(Dates: set)

        calendarView.getModel = {
            return self.datePickerModel
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        var views = [
            "top" : self.topLayoutGuide,
            "calendarView" : calendarView,
            "btn" : btn,
        ]  as [NSObject : AnyObject]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[btn]-16-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[top][calendarView]-[btn(50)]-8-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
    }
    
    func outPut(){
        println(datePickerModel.description)
        
        let alertController = UIAlertController(
            title: "選擇日期",
            message: datePickerModel.description,
            preferredStyle: .Alert)

        let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func calendarView(calendarView: CalendarView!, didSelectDate date: NSDate!) {
//        println(date)

//        let alertController = UIAlertController(
//            title: "選擇日期",
//            message: date.toShortString(),
//            preferredStyle: .Alert)
//        
//        let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.Default, handler: nil)
//        alertController.addAction(okAction)
//        
//        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //過濾假日enable selected
    func calendarView(calendarView: CalendarView!, shouldSelectDate date: NSDate!) -> Bool {
        
        return date.daysFrom(NSDate()) >= 0
//        return NSDate() < date
    }
}

