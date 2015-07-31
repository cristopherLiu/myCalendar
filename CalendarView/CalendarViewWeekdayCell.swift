//
//  MNCalendarViewWeekdayCell.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/3.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewWeekdayCell:CalendarViewCell {
    
    var _weekday:Int = 0
    var weekday:Int!{
        get{
            return _weekday
        }
        set{
            _weekday = newValue
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = UIFont.systemFontOfSize(12)
        enabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
