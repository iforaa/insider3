//
//  PIStockHandler.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 06.11.15.
//  Copyright © 2015 PKMR. All rights reserved.
//

import Foundation



class PISectionManager {
    var section:Section = .stocksSection

    var tickers: [TickerModel] = []
    var fetchedTicker: TickerModel?
    var settings: PISettings!
    
    
    init() {

    }
    
    var withSettings = true
    var selectedTickerNum:Int!
    var fetchedItems = []
    
    func getManager(ticker: TickerModel) -> PISectionManager {
        return self
    }
    
    func requestInBackground(completion: (success: Bool) -> Void) {
        
        let dates = (settings.dateFrom(),settings.dateTill())
        PIDataManager().requestSection(self.section, date_from: dates.0, date_till:dates.1, completion: { (result) -> Void in
            
            PISettingsManager.sharedInstance.settings.tickers = result
            self.tickers = PISettingsManager.sharedInstance.settings.applyExcludeListAtTickers(result)

            self.filter()
            self.sort()

            completion(success: true)
            
        })
    }
    
    func fetchInBackground(settings:PISettings,ticker: TickerModel,complition: (changeRel:Float) -> Void) {

        PIDataManager().fetchTicker(ticker.section, dateFrom: settings.dateFrom(), dateTill: settings.dateTill(), ticker: ticker.Key) { (fetchedItems) -> Void in
            self.fetchedTicker = fetchedItems
            complition(changeRel:(self.fetchedTicker?.Change)!)
        }
    }
    
    func excludeControl() {
        
        self.tickers = self.tickers.filter({item in !PISettingsManager.sharedInstance.settings.excludedTickers.contains(item.Title)})
    }
    
    func filter() {
        return
    }
    
    func sort() {
        switch (settings.selectedSort) {

        case .changeUp:
            
            self.tickers.sortInPlace {(stock1: TickerModel, stock2: TickerModel) -> Bool in
                stock1.Change > stock2.Change
                
            }
            
        case .changeDown:
            self.tickers.sortInPlace {(stock1: TickerModel, stock2: TickerModel) -> Bool in
                stock1.Change < stock2.Change
                
            }
            
        case .capUp:
            
            self.tickers.sortInPlace {(ticker1:TickerModel, ticker2: TickerModel) -> Bool in
                (ticker1 as! StockTickerModel).Capitalisation < (ticker2 as! StockTickerModel).Capitalisation
            }
        case .capDown:
            self.tickers.sortInPlace {(ticker1: TickerModel, ticker2: TickerModel) -> Bool in
                (ticker2 as! StockTickerModel).Capitalisation > (ticker2 as! StockTickerModel).Capitalisation
            }
            
        default: print("something wrong on sort")
        }
        

    }
    
    func count() -> Int {
        if withSettings {
            return self.tickers.count
        } else {
            self.tickers = PISettingsManager.sharedInstance.settings.tickers
            return self.tickers.count
        }
    }
    
    func fetchedTickerItemsCount() -> Int {
        return self.fetchedTicker!.Items.count
    }
    
    func inExludeList(ticker: TickerModel) -> Bool {
        
        return PISettingsManager.sharedInstance.settings.containsInExlideList(ticker.Title)
    }
    
    func switchVisibilityForAll(addAll:Bool) {
        for ticker:TickerModel in self.tickers {
            if addAll {
                if !inExludeList(ticker) {
                    PISettingsManager.sharedInstance.settings.addItemToExludeList(ticker.Title)
                }
            } else {
                if inExludeList(ticker) {
                    PISettingsManager.sharedInstance.settings.removeItemFromExludeList(ticker.Title)
                }
            }
        }
    }
    
    func switchVisibility(ticker: TickerModel) {
        if ticker.Title.characters.count == 0 {
            return
        }
            
        if inExludeList(ticker) {
            PISettingsManager.sharedInstance.settings.removeItemFromExludeList(ticker.Title)
        } else {
            PISettingsManager.sharedInstance.settings.addItemToExludeList(ticker.Title)
        }
    }

    func ticker(row:Int) -> String {
        return self.tickers[row].Title
    }
    
    func currentRate(row:Int) -> Float {
        return self.tickers[row].CurrentRate
    }
    
    func change(row:Int) -> Float {
        return self.tickers[row].Change
    }
    
    func getSelectedTicker() -> TickerModel {
        return self.tickers[self.selectedTickerNum]
    }
    
    func getTicker(row: Int) -> TickerModel {
        return self.tickers[row]
    }
    
    func fetchedChange() -> Float {
        return self.fetchedTicker!.Change
    }
    
    func fetchedRate(row: Int) -> Float {
        return self.fetchedTicker!.Items[row].Rate
    }
    
    func fetchedDate(row: Int) -> NSDate {
        return self.fetchedTicker!.Items[row].Date
    }
    
    func fetchedTitle() -> String {
        return self.fetchedTicker!.Title
    }

}


class PIDashboardManager:PISectionManager {
    
    override func requestInBackground(completion: (success: Bool) -> Void) {
        
        self.tickers = []
        
        let dt = PISettingsManager.sharedInstance.dashboard.dashboardTickers()
        
        if dt.count != 0 {
            for ticker in dt {
                
                self.fetchInBackground(ticker, complition: { (fetchedTicker) -> Void in
                    self.tickers.append(fetchedTicker)
                    completion(success: true)
                })
            }
        } else {
            completion(success: false)
        }
    }
    
    func fetchInBackground(ticker: TickerModel,complition: (ticker:TickerModel) -> Void) {
        
        var dateFrom:NSString,dateTill:NSString

        dateFrom = PISettingsManager.sharedInstance.dashboard.dateFrom()
        dateTill = PISettingsManager.sharedInstance.dashboard.dateTill()
        
        let dataManager = PIDataManager()
        
        dataManager.fetchTicker(ticker.section, dateFrom: dateFrom, dateTill: dateTill, ticker: ticker.Key) { (fetchedItems) -> Void in
            complition(ticker: fetchedItems)
        }
    }
}

class PIStocksManager:PISectionManager {

    override func filter() {
        self.tickers = PISettingsManager.sharedInstance.settings.tickers
        
        if PISettingsManager.sharedInstance.stock.specialisation == .all {
            self.tickers = PISettingsManager.sharedInstance.settings.tickers
        } else {
            self.tickers = self.tickers.filter({item in ((item as! StockTickerModel).Specialisation) == PISettingsManager.sharedInstance.stock.specialisation})
        }
    }
    
}

class PICurrenciesManager: PISectionManager {}

class PIRealEstatesManager:PISectionManager {}

class PIBondsManager:PISectionManager {
    private var Item:BondItemModel {
        get {
            return self.tickers[self.selectedTickerNum!].Items.first as! BondItemModel
        }
    }
    var maturityDate:String {get{return self.Item.MaturityDate!}}
    var yield:String {get{return String(self.Item.Yield!)}}
    var dayValue:String {get{return String(self.Item.DayValue!)}}
    var coupon:String {get{return self.Item.coupon!}}
    
    override func filter() {
        self.tickers = PISettingsManager.sharedInstance.settings.tickers

        self.tickers = self.tickers.filter({item in
            if PISettingsManager.sharedInstance.bond.otrasl != .all {
                return ((item as! BondTickerModel).Otrasl) == PISettingsManager.sharedInstance.bond.otrasl
            }
            return true
        }).filter({item in
            if PISettingsManager.sharedInstance.bond.sektor != .all {
                return ((item as! BondTickerModel).Sektor) == PISettingsManager.sharedInstance.bond.sektor
            }
            return true
        }).filter({item in
            if PISettingsManager.sharedInstance.bond.rating != .all {
                return ((item as! BondTickerModel).Rating) == PISettingsManager.sharedInstance.bond.rating
            }
            return true
        }).filter({item in
            if PISettingsManager.sharedInstance.bond.period != .all {
                return ((item as! BondTickerModel).Period) == PISettingsManager.sharedInstance.bond.period
            }
            return true
        }).filter({item in
            if PISettingsManager.sharedInstance.bond.amorticac != .all {
                return ((item as! BondTickerModel).Amorticac) == PISettingsManager.sharedInstance.bond.amorticac
            }
            return true
        }).filter({item in
            if PISettingsManager.sharedInstance.bond.vidkupona != .all {
                return ((item as! BondTickerModel).Vidkupona) == PISettingsManager.sharedInstance.bond.vidkupona
            }
            return true
        })
    }
    
}

class PIIndicesManager: PISectionManager { // Соединяем мировые и российские индексы
    override func requestInBackground(completion: (success: Bool) -> Void) {
        
        let dates = (settings.dateFrom(),settings.dateTill())
        PIDataManager().requestSection(.worldIndicesSection, date_from: dates.0, date_till:dates.1, completion: { (resultWorldIndices) -> Void in
            
            PISettingsManager.sharedInstance.settings.tickers = resultWorldIndices
            self.tickers = resultWorldIndices
            
            PIDataManager().requestSection(.rusIndicesSection, date_from: dates.0, date_till:dates.1, completion: { (resultRusIndices) -> Void in
                
                PISettingsManager.sharedInstance.settings.tickers.appendContentsOf(resultRusIndices)
                self.tickers.appendContentsOf(resultRusIndices)
                completion(success: true)
            })
        })
    }
}

class PIMutualFundsManager:PISectionManager {
    private var Item:MutualFundItemModel {
        get {
            return self.tickers[self.selectedTickerNum!].Items.first as! MutualFundItemModel
        }
    }
    
    var Fundname: String {get {return self.Item.Fundname!}}
    var Ukname: String {get {return self.Item.Ukname!}}
    var Fundtype: String {get {return self.Item.Fundtype!}}
    var Fundcat: String {get {return self.Item.Fundcat!}}
    var Registrationdate: String {get {return self.Item.Registrationdate!}}
    var Startformirdate: String {get {return self.Item.Startformirdate!}}
    var Endformirdate: String {get {return self.Item.Endformirdate!}}
    var Minsumminvest:String {get {return String(self.Item.Minsumminvest!)}}
    var Stpaya:String {get {return String(self.Item.Stpaya!)}}
    var Scha:String {get {return String(self.Item.Scha!)}}

    override func requestInBackground(completion: (success: Bool) -> Void) {
        if self.tickers.count == 0 {
            super.requestInBackground({ (success) -> Void in
                completion(success: success)
            })
        } else {
            completion(success: true)
        }
    }
    
    override func change(row: Int) -> Float {
        let item = self.tickers[row].Items.first as! MutualFundItemModel
        switch self.settings.datePeriod {
        case .oneDay: self.tickers[row].Change = item.Proc_day!
        case .oneWeek: self.tickers[row].Change = item.Proc_week!
        case .oneMonth: self.tickers[row].Change = item.Proc_month1!
        case .oneYear: self.tickers[row].Change = item.Proc_year1!
        case .threeYears: self.tickers[row].Change = item.Proc_year3!
        case .fiveYears: self.tickers[row].Change = item.Proc_year5!
//        default: return 0.0
        }
        
        return self.tickers[row].Change
        
    }

}