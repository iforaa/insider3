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
    case sort
    case filter
}

class PIControlViewFactory {
    
    enum LabelType:String {
        case rateLabel
        case changeLabel
        case emitentLabel
        case maturityDateLabel
        case yieldLabel
        case dayValueLabel
        case couponLabel
        
        case fundname
        case ukname
        case fundtype
        case fundcat
        case registrationdate
        case startformirdate
        case endformirdate
        case minsumminvest
        case stpaya
        case scha

        
        var description: String {
            switch self {
            case .rateLabel: return "Rate: "
            case .changeLabel: return "Change: "
            case .emitentLabel: return "emitent: "
            case .maturityDateLabel: return "maturityDate: "
            case .yieldLabel: return "yield: "
            case .dayValueLabel: return "dayValue: "
            case .couponLabel: return "coupon: "
                
            case fundname: return "fundname"
            case ukname: return "ukname"
            case fundtype: return "fundtype"
            case fundcat: return "fundcat"
            case registrationdate: return "registration date"
            case startformirdate: return "start form date"
            case endformirdate: return "end form date"
            case minsumminvest: return "min sum invest"
            case stpaya: return "stpaya"
            case scha: return "scha"
            }
        }
    }
    
    enum ButtonType: String {
        case dayButton
        case weekButton
        case monthButton
        case yearButton
        case threeYearsButton
        case fiveYearsButton
        
        var description: String {
            switch self {
            case dayButton: return "1d"
            case weekButton: return "1w"
            case monthButton: return "1m"
            case yearButton: return "1y"
            case threeYearsButton: return "3y"
            case fiveYearsButton: return "5y"
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
    
    class func NewButton(type: ButtonType,target: AnyObject?) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal)
        button.setTitle(type.description, forState: UIControlState.Normal)
        
        switch type {
        case .dayButton:
            button.addTarget(target, action: #selector(PIContentVC.oneDayPeriodAction), forControlEvents: .TouchUpInside)
        case .weekButton:
    
            button.addTarget(target, action: #selector(PIContentVC.oneWeekPeriodAction), forControlEvents: .TouchUpInside)
        case .monthButton:
    
            button.addTarget(target, action: #selector(PIContentVC.oneMonthPeriodAction), forControlEvents: .TouchUpInside)
        case .yearButton:
    
            button.addTarget(target, action: #selector(PIContentVC.oneYearPeriodAction), forControlEvents: .TouchUpInside)
        case .threeYearsButton:
    
            button.addTarget(target, action: #selector(PIContentVC.threeYearsPeriodAction), forControlEvents: .TouchUpInside)
        case .fiveYearsButton:
    
            button.addTarget(target, action: #selector(PIContentVC.fiveYearsPeriodAction), forControlEvents: .TouchUpInside)
        }
        
        
        return button
        
    }
    
    
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

