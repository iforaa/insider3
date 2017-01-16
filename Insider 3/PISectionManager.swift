//
//  PIStockHandler.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 06.11.15.
//  Copyright © 2015 PKMR. All rights reserved.
//

import Foundation



class PISectionManager {
    
    var allTickers: [TickerModel] = []
    var tickers: [TickerModel] = []
    var fetchedTicker: TickerModel?
    var searchFilterText: String?
    var withSettings = true
    var selectedTickerNum:Int!
    var fetchedItems = []
    
    
    
    func getManager(ticker: TickerModel) -> PISectionManager {
        return self
    }
    
    func requestInBackground(settings: PISettings, completion: (success: Bool) -> Void) {
        self.tickers = []
//        PIContainer.sharedInstance.tickers = []
        let dates = (settings.dateFrom(settings.datePeriod),settings.dateTill())
        PIDataManager().requestSection(settings.section, date_from: dates.0, date_till:dates.1, completion: { (result) -> Void in
            
//            PIContainer.sharedInstance.tickers = result
            self.allTickers = result
            self.tickers = PISettings().applyExcludeListAtTickers(result)

            self.filter(settings)
            self.sort(settings)

            completion(success: true)
            
        })
    }
    
    func fetchInBackground(settings:PISettings,ticker: TickerModel,complition: (changeRel:Float) -> Void) {

        PIDataManager().fetchTicker(ticker.section, dateFrom: settings.dateFrom(settings.datePeriod), dateTill: settings.dateTill(), ticker: ticker.Key) { (fetchedItems) -> Void in
            self.fetchedTicker = fetchedItems
            complition(changeRel:(self.fetchedTicker?.Change)!)
        }
    }
    
    func excludeControl() {
        self.tickers = self.tickers.filter({item in !PIContainer.sharedInstance.excludedTickers.contains(item.ID)})
    }
    
    
    func searchFilter(searchText: String) {
        
        self.tickers = self.tickers.filter({item in
            if searchText.characters.count == 0 {
                return true
            } else {
                return item.Title.lowercaseString.containsString(searchText.lowercaseString)
            }
        })
        
    }
    
    func filter(_: PISettings) {
        return
    }
    
    func sort(settings: PISettings) {
        switch (settings.selectedSort) {

        case .ChangeUp:
            
            self.tickers.sortInPlace {(stock1: TickerModel, stock2: TickerModel) -> Bool in
                stock1.Change > stock2.Change
                
            }
            
        case .ChangeDown:
            self.tickers.sortInPlace {(stock1: TickerModel, stock2: TickerModel) -> Bool in
                stock1.Change < stock2.Change
                
            }
            
        case .CapUp:
            
            self.tickers.sortInPlace {(ticker1:TickerModel, ticker2: TickerModel) -> Bool in
                (ticker1 as! StockTickerModel).Capitalisation > (ticker2 as! StockTickerModel).Capitalisation
            }
        case .CapDown:
            self.tickers.sortInPlace {(ticker1: TickerModel, ticker2: TickerModel) -> Bool in
                (ticker1 as! StockTickerModel).Capitalisation < (ticker2 as! StockTickerModel).Capitalisation
            }
        }
    }
    
    func count() -> Int {
        if withSettings {
            
            if let sft = self.searchFilterText {
                self.tickers = self.allTickers.filter({item in
                    return item.Title.lowercaseString.containsString(sft.lowercaseString)
                })
            }
            return self.tickers.count
        } else {
            if let sft = self.searchFilterText {
                self.tickers = self.allTickers.filter({item in
                    return item.Title.lowercaseString.containsString(sft.lowercaseString)
                })
            }
            return self.tickers.count
        }
    }
    
    func fetchedTickerItemsCount() -> Int {
        return self.fetchedTicker!.Items.count
    }
    
    func switchVisibilityForAll(addAll:Bool) {

        
    }
    
    func switchVisibility(row: Int) {
        var ticker = self.allTickers[row]
        if PISettings().containsInExlideList(ticker.ID) {
            PISettings().removeItemFromExludeList(ticker.ID)
        } else {
            PISettings().addItemToExludeList(ticker.ID)
        }
    }

    func ticker(row:Int) -> String {
        return self.tickers[row].Title
    }
    
    func currentRate(row:Int) -> Float {
        return self.tickers[row].CurrentRate
    }
    
    func change(row:Int, _: PISettings = PISettings()) -> Float {
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
    
    
    override func requestInBackground(settings: PISettings, completion: (success: Bool) -> Void) {
        
        self.tickers = []
        
        let dt = PISettings().dashboardTickers()
        
        if dt.count != 0 {
            for ticker in dt {
                
                self.fetchInBackground(settings, ticker, complition: { (fetchedTicker) -> Void in
                    self.tickers.append(fetchedTicker)
                    completion(success: true)
                })
            }
        } else {
            completion(success: false)
        }
    }
    
    func fetchInBackground(settings: PISettings, _ ticker: TickerModel, complition: (ticker:TickerModel) -> Void) {
        
        var dateFrom:NSString,dateTill:NSString

        dateFrom = settings.dateFrom(settings.datePeriod)
        dateTill = settings.dateTill()
        
        let dataManager = PIDataManager()
        
        dataManager.fetchTicker(ticker.section, dateFrom: dateFrom, dateTill: dateTill, ticker: ticker.Key) { (fetchedItems) -> Void in
            complition(ticker: fetchedItems)
        }
    }
    
    // excludeControl must not be called in dashboard, to avoid to fill it by tickers
    override func excludeControl() {}
}

class PIStocksManager:PISectionManager {
    
    
    
    override func filter(settings: PISettings) {
        let stockSettings = settings as! PIStockSettings
        
        self.tickers = self.allTickers
        
        if stockSettings.specialisation == .All {
            self.tickers = self.allTickers
        } else {
            self.tickers = self.tickers.filter({item in ((item as! StockTickerModel).Specialisation) == stockSettings.specialisation})
        }
        
        
        // этот фильтр должен быть перенесен на бэкэнд
        self.tickers = self.tickers.filter { (item) -> Bool in
            !item.Title.lowercaseString.containsString("пиф")
        }
    }
}

class PICurrenciesManager: PISectionManager {
}

class PIRealEstatesManager: PISectionManager {
}

class PIBondsManager:PISectionManager {
    private var Item:BondItemModel {
        get {
            return self.tickers[self.selectedTickerNum!].Items.first as! BondItemModel
        }
    }
    
    var maturityDate:String {return self.Item.MaturityDate!}
    var yield:String {return String(self.Item.Yield!)}
    var dayValue:String {return String(self.Item.DayValue!)}
    var coupon:String {return self.Item.coupon!}
    
    override func filter(settings: PISettings) {
        
        let bondSettings = settings as! PIBondSettings
        
        self.tickers = self.allTickers
        
        self.tickers = self.tickers.filter({item in
            if bondSettings.otrasl != .All {
                return ((item as! BondTickerModel).Otrasl) == bondSettings.otrasl
            }
            return true
        }).filter({item in
            if bondSettings.sektor != .All {
                return ((item as! BondTickerModel).Sektor) == bondSettings.sektor
            }
            return true
        }).filter({item in
            if bondSettings.rating != .All {
                return ((item as! BondTickerModel).Rating) == bondSettings.rating
            }
            return true
        }).filter({item in
            if bondSettings.period != .All {
                return ((item as! BondTickerModel).Period) == bondSettings.period
            }
            return true
        }).filter({item in
            if bondSettings.amortizac != .All {
                return ((item as! BondTickerModel).Amortizac) == bondSettings.amortizac
            }
            return true
        }).filter({item in
            if bondSettings.vidkupona != .All {
                return ((item as! BondTickerModel).Vidkupona) == bondSettings.vidkupona
            }
            return true
        })
    }
    
}

class PIIndicesManager: PISectionManager { // combine WorldIndices with RusIndices
    
    override func requestInBackground(settings: PISettings, completion: (success: Bool) -> Void) {
        
        let dates = (settings.dateFrom(settings.datePeriod),settings.dateTill())
        PIDataManager().requestSection(.WorldIndicesSection, date_from: dates.0, date_till:dates.1, completion: { (resultWorldIndices) -> Void in
            
            self.allTickers = resultWorldIndices
            self.tickers = resultWorldIndices
            
            PIDataManager().requestSection(.RusIndicesSection, date_from: dates.0, date_till:dates.1, completion: { (resultRusIndices) -> Void in
                
                self.allTickers.appendContentsOf(resultRusIndices)
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
    
    var Fundname: String {return self.Item.Fundname!}
    var Ukname: String {return self.Item.Ukname!}
    var Fundtype: String {return (self.Item.Fundtype?.description)!}
    var Fundcat: String {return (self.Item.Fundcat?.description)!}
    var Registrationdate: String {return self.Item.Registrationdate!}
    var Startformirdate: String {return self.Item.Startformirdate!}
    var Endformirdate: String {return self.Item.Endformirdate!}
    var Minsumminvest:String {return String(self.Item.Minsumminvest!)}
    var Stpaya:String {return String(self.Item.Stpaya!)}
    var Scha:String {return String(self.Item.Scha!)}
    var URL:String {return String(self.Item.url!)}

    override func requestInBackground(settings: PISettings, completion: (success: Bool) -> Void) {
        if self.tickers.count == 0 {
            
            self.tickers = []
            self.allTickers = []
            let dates = (settings.dateFrom(.OneMonth),settings.dateTill())
            PIDataManager().requestSection(settings.section, date_from: dates.0, date_till:dates.1, completion: { (result) -> Void in
                
                self.allTickers = result
                self.tickers = PISettings().applyExcludeListAtTickers(result)
                
                self.filter(settings)
                self.sort(settings)
                
                completion(success: true)
                
            })
        } else {
            completion(success: true)
        }
    }

    override func change(row: Int, _ settings: PISettings) -> Float {
        if self.tickers[row].Items.first is MutualFundItemModel {
            let item = self.tickers[row].Items.first as! MutualFundItemModel
            switch settings.datePeriod {
                case .OneDay: self.tickers[row].Change = item.Proc_day!
                case .OneWeek: self.tickers[row].Change = item.Proc_week!
                case .OneMonth: self.tickers[row].Change = item.Proc_month1!
                case .OneYear: self.tickers[row].Change = item.Proc_year1!
                case .ThreeYears: self.tickers[row].Change = item.Proc_year3!
                case .FiveYears: self.tickers[row].Change = item.Proc_year5!
            }
        }
        
        return self.tickers[row].Change
    }
    
    override func filter(settings: PISettings) {
        
        let mutualFundSettings = settings as! PIMutualFundSettings
        self.tickers = self.allTickers
        
        self.tickers = self.tickers.filter({item in
            if mutualFundSettings.fundType != .All {
                return ((item as! MutualFundTickerModel).Fundtype) == mutualFundSettings.fundType
            }
            return true
        }).filter({item in
            if mutualFundSettings.fundCat != .All {
                return ((item as! MutualFundTickerModel).Fundcat) == mutualFundSettings.fundCat
            }
            return true
        })
    }

    

}