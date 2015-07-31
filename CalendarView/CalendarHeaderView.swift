//
//  MNCalendarHeaderView.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/3.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import Foundation
import UIKit

class CalendarHeaderView :UICollectionReusableView{
    
    private var titleLabel:UILabel!
    private var _date:NSDate!
    
    var date:NSDate{
        set{
            _date = newValue
            self.titleLabel.text = "\(newValue.Year())年\(newValue.Month())月"
        }
        get{
            return _date
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel(frame: self.bounds)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.ColorRGB(0x434A54, alpha: 1)
        titleLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.textAlignment = NSTextAlignment.Center
        
        self.addSubview(titleLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

