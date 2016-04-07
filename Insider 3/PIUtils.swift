//
//  PIUtils.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 17.03.16.
//  Copyright © 2016 PKMR. All rights reserved.
//

import Foundation
import UIKit



enum PopoverType {
    case Sort
    case Filter
    case Alert
}

class PIControlViewFactory {
    
    enum LabelType:String {
        case RateLabel
        case ChangeLabel
        case EmitentLabel
        case MaturityDateLabel
        case YieldLabel
        case DayValueLabel
        case CouponLabel
        
        case Fundname
        case Ukname
        case Fundtype
        case Fundcat
        case Registrationdate
        case Startformirdate
        case Endformirdate
        case Minsumminvest
        case Stpaya
        case Scha
        case Url

        
        var description: String {
            switch self {
                case .RateLabel: return "Rate: "
                case .ChangeLabel: return "Change: "
                case .EmitentLabel: return "emitent: "
                case .MaturityDateLabel: return "maturityDate: "
                case .YieldLabel: return "yield: "
                case .DayValueLabel: return "dayValue: "
                case .CouponLabel: return "coupon: "
                    
                case Fundname: return "fundname"
                case Ukname: return "ukname"
                case Fundtype: return "fundtype"
                case Fundcat: return "fundcat"
                case Registrationdate: return "registration date"
                case Startformirdate: return "start form date"
                case Endformirdate: return "end form date"
                case Minsumminvest: return "min sum invest"
                case Stpaya: return "stpaya"
                case Scha: return "scha"
                case Url: return "url"
            }
        }
    }
    
    enum ButtonType: String {
        case DayButton
        case WeekButton
        case MonthButton
        case YearButton
        case ThreeYearsButton
        case FiveYearsButton
        
        var description: String {
            switch self {
                case DayButton: return "1d"
                case WeekButton: return "1w"
                case MonthButton: return "1m"
                case YearButton: return "1y"
                case ThreeYearsButton: return "3y"
                case FiveYearsButton: return "5y"
            }
        }
    }
    
    
    class func NewLabelsWithTextAndValue(type: LabelType,value:String) -> (UILabel,UILabel) {
        
        
        let valueLabel = UILabel()
        let textLabel = UILabel()
        
        valueLabel.text = value
        textLabel.text = type.description
        return (textLabel,valueLabel)
        
        
    }
    
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

