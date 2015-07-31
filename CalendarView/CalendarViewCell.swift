//
//  MNCalendarViewCell.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/3.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewCell: UICollectionViewCell ,UIGestureRecognizerDelegate {
    
    var titleLabel:UILabel!
    var enabled:Bool = false
    var separatorColor:UIColor!
    
    var upHalfLayer = CAShapeLayer()
    var downHalfLayer = CAShapeLayer()
    
    var usedBGColor = UIColor.ColorRGB(0xDBDBDB, alpha: 1) //以使用的背景顏色
    var usedFontColor = UIColor.ColorRGB(0x434A54, alpha: 0.8) //以使用的字顏色
    
    var selectedBGColor = UIColor.ColorRGB(0xFFE791, alpha: 1) //選取的背景顏色
    var selectedFontColor = UIColor.ColorRGB(0x434A54, alpha: 1) //選取的字顏色
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        
        self.titleLabel = UILabel(frame: self.bounds)
        self.titleLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight
        self.titleLabel.font = UIFont.systemFontOfSize(14)
        self.titleLabel.textColor = UIColor.darkTextColor()
        self.titleLabel.highlightedTextColor = UIColor.darkTextColor()
        self.titleLabel.textAlignment = NSTextAlignment.Center
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(titleLabel)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if upHalfLayer != nil{
            upHalfLayer.removeFromSuperlayer()
        }
        if downHalfLayer != nil{
            downHalfLayer.removeFromSuperlayer()
        }
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        
        var separatorColor = self.separatorColor.CGColor
        
        var pixel = 1 / UIScreen.mainScreen().scale
        ContextDrawLine(context,
            start: CGPointMake(0, self.bounds.size.height),
            end: CGPointMake(self.bounds.size.width, self.bounds.size.height),
            color: separatorColor,
            lineWidth: pixel)
    }
    
    func ContextDrawLine(c:CGContextRef, start:CGPoint, end:CGPoint, color:CGColorRef, lineWidth:CGFloat){
        CGContextSetAllowsAntialiasing(c, false)
        CGContextSetStrokeColorWithColor(c, color)
        CGContextSetLineWidth(c, lineWidth)
        CGContextMoveToPoint(c, start.x, start.y - (lineWidth/2))
        CGContextAddLineToPoint(c, end.x, end.y - (lineWidth/2))
        CGContextStrokePath(c)
        CGContextSetAllowsAntialiasing(c, true)
    }
    
    //設定狀態
    func setStatus(s:dStatus){
        
        selected = false
        
        switch s{
            
        case .None:
            if downHalfLayer != nil{
                upHalfLayer.removeFromSuperlayer()
            }
            self.titleLabel.textColor = UIColor.ColorRGB(0x434A54, alpha: 0.8)
        case .All:
            self.backgroundColor = selectedBGColor
            self.titleLabel.textColor = selectedFontColor
        case .Half:
            addDownHalfLayer(selectedBGColor)
            self.titleLabel.textColor = selectedFontColor
        case .AllUsed:
            self.backgroundColor = usedBGColor
            self.titleLabel.textColor = usedFontColor
        case .HalfUsed:
            addDownHalfLayer(usedBGColor)
            self.titleLabel.textColor = usedFontColor
        case .HalfHalfUsed:
            addDownHalfLayer(usedBGColor)
            addUpHalfLayer(selectedBGColor)
            self.titleLabel.textColor = selectedFontColor
        }
    }
    
    func addUpHalfLayer(color:UIColor){
        var path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(self.frame.width, 0))
        path.addLineToPoint(CGPointMake(self.frame.width, self.frame.height/2))
        path.addLineToPoint(CGPointMake(0, self.frame.height/2))
        upHalfLayer.path = path.CGPath
        upHalfLayer.fillColor = color.CGColor
        upHalfLayer.strokeColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).CGColor //預設間隔線顏色
        upHalfLayer.lineWidth = 0
        self.contentView.layer.insertSublayer(upHalfLayer, below: titleLabel.layer)
    }
    
    func addDownHalfLayer(color:UIColor){
        var path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, self.frame.height/2))
        path.addLineToPoint(CGPointMake(self.frame.width, self.frame.height/2))
        path.addLineToPoint(CGPointMake(self.frame.width, self.frame.height - 0.5))
        path.addLineToPoint(CGPointMake(0, self.frame.height - 0.5))
        downHalfLayer.path = path.CGPath
        downHalfLayer.fillColor = color.CGColor
        downHalfLayer.strokeColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).CGColor //預設間隔線顏色
        downHalfLayer.lineWidth = 0
        self.contentView.layer.insertSublayer(downHalfLayer, below: titleLabel.layer)
    }
}


