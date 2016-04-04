//
//  PIContentVC.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 05.11.15.
//  Copyright © 2015 PKMR. All rights reserved.
//

import UIKit
import SnapKit


class PIContentVC: UIViewController, PIDatesAndSortsViewDelegate {
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    
    var ticker: TickerModel!
    
    var manager:PISectionManager = PISectionManager()
    var settings:PISettings = PISettings()
    var pigraph:PIGraph = PIGraph()
    var changeLabels: (UILabel,UILabel)!
    
    
    func request() {
        self.manager.fetchInBackground(self.settings,ticker: self.ticker) { (changeRel) -> Void in
            
            self.pigraph.setDataCount(self.manager)
            self.changeLabels.1.text = "\(self.manager.fetchedChange())%"
        }
    }
    func openPopover(sourceView: UIView, type: PopoverType) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Details"
        
   
        if PISettingsManager.sharedInstance.dashboard.containsInDashboard(self.ticker) {
            self.navigationItem.rightBarButtonItem?.title = "Remove"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "To Dashboard"
        }

        self.view.addSubview(pigraph.contentView)
        
        let datesAndSorts:PIDatesAndSortsView = PIDatesAndSortsView(settings: self.settings, false)
        datesAndSorts.delegate = self
        self.view.addSubview(datesAndSorts)
        datesAndSorts.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(65)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(pigraph.contentView.snp_top)
        }
        
        
    
        let rateLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.rateLabel,value: "\(self.manager.currentRate(self.manager.selectedTickerNum))")
        
        self.view.addSubview(rateLabels.0)
        self.view.addSubview(rateLabels.1)

        changeLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.changeLabel,value: "\(self.manager.change(self.manager.selectedTickerNum))%")
        
        self.view.addSubview(changeLabels.0)
        self.view.addSubview(changeLabels.1)


        switch self.ticker.section {
            
            
        case .mutualFundsSection:
            
            rateLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view).offset(60)
                make.leading.equalTo(self.view).offset(10)
            }
            
            rateLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view).offset(60)
                make.leading.equalTo(rateLabels.0.snp_trailing).offset(10)
            }
            
            changeLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(rateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            changeLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(rateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(changeLabels.0.snp_trailing).offset(10)
            }
            
            
            
            let mutualFundsManager = PIMutualFundsManager()
            mutualFundsManager.tickers = self.manager.tickers
            mutualFundsManager.fetchedTicker = self.manager.fetchedTicker
            mutualFundsManager.settings = self.manager.settings
            mutualFundsManager.selectedTickerNum = self.manager.selectedTickerNum
            
            
            let fundnameLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.fundname,value: mutualFundsManager.Fundname)
            
            self.view.addSubview(fundnameLabels.0)
            self.view.addSubview(fundnameLabels.1)
            
            let uknameLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.ukname,value: mutualFundsManager.Ukname)
            
            self.view.addSubview(uknameLabels.0)
            self.view.addSubview(uknameLabels.1)
            
            let fundtypeLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.fundtype,value: mutualFundsManager.Fundtype)
            
            self.view.addSubview(fundtypeLabels.0)
            self.view.addSubview(fundtypeLabels.1)
            
            let fundcatLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.fundcat,value: mutualFundsManager.Fundcat)
            
            self.view.addSubview(fundcatLabels.0)
            self.view.addSubview(fundcatLabels.1)
            
            let registrationdateLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.registrationdate,value: mutualFundsManager.Registrationdate)
            
            self.view.addSubview(registrationdateLabels.0)
            self.view.addSubview(registrationdateLabels.1)
            
            let startformirdateLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.startformirdate,value: mutualFundsManager.Startformirdate)
            
            self.view.addSubview(startformirdateLabels.0)
            self.view.addSubview(startformirdateLabels.1)
            
            let endformirdateLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.endformirdate,value: mutualFundsManager.Endformirdate)
            
            self.view.addSubview(endformirdateLabels.0)
            self.view.addSubview(endformirdateLabels.1)
            
            let minsuminvestLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.minsumminvest,value: mutualFundsManager.Minsumminvest)
            
            self.view.addSubview(minsuminvestLabels.0)
            self.view.addSubview(minsuminvestLabels.1)
            
            let stpayaLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.stpaya,value: mutualFundsManager.Stpaya)
            
            self.view.addSubview(stpayaLabels.0)
            self.view.addSubview(stpayaLabels.1)
            
            let schaLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.scha,value: mutualFundsManager.Scha)
            
            self.view.addSubview(schaLabels.0)
            self.view.addSubview(schaLabels.1)
            
            let urlLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.url, value: mutualFundsManager.URL)
            let linkTextView = UITextView()
            linkTextView.dataDetectorTypes = .Link
            linkTextView.editable = false
            linkTextView.text = urlLabels.1.text
            
            
            self.view.addSubview(urlLabels.0)
            self.view.addSubview(linkTextView)
            
            
            fundnameLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(changeLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            fundnameLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(changeLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(fundnameLabels.0.snp_trailing).offset(10)
            }
            
            
            uknameLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(fundnameLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            uknameLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(uknameLabels.0)
                make.leading.equalTo(uknameLabels.0.snp_trailing).offset(10)
            }
            
            fundtypeLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(uknameLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            fundtypeLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(fundtypeLabels.0)
                make.leading.equalTo(fundtypeLabels.0.snp_trailing).offset(10)
            }

            
            fundcatLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(fundtypeLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            fundcatLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(fundcatLabels.0)
                make.leading.equalTo(fundcatLabels.0.snp_trailing).offset(10)
            }

            
            registrationdateLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(fundcatLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            registrationdateLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(registrationdateLabels.0)
                make.leading.equalTo(registrationdateLabels.0.snp_trailing).offset(10)
            }
            
            startformirdateLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(registrationdateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            startformirdateLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(startformirdateLabels.0)
                make.leading.equalTo(startformirdateLabels.0.snp_trailing).offset(10)
            }

            endformirdateLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(startformirdateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            endformirdateLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(endformirdateLabels.0)
                make.leading.equalTo(endformirdateLabels.0.snp_trailing).offset(10)
            }
            
            minsuminvestLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(endformirdateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            minsuminvestLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(minsuminvestLabels.0)
                make.leading.equalTo(minsuminvestLabels.0.snp_trailing).offset(10)
            }
            
            stpayaLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(minsuminvestLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            stpayaLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(stpayaLabels.0)
                make.leading.equalTo(stpayaLabels.0.snp_trailing).offset(10)
            }
            
            schaLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(stpayaLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            schaLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(schaLabels.0)
                make.leading.equalTo(schaLabels.0.snp_trailing).offset(10)
            }
            
            urlLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(schaLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            linkTextView.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(urlLabels.0)
                make.left.equalTo(urlLabels.0.snp_right).offset(10)
                make.width.equalTo(200)
                make.height.equalTo(40)
            }


            
        case .bondsSection:

            rateLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view).offset(60)
                make.leading.equalTo(self.view).offset(10)
            }
            
            rateLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view).offset(60)
                make.leading.equalTo(rateLabels.0.snp_trailing).offset(10)
            }
            
            changeLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(rateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            changeLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(rateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(changeLabels.0.snp_trailing).offset(10)
            }

            
            let bondManager = PIBondsManager()
            bondManager.tickers = self.manager.tickers
            bondManager.fetchedTicker = self.manager.fetchedTicker
            bondManager.settings = self.manager.settings
            bondManager.selectedTickerNum = self.manager.selectedTickerNum

            
            let emitentLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.emitentLabel,value:"emitent not found")
            
            self.view.addSubview(emitentLabels.0)
            self.view.addSubview(emitentLabels.1)
            
            let maturityDateLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.maturityDateLabel,value:bondManager.maturityDate)
            
            self.view.addSubview(maturityDateLabels.0)
            self.view.addSubview(maturityDateLabels.1)
            
            let yieldLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.yieldLabel,value: bondManager.yield)
            
            self.view.addSubview(yieldLabels.0)
            self.view.addSubview(yieldLabels.1)
            
            let dayValueLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.dayValueLabel,value: bondManager.dayValue)
            
            self.view.addSubview(dayValueLabels.0)
            self.view.addSubview(dayValueLabels.1)
            
            let couponLabels = PIControlViewFactory.NewLabelsWithTextAndValue(.couponLabel,value:bondManager.coupon)
            
            self.view.addSubview(couponLabels.0)
            self.view.addSubview(couponLabels.1)
            
            emitentLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(changeLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            emitentLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(changeLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(emitentLabels.0.snp_trailing).offset(10)
            }
            
            maturityDateLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(emitentLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            maturityDateLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(emitentLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(maturityDateLabels.0.snp_trailing).offset(10)
            }
            
            yieldLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(maturityDateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            yieldLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(maturityDateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(yieldLabels.0.snp_trailing).offset(10)
            }
            
            dayValueLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(yieldLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            dayValueLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(yieldLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(dayValueLabels.0.snp_trailing).offset(10)
            }
            
            couponLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(dayValueLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            couponLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(dayValueLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(couponLabels.0.snp_trailing).offset(10)
            }
            
            
        default:
            
            pigraph.contentView.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view).offset(110)
                make.leading.equalTo(self.view).offset(10)
                make.trailing.equalTo(self.view).offset(-20)
                make.bottom.equalTo(self.view).offset(-120)
                
            }
            
            
            rateLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(pigraph.contentView.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            rateLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(pigraph.contentView.snp_bottom).offset(10)
                make.leading.equalTo(rateLabels.0.snp_trailing).offset(10)
            }
            
            changeLabels.0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(rateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(self.view).offset(10)
            }
            
            changeLabels.1.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(rateLabels.0.snp_bottom).offset(10)
                make.leading.equalTo(changeLabels.0.snp_trailing).offset(10)
            }


        }
        
        
        self.request()
        
        

    }
    
    override func viewDidAppear(animated: Bool) {
       
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func makeRequest () {
        self.manager.fetchInBackground(self.settings,ticker: self.ticker) { (changeRel) -> Void in
            
            self.pigraph.setDataCount(self.manager)
            self.changeLabels.1.text = "\(self.manager.fetchedChange())%"
        }
    }
    
    func periodAction(period: Periods) {
        settings.datePeriod = period
        makeRequest()
    }
    
    func oneDayPeriodAction() {
        settings.datePeriod = .oneDay
        makeRequest()
    }
    
    func oneWeekPeriodAction() {
        settings.datePeriod = .oneWeek
        makeRequest()
    }
    
    func oneMonthPeriodAction() {
        settings.datePeriod = .oneMonth
        makeRequest()
    }
    
    func oneYearPeriodAction() {
        settings.datePeriod = .oneYear
        makeRequest()
    }
    
    func threeYearsPeriodAction() {
        settings.datePeriod = .threeYears
        makeRequest()
    }
    
    func fiveYearsPeriodAction() {
        settings.datePeriod = .fiveYears
        makeRequest()
    }
    */
    
    @IBAction func selectTapped(sender: UIBarButtonItem) {
        if PISettingsManager.sharedInstance.dashboard.containsInDashboard(self.ticker) {
            PISettingsManager.sharedInstance.dashboard.removeFromDashboard(self.ticker)
            self.navigationItem.rightBarButtonItem?.title = "To Dashboard"
        } else {
            
            PISettingsManager.sharedInstance.dashboard.addToDashboard(self.ticker)
            self.navigationItem.rightBarButtonItem?.title = "Remove"
        }

    }
    
    
}



