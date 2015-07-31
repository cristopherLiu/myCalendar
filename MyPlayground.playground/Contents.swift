//: Playground - noun: a place where people can play

import UIKit


enum dStatus:String{
    case None = "無"
    case All = "全天"
    case Half = "半天"
    case AllUsed = "全天已使用"
    case HalfUsed = "半天已使用"
    case HalfHalfUsed = "半天 & 半天已使用"
}

dStatus.All.rawValue


