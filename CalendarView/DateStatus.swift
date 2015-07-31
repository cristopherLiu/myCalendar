//
//  DateStatus.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/12.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import Foundation

enum dStatus{
    case None
    case All
    case Half
    case AllUsed
    case HalfUsed
    case HalfHalfUsed
}

class DayStatus{
    
    private var _value:dStatus = dStatus.None
    
    var value:dStatus{
        get{
            return _value
        }
        set{
            _value = newValue
        }
    }
    
    func next()->dStatus{
        switch value{
        case .None:
            value = dStatus.All
        case .All:
            value = dStatus.Half
        case .Half:
            value = dStatus.None
        case .AllUsed:
            value = dStatus.AllUsed
        case .HalfUsed:
            value = dStatus.HalfHalfUsed
        case .HalfHalfUsed:
            value = dStatus.HalfUsed
        default:
            value = dStatus.None
        }
        return value
    }
}


