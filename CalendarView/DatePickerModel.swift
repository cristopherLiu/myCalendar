//
//  DatePickerModel.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/10.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import Foundation
import UIKit

class DatePickerModel:NSObject{
    
    private var selectedDates:DateSet!
    
    init(Dates:DateSet?) {
        super.init()
        
        if let dates = Dates{
            selectedDates = dates
        }else{
            selectedDates = DateSet()
        }
        
    }
    
    //變更狀態
    func changeStatus(date:NSDate)->dStatus{
        return selectedDates.changeStatus(date)
    }
    
    //取得狀態
    func getStatus(date:NSDate)->dStatus{
        return selectedDates.getStatus(date)
    }
    
    override var description:String{
        
        var str = ""
        
        if selectedDates.count() > 0{
            str += "\(selectedDates.description)"
        }
        
        if str == ""{
            str = "無"
        }
        
        return str
    }
}
















//class DatePickerModel:NSObject{
//    
//    private var selectedFullDates = DateSet()
//    private var selectedHalfDates = DateSet()
//    
//    override init() {
//        super.init()
//    }
//    
//    private func ToNoneDay(date:NSDate){
//        selectedHalfDates.remove(date)
//    }
//    
//    private func ToAllDay(date:NSDate){
//        selectedFullDates.add(date)
//    }
//    
//    private func ToHalfDay(date:NSDate){
//        selectedFullDates.remove(date)
//        selectedHalfDates.add(date)
//    }
//    
//    func changeStatus(date:NSDate)->DateStatus{
//        switch getStatus(date){
//        case .None:
//            ToAllDay(date)
//            return DateStatus.FullDay
//        case .FullDay:
//            ToHalfDay(date)
//            return DateStatus.HalfDay
//        case .HalfDay:
//            ToNoneDay(date)
//            return DateStatus.None
//        }
//    }
//    
//    func getStatus(date:NSDate)->DateStatus{
//        if selectedFullDates.contains(date){
//            return DateStatus.FullDay
//        }
//        else if selectedHalfDates.contains(date){
//            return DateStatus.HalfDay
//        }
//        else{
//            return DateStatus.None
//        }
//    }
//    
//    override var description:String{
//        
//        var str = ""
//        
//        if selectedFullDates.count() > 0{
//            str += "整日:\(selectedFullDates.description)。"
//        }
//        
//        if selectedHalfDates.count() > 0{
//            str += "半天:\(selectedHalfDates.description)。"
//        }
//        
//        if str == ""{
//            str = "無"
//        }
//        
//        return str
//    }
//}
//
////日期狀態
//enum DateStatus{
//    case None,HalfDay,FullDay
//}
