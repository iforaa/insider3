//
//  PIScrollView.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 21.08.15.
//  Copyright (c) 2015 PKMR. All rights reserved.
//

import UIKit
import SnapKit
import ActionKit


protocol PIPopoverSortDelegate {
    func makeSort()
}

protocol PIPopoverFilterDelegate {
    func makeFilter()
}

protocol PIDatesAndSortsViewDelegate {
    func request()
    func openPopover(sourceView: UIView, type: PopoverType)
}

class PopoverSortVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "TextCell"
    var delegate: PIPopoverSortDelegate! = nil
    var settings: PISettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(180, 180)
        
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.sorts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.settings.sorts[indexPath.row].description

        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        settings.selectedSort = settings!.sorts[indexPath.row]
        self.delegate.makeSort()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


class PopoverFilterVC: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var pickerView: UIPickerView!
    var delegate:PIPopoverFilterDelegate! = nil
    var settings:PISettings?
    let textCellIdentifier = "TextCell"
    var tableView:UITableView?
    var showPicker: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(270, 150)
        
        if showPicker == true || self.settings?.filters.count == 1 { //в случае если фильтр в секции всего один, то сразу показываем пикер
            
            self.pickerView = UIPickerView()
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
            self.pickerView.backgroundColor = UIColor.blackColor()
            
            let selectedSpec = self.settings?.selectedFilterRow()
            
            if let selectedSpecUnwrap = selectedSpec {
                self.pickerView.selectRow(selectedSpecUnwrap, inComponent: 0, animated: true)
            }

            self.view.addSubview(self.pickerView)
            
            self.pickerView.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(self.view)
            }
            
            let button = UIButton()
            button.setTitle("Close", forState: UIControlState.Normal)
            button.addControlEvent(.TouchUpInside, closure: {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
            self.view.addSubview(button)
            
            button.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(self.view).offset(20)
                make.top.equalTo(self.view).offset(20)
            }
            
        } else {
            self.tableView = UITableView()
            self.tableView!.delegate = self
            self.tableView?.dataSource = self
            self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: textCellIdentifier)
            self.view.addSubview(self.tableView!)
            self.tableView!.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(self.view)
            }
            
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.settings?.filters.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.settings?.filters[indexPath.row].description//self.settings.sorts[indexPath.row].description

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.settings!.selectedFilter = (self.settings?.filters[indexPath.row])!
        let popoverViewController:PopoverFilterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopoverVCFilter") as! PopoverFilterVC
        popoverViewController.showPicker = true
        popoverViewController.settings = self.settings
        popoverViewController.delegate = self.delegate
        
        presentViewController(popoverViewController, animated: true, completion: {

        })
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = self.settings?.descriptionFilterRow(row)
        return NSAttributedString(string: string!, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func numberOfComponentsInPickerView(colorPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.settings?.countFilterRows())!
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.settings?.selectFilterRow(row)
        self.delegate.makeFilter()   
    }
}

class PIDatesAndSortsView: UIView {
    var sectionManager:PISectionManager!

    var delegate:PIDatesAndSortsViewDelegate! = nil
    let periodsScreen = UIView()

    let sortsbutton = UIButton()
    let filtersbutton = UIButton()
    let fontSize:CGFloat = 14.0
    
    init(frame: CGRect, sectionManager: PISectionManager) {
        super.init(frame: frame)
        
        self.sectionManager = sectionManager
        
        periodsScreen.backgroundColor = UIColor.redColor()
        self.addSubview(periodsScreen)
        periodsScreen.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(self)
        }
        
        let oneDayPer = self.dateButton("1d", period: .oneDay)
        periodsScreen.addSubview(oneDayPer)
        
        oneDayPer.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(periodsScreen).offset(4)
            make.top.equalTo(periodsScreen).offset(5)
        }
        
        let oneWeekPer = self.dateButton("1w", period: .oneWeek)
        periodsScreen.addSubview(oneWeekPer)
        
        oneWeekPer.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(oneDayPer.snp_right).offset(4)
            make.top.equalTo(periodsScreen).offset(5)
        }
        
        let oneMonthPer = self.dateButton("1m", period: .oneMonth)
        periodsScreen.addSubview(oneMonthPer)
        
        oneMonthPer.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(oneWeekPer.snp_right).offset(4)
            make.top.equalTo(periodsScreen).offset(5)
        }
        
        let oneYearPer = self.dateButton("1y", period: .oneYear)
        periodsScreen.addSubview(oneYearPer)
        
        oneYearPer.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(oneMonthPer.snp_right).offset(4)
            make.top.equalTo(periodsScreen).offset(5)
        }
        
        let threeYearsPer = self.dateButton("3y", period: .threeYears)
        periodsScreen.addSubview(threeYearsPer)
        
        threeYearsPer.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(oneYearPer.snp_right).offset(4)
            make.top.equalTo(periodsScreen).offset(5)
        }
        
        let fiveYearsPer = self.dateButton("5y", period: .fiveYears)
        periodsScreen.addSubview(fiveYearsPer)
        
        fiveYearsPer.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(threeYearsPer.snp_right).offset(4)
            make.top.equalTo(periodsScreen).offset(5)
        }


        self.sortsbutton.setTitle("Sort", forState: UIControlState.Normal)
        self.sortsbutton.addControlEvent(.TouchUpInside, closure: {
            self.delegate.openPopover(self.sortsbutton, type: .sort)
        })
        self.sortsbutton.titleLabel?.font = UIFont.systemFontOfSize(fontSize + 2)
        periodsScreen.addSubview(self.sortsbutton)
        
        
        self.sortsbutton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(fiveYearsPer.snp_right).offset(6)
            make.top.equalTo(periodsScreen).offset(5)
        }
        
        
        if self.sectionManager.settings.filters.count > 0 {
            self.filtersbutton.setTitle("Filter", forState: UIControlState.Normal)
            self.filtersbutton.addControlEvent(.TouchUpInside, closure: {
                self.delegate.openPopover(self.filtersbutton, type: .filter)
            })
            self.filtersbutton.addTarget(self, action: Selector("filtersPopoverOpen"), forControlEvents: .TouchUpInside)
            self.filtersbutton.titleLabel?.font = UIFont.systemFontOfSize(fontSize + 2)
            periodsScreen.addSubview(self.filtersbutton)
            
            
            self.filtersbutton.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(self.sortsbutton.snp_right).offset(6)
                make.top.equalTo(periodsScreen).offset(5)
            }
        }
    }
    
    func dateButton(title: String, period: Periods) -> UIButton {
        let button = UIButton()
        button.setTitle(title, forState: UIControlState.Normal)
        button.addControlEvent(.TouchUpInside, closure: {
            self.sectionManager.settings.datePeriod = period
            print(self.sectionManager.settings.datePeriod)
            self.delegate.request()
        })
        button.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        return button
    }


    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}