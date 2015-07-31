//
//  DateSet.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/10.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import UIKit

class DateSet : NSObject{
    
    private var data:Set<DayOff>
    
    //init
    override init(){
        data = Set<DayOff>()
        super.init()
    }
    init<S: SequenceType where S.Generator.Element == DayOff>(sequence:S){
        data = Set<DayOff>(sequence)
        super.init()
    }
    
    //移除
    func remove(item:DayOff)->DateSet{
        data.remove(item)
        return DateSet(sequence: data)
    }
    
    func remove<S: SequenceType where S.Generator.Element == DayOff>(sequence:S)->DateSet{
        return DateSet(sequence: data.subtract(sequence))
    }
    
    //增加
    func add(item:DayOff)->DateSet{
        data.insert(item)
        return DateSet(sequence: data)
    }
    
    func add<S: SequenceType where S.Generator.Element == DayOff>(sequence:S)->DateSet{
        return DateSet(sequence: data.union(sequence))
    }
    
    //數量
    func count()->Int{
        return data.count
    }
    
    func contains(member: DayOff)->Bool{
        return data.contains(member)
    }
    
    override var description:String{
        
        var str = ""
        for d in data{
            
            switch d.offType.value{
            case .All:
                str += "[\(d.date.toShortString()) 全天]"
            case .AllUsed:
                str += "[\(d.date.toShortString()) 全天]"
            case .Half:
                str += "[\(d.date.toShortString()) 半天]"
            case .HalfUsed:
                str += "[\(d.date.toShortString()) 半天]"
            case .HalfHalfUsed:
                str += "[\(d.date.toShortString()) 全天]"
            default:
                str += ""
            }
        }
        return str
    }
    
    func find(date:NSDate)->DayOff?{
        var a = Array(data).filter{
            $0.date == date
        }
        return a.first
    }
    
    //變更狀態
    func changeStatus(date:NSDate)->dStatus{
        //檢查日期是否存在
        let dayOff = find(date)
        
        //存在
        if let dayOff = dayOff{
            
            var nextValue:dStatus = dayOff.offType.next() //下一個狀態
            
            //下一個狀態為0,則移除
            if nextValue == dStatus.None{
                remove(dayOff) //從list移除
            }
            return nextValue
        }
            //不存在
        else{
            
            var newValue = DayStatus()
            var nextValue:dStatus = newValue.next() //下一個狀態
            var dayOff = DayOff(date: date, offType: newValue)
            add(dayOff) //加入list
            return nextValue
        }
    }
    
    //取得當前狀態
    func getStatus(date:NSDate)->dStatus{
        let dayOff = find(date)
        if let dayOff = dayOff {
            return dayOff.offType.value
        }
        else{
            return DayStatus().value
        }
    }
}

extension DateSet:SequenceType{
    func generate()->SetGenerator<DayOff>{
        return data.generate()
    }
}

//請假資料結構
public class DayOff:NSObject{
    
    var date:NSDate //日期
    var offType:DayStatus //請假狀態
    
    init(date:NSDate,offType:DayStatus){
        
        self.date = date.datePart
        self.offType = offType
    }
}

public func ==(lhs: DayOff, rhs: DayOff) -> Bool {
    return lhs.date === rhs.date || lhs.date.compare(rhs.date) == .OrderedSame
}

public func <(lhs: DayOff, rhs: DayOff) -> Bool {
    return lhs.date.compare(rhs.date) == .OrderedAscending
}

public func >(lhs: DayOff, rhs: DayOff) -> Bool {
    return lhs.date.compare(rhs.date) == .OrderedDescending
}

extension DayOff: Comparable { }



