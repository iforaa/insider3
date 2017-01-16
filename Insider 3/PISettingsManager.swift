//
//  PISettings.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 04.08.15.
//  Copyright (c) 2015 PKMR. All rights reserved.
//

import Foundation



class PIContainer {
//    var tickers: [TickerModel] = []
    
    class var sharedInstance: PIContainer {
        struct Singleton {
            static let instance = PIContainer()
        }
        return Singleton.instance
    }
    
    var excludedTickers: Set<String> = Set()
    var dashboardTickers: DashboardContainer = DashboardContainer()
    
    class DashboardContainer {
        var tickers = [DashboardTickerModel]()
        
        func addElement(element: DashboardTickerModel
            ) {
            self.tickers.append(element)
        }
        
        func removeElement(element: DashboardTickerModel) {
            self.tickers = self.tickers.filter({$0.ID != element.ID})
        }
        
        func contains(element: DashboardTickerModel) -> Bool {
            return self.tickers.filter({$0.ID == element.ID}).count == 1
            
        }
    }
}

//class PISettingsManager {

//    var dashboard:PIDashboardSettings = PIDashboardSettings()
//    var stock:PIStockSettings = PIStockSettings()
//    var currency:PICurrencySettings = PICurrencySettings()
//    var realEstate:PIRealEstateSettings = PIRealEstateSettings()
//    var bond:PIBondSettings = PIBondSettings()
//    var indices:PIIndicesSettings = PIIndicesSettings()
//    var mutualFund:PIMutualFundSettings = PIMutualFundSettings()
//    

//    var settings:PISettings = PISettings()
    
    
    
//    class var sharedInstance: PISettingsManager {
//        struct Singleton {
//            static let instance = PISettingsManager()
//        }
//        return Singleton.instance
//    }
//
//    func commit() {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        
//        let dashboard = NSKeyedArchiver.archivedDataWithRootObject(PISettingsManager.sharedInstance.dashboard)
//        defaults.setObject(dashboard, forKey: "dashboardState")
//
//        let stock = NSKeyedArchiver.archivedDataWithRootObject(PISettingsManager.sharedInstance.stock)
//        defaults.setObject(stock, forKey: "stockState")
//        
//        let currency = NSKeyedArchiver.archivedDataWithRootObject(PISettingsManager.sharedInstance.currency)
//        defaults.setObject(currency, forKey: "currencyState")
//        
//        let realEstate = NSKeyedArchiver.archivedDataWithRootObject(PISettingsManager.sharedInstance.realEstate)
//        defaults.setObject(realEstate, forKey: "realEstateState")
//        
//        let bond = NSKeyedArchiver.archivedDataWithRootObject(PISettingsManager.sharedInstance.bond)
//        defaults.setObject(bond, forKey: "bondState")
//        
//        let indices = NSKeyedArchiver.archivedDataWithRootObject(PISettingsManager.sharedInstance.indices)
//        defaults.setObject(indices, forKey: "indicesState")
//        
//        let mutualFund = NSKeyedArchiver.archivedDataWithRootObject(PISettingsManager.sharedInstance.mutualFund)
//        defaults.setObject(mutualFund, forKey: "mutualFundState")
//        
//        
//        
//        
//        let excludedTickers = NSKeyedArchiver.archivedDataWithRootObject(PISettingsManager.sharedInstance.settings.excludedTickers)
//        defaults.setObject(excludedTickers, forKey: "excludedTickers")
//        
//        
//
//        
//    }
//    
//    func pull() {
//        if let dashboard = NSUserDefaults.standardUserDefaults().objectForKey("dashboardState") as? NSData {
//            PISettingsManager.sharedInstance.dashboard = NSKeyedUnarchiver.unarchiveObjectWithData(dashboard) as! PIDashboardSettings
//        } else {
//            PISettingsManager.sharedInstance.dashboard.populateWithDefaultTickers()
//        }
//        
//        if let stock = NSUserDefaults.standardUserDefaults().objectForKey("stockState") as? NSData {
//            PISettingsManager.sharedInstance.stock = NSKeyedUnarchiver.unarchiveObjectWithData(stock) as! PIStockSettings
//        }
//        
//        if let currency = NSUserDefaults.standardUserDefaults().objectForKey("currencyState") as? NSData {
//            PISettingsManager.sharedInstance.currency = NSKeyedUnarchiver.unarchiveObjectWithData(currency) as! PICurrencySettings
//        }
//        
//        if let realEstate = NSUserDefaults.standardUserDefaults().objectForKey("realEstateState") as? NSData {
//            PISettingsManager.sharedInstance.realEstate = NSKeyedUnarchiver.unarchiveObjectWithData(realEstate) as! PIRealEstateSettings
//        }
//        
//        if let bond = NSUserDefaults.standardUserDefaults().objectForKey("bondState") as? NSData {
//            PISettingsManager.sharedInstance.bond = NSKeyedUnarchiver.unarchiveObjectWithData(bond) as! PIBondSettings
//        }
//        
//        if let indices = NSUserDefaults.standardUserDefaults().objectForKey("indicesState") as? NSData {
//            PISettingsManager.sharedInstance.indices = NSKeyedUnarchiver.unarchiveObjectWithData(indices) as! PIIndicesSettings
//        }
//        
//        if let mutualFund = NSUserDefaults.standardUserDefaults().objectForKey("mutualFundState") as? NSData {
//            PISettingsManager.sharedInstance.mutualFund = NSKeyedUnarchiver.unarchiveObjectWithData(mutualFund) as! PIMutualFundSettings
//        }
//        
//        
//        if let excludedTickers = NSUserDefaults.standardUserDefaults().objectForKey("excludedTickers") as? NSData {
//            PISettingsManager.sharedInstance.settings.excludedTickers = NSKeyedUnarchiver.unarchiveObjectWithData(excludedTickers) as! Set<String>
//        }
//        
//        
//    }
//}



class PISettings: NSObject {
    
    
    var selectedFilter:Filters = .StockSpec
    var filters:[Filters] = []
    var usingFilters:[Filters] = []
    var tickers: [TickerModel] = [] // persistent tickers collection
    var datePeriod:Periods = .OneDay

    var sorts:[SortTypes] = [SortTypes.ChangeUp,SortTypes.ChangeDown]
    var selectedSort:SortTypes = SortTypes.ChangeUp
//
    var section: Section = .StocksSection
    
    enum Filters: Int {
        case StockSpec
        
        case BondOtrasl
        case BondRating
        case BondSektor
        case BondPeriod
        case BondAmor
        case BondVidk
        
        case MutualFundFundType
        case MutualFundFundCat
        
        
        var description: String {
            switch self {
            case .StockSpec: return "Специализация"
            case .BondOtrasl: return "Отрасль"
            case .BondRating: return "Рейтинг"
            case .BondSektor: return "Сектор"
            case .BondPeriod: return "Период"
            case .BondAmor: return "Амортизация"
            case .BondVidk: return "Вид купона"
            case .MutualFundFundType: return "Тип"
            case .MutualFundFundCat: return "Категория"
            }
        }
    }
    
    enum SortTypes: Int {
        case ChangeUp
        case ChangeDown
        case CapUp
        case CapDown
        var description: String {
            if true {
                switch self {
                case .ChangeUp: return "Растущие"
                case .ChangeDown: return "Падающие"
                case .CapUp: return "Дорогие"
                case .CapDown: return "Дешевые"
                }
            }
        }
        
        
    }

    func applyExcludeListAtTickers(tickers: [TickerModel]) -> [TickerModel] {
        let correction1:[TickerModel] = tickers.map{ (ticker: TickerModel) in
            var tickerLocal = ticker
            if containsInExlideList(tickerLocal.Title) {
                tickerLocal.Show = false
            } else {
                tickerLocal.Show = true
            }
            return tickerLocal
        }
        
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var weekAgo:NSDate
        weekAgo = calendar.dateByAddingUnit(.Day, value: -7, toDate: NSDate(), options: [])!
            
    
        let correction2:[TickerModel] = correction1.filter{(ticker: TickerModel) in
            let date: NSDate = ((ticker.Items.first)?.Date)!
            if date > weekAgo {
                return true
            } else {
                return false
            }
        }
        return correction2
    }
    
    func addItemToExludeList(itemId:String) {
        PIContainer.sharedInstance.excludedTickers.insert(itemId)
    }
    
    func removeItemFromExludeList(itemId:String) {
        PIContainer.sharedInstance.excludedTickers.remove(itemId)
    }
    
    func containsInExlideList(itemId:String) -> Bool {
        return PIContainer.sharedInstance.excludedTickers.contains(itemId)
    }
    
    func containsInDashboard(ticker: TickerModel) -> Bool {
        return PIContainer.sharedInstance.dashboardTickers.contains(DashboardTickerModel(key: ticker.Key, title: ticker.Title, section: ticker.section, ID: ticker.ID))
    }
    
    func addToDashboard(ticker: TickerModel) {
        PIContainer.sharedInstance.dashboardTickers.addElement(DashboardTickerModel(key: ticker.Key, title: ticker.Title, section: ticker.section, ID: ticker.ID))
    }
    
    func removeFromDashboard(ticker: TickerModel) {
        PIContainer.sharedInstance.dashboardTickers.removeElement(DashboardTickerModel(key: ticker.Key, title: ticker.Title, section: ticker.section, ID: ticker.ID))
    }
    
    func dashboardTickers() -> [DashboardTickerModel] {
        return PIContainer.sharedInstance.dashboardTickers.tickers
    }
    
    func dateTill() -> String {
        let currentDate = NSDate()
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var newDate:NSDate
        let formatter = NSDateFormatter();
        formatter.dateFormat = "dd.MM.yyyy";

        newDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: currentDate, options: [])!
        
        return formatter.stringFromDate(newDate);
    }
    

    func dateFrom(period: Periods) -> String {
    
        let currentDate = NSDate()
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var newDate:NSDate

        let formatter = NSDateFormatter();
        formatter.dateFormat = "dd.MM.yyyy";

        
        
        switch (period) {
        case .OneDay:
            newDate = calendar.dateByAddingUnit(.Day, value: 0, toDate: currentDate, options: [])!
            
        case .OneWeek:
            newDate = calendar.dateByAddingUnit(.Day, value: -7, toDate: currentDate, options: [])!
            
        case .OneMonth:
            newDate = calendar.dateByAddingUnit(.Month, value: -1, toDate: currentDate, options: [])!
            
        case .OneYear:
            newDate = calendar.dateByAddingUnit(.Year, value: -1, toDate: currentDate, options: [])!

        case .ThreeYears:
            newDate = calendar.dateByAddingUnit(.Year, value: -3, toDate: currentDate, options: [])!
        
        case .FiveYears:
            newDate = calendar.dateByAddingUnit(.Year, value: -5, toDate: currentDate, options: [])!
        }
        
        return formatter.stringFromDate(newDate);
    }
    
    func descriptionFilterRow(row: Int) -> String {
        return ""
    }
    
    func countFilterRows() -> Int {
        return 0
    }
    
    func selectFilterRow(row: Int) {
        return
    }
    
    func selectedFilterRow() -> Int {
        return 0
    }
    
    func commit() {
        
    }
    
    func pull() -> PISettings? {
        return nil
    }

}

class PIDashboardSettings: PISettings, NSCoding {
    
    override var section: Section  {
        get {
            return .Dashboard
        }
        set {}
    }
    
    override init() {
        super.init()
        self.datePeriod = .OneMonth
    
    }
    
    func populateWithDefaultTickers() {
        PIContainer.sharedInstance.dashboardTickers.addElement(DashboardTickerModel(key: "Аэрофлот-ао", title: "Аэрофлот-ао", section: .StocksSection, ID: "4200"))
        PIContainer.sharedInstance.dashboardTickers.addElement(DashboardTickerModel(key: "Абсолют Банк-3-боб", title: "Абсолют Банк-3-боб", section: .BondsSection, ID: "89964"))
        PIContainer.sharedInstance.dashboardTickers.addElement(DashboardTickerModel(key: "R01235", title: "Доллар США", section: .CurrenciesSection, ID: "USD"))
    }

    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.datePeriod = Periods(rawValue: (decoder.decodeObjectForKey("datePeriod") as! Int))!
        self.selectedFilter = Filters(rawValue: (decoder.decodeObjectForKey("selectedFilter") as! Int))!
        self.selectedSort = SortTypes(rawValue: (decoder.decodeObjectForKey("selectedSort") as! Int))!
        PIContainer.sharedInstance.dashboardTickers.tickers = decoder.decodeObjectForKey("includedTickers") as! [DashboardTickerModel]
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.datePeriod.rawValue, forKey: "datePeriod")
        coder.encodeObject(self.selectedFilter.rawValue, forKey: "selectedFilter")
        coder.encodeObject(self.selectedSort.rawValue, forKey: "selectedSort")
//        coder.encodeObject(PISettingsManager.sharedInstance.dashboard.includedTickers.tickers, forKey: "includedTickers")
        
    }
    
    override func commit() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let dashboard = NSKeyedArchiver.archivedDataWithRootObject(self)
        defaults.setObject(dashboard, forKey: "dashboardState")
        
    }
    
    override func pull() -> PIDashboardSettings? {
        
        if let dashboard = NSUserDefaults.standardUserDefaults().objectForKey("dashboardState") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(dashboard) as? PIDashboardSettings
        } else {
            self.populateWithDefaultTickers()
        }

        return nil
    }
}

class PIMutualFundSettings: PISettings, NSCoding {
    
    override var section: Section  {
        get {
            return .MutualFundsSection
        }
        set {}
    }
    
    override init() {
        super.init()
        self.datePeriod = .OneYear
        self.selectedFilter = .MutualFundFundType
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.datePeriod = Periods(rawValue: (decoder.decodeObjectForKey("datePeriod") as! Int))!
        self.selectedSort = SortTypes(rawValue: (decoder.decodeObjectForKey("selectedSort") as! Int))!
        
        if let fundTypeRawValue =  decoder.decodeObjectForKey("fundType") {
            self.fundType = FundType(rawValue: fundTypeRawValue as! String)!
        }
        
        if let fundCatRawValue =  decoder.decodeObjectForKey("fundCat") {
            self.fundCat = FundCat(rawValue: fundCatRawValue as! String)!
        }
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
//        coder.encodeObject(PISettingsManager.sharedInstance.mutualFund.datePeriod.rawValue, forKey: "datePeriod")
//        coder.encodeObject(PISettingsManager.sharedInstance.mutualFund.selectedSort.rawValue, forKey: "selectedSort")
//        coder.encodeObject(PISettingsManager.sharedInstance.mutualFund.fundType.rawValue, forKey: "fundType")
//        coder.encodeObject(PISettingsManager.sharedInstance.mutualFund.fundCat.rawValue, forKey: "fundCat")
        
        coder.encodeObject(self.datePeriod.rawValue, forKey: "datePeriod")
        coder.encodeObject(self.selectedSort.rawValue, forKey: "selectedSort")
        coder.encodeObject(self.fundType.rawValue, forKey: "fundType")
        coder.encodeObject(self.fundCat.rawValue, forKey: "fundCat")
        
    }
    
    override var filters:[Filters] {
        get { return [Filters.MutualFundFundType, Filters.MutualFundFundCat]}
        set {}
    }
    override var usingFilters:[Filters] {
        get {
            var filters:[Filters] = []
            if fundType != .All { filters.append(.MutualFundFundType) }
            if fundCat != .All { filters.append(.MutualFundFundCat) }

            return filters
        }
        set {}
    }
    
    
    var fundType:FundType = .All
    
    enum FundType: String {
        case All = ""
        case Open = "открытый"
        case Interval = "интервальный"

        static let allValues = [All, Open, Interval]
        
        var description: String {
            switch self {
                case .All: return "Все"
                case .Open: return "Открытый"
                case .Interval: return "Интервальный"
            }
        }
    }
    
    
    var fundCat: FundCat = .All
    
    enum FundCat: String {
        case All = ""
        case Obligation = "облигации"
        case Stock = "акции"
        case Mutual = "смешанные инвестиции"
        case IndexStock = "индексный (акций)"
        
        static let allValues = [All, Obligation, Stock, Mutual, IndexStock]
        
        var description: String {
            switch self {
                case .All: return "Все"
                case .Obligation: return "Облигации"
                case .Stock: return "Акции"
                case .Mutual: return "Смешанные инвестиции"
                case .IndexStock: return "Индексный (акции)"
            }
        }
    }
    
    
    override func descriptionFilterRow(row: Int) -> String {
        switch selectedFilter {
            case .MutualFundFundType: return PIMutualFundSettings.FundType.allValues[row].description
            case .MutualFundFundCat: return PIMutualFundSettings.FundCat.allValues[row].description
            default: return "error"
        }
    }
    
    override func countFilterRows() -> Int {
        switch selectedFilter {
            case .MutualFundFundType: return PIMutualFundSettings.FundType.allValues.count
            case .MutualFundFundCat: return PIMutualFundSettings.FundCat.allValues.count
            default: print("error"); return -1
            
        }
    }
    
    override func selectFilterRow(row: Int) {
        switch selectedFilter {
//            case .MutualFundFundType: PISettingsManager.sharedInstance.mutualFund.fundType = PIMutualFundSettings.FundType.allValues[row]
//            case .MutualFundFundCat: PISettingsManager.sharedInstance.mutualFund.fundCat = PIMutualFundSettings.FundCat.allValues[row]
//            
            case .MutualFundFundType: self.fundType = PIMutualFundSettings.FundType.allValues[row]
            case .MutualFundFundCat: self.fundCat = PIMutualFundSettings.FundCat.allValues[row]
            default: print("error")
        }
    }
    
    override func selectedFilterRow() -> Int {
        switch selectedFilter {
//            case .MutualFundFundType: return PIMutualFundSettings.FundType.allValues.indexOf(PISettingsManager.sharedInstance.mutualFund.fundType)!
//            case .MutualFundFundCat: return PIMutualFundSettings.FundCat.allValues.indexOf(PISettingsManager.sharedInstance.mutualFund.fundCat)!
            
            case .MutualFundFundType: return PIMutualFundSettings.FundType.allValues.indexOf(self.fundType)!
            case .MutualFundFundCat: return PIMutualFundSettings.FundCat.allValues.indexOf(self.fundCat)!

            
            default: print("error"); return -1
        }
    }
    
    override func commit() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let mutualFund = NSKeyedArchiver.archivedDataWithRootObject(self)
        defaults.setObject(mutualFund, forKey: "mutualFundState")
        
    }

    override func pull() -> PIMutualFundSettings? {
        if let mutualFund = NSUserDefaults.standardUserDefaults().objectForKey("mutualFundState") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(mutualFund) as? PIMutualFundSettings
        } else {
            return nil
        }
    }
}

class PICurrencySettings: PISettings, NSCoding {
    override var section: Section  {
        get {
            return .CurrenciesSection
        }
        set {}
    }
    
    override init() {
        super.init()
        self.datePeriod = .OneWeek
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.datePeriod = Periods(rawValue: (decoder.decodeObjectForKey("datePeriod") as! Int))!
        self.selectedSort = SortTypes(rawValue: (decoder.decodeObjectForKey("selectedSort") as! Int))!
    }
    
    func encodeWithCoder(coder: NSCoder) {
//        coder.encodeObject(PISettingsManager.sharedInstance.currency.datePeriod.rawValue, forKey: "datePeriod")
//        coder.encodeObject(PISettingsManager.sharedInstance.currency.selectedSort.rawValue, forKey: "selectedSort")
        
        coder.encodeObject(self.datePeriod.rawValue, forKey: "datePeriod")
        coder.encodeObject(self.selectedSort.rawValue, forKey: "selectedSort")
    }
    
    override func commit() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let currency = NSKeyedArchiver.archivedDataWithRootObject(self)
        defaults.setObject(currency, forKey: "currencyState")

    }
    
    override func pull() -> PICurrencySettings? {
        if let currency = NSUserDefaults.standardUserDefaults().objectForKey("currencyState") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(currency) as? PICurrencySettings
        } else {
            return nil
        }
    }
    
    
}

class PIRealEstateSettings: PISettings, NSCoding {
    override var section: Section  {
        get {
            return .RealEstatesSection
        }
        set {}
    }
    
    override init() {
        super.init()
        self.datePeriod = .OneYear
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.datePeriod = Periods(rawValue: (decoder.decodeObjectForKey("datePeriod") as! Int))!
        self.selectedSort = SortTypes(rawValue: (decoder.decodeObjectForKey("selectedSort") as! Int))!
    }
    
    func encodeWithCoder(coder: NSCoder) {
//        coder.encodeObject(PISettingsManager.sharedInstance.realEstate.datePeriod.rawValue, forKey: "datePeriod")
//        coder.encodeObject(PISettingsManager.sharedInstance.realEstate.selectedSort.rawValue, forKey: "selectedSort")
        coder.encodeObject(self.datePeriod.rawValue, forKey: "datePeriod")
        coder.encodeObject(self.selectedSort.rawValue, forKey: "selectedSort")
    }

    override func commit() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let currency = NSKeyedArchiver.archivedDataWithRootObject(self)
        defaults.setObject(currency, forKey: "realEstateState")
        
    }
    
    override func pull() -> PIRealEstateSettings? {
        if let realEstate = NSUserDefaults.standardUserDefaults().objectForKey("realEstateState") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(realEstate) as? PIRealEstateSettings
        } else {
            return nil
        }
    }
    
}

class PIBondSettings: PISettings, NSCoding {
    override var section: Section  {
        get {
            return .BondsSection
        }
        set {}
    }
    
    override init() {
        super.init()
        self.selectedFilter = .BondOtrasl
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.datePeriod = Periods(rawValue: (decoder.decodeObjectForKey("datePeriod") as! Int))!
        self.selectedSort = SortTypes(rawValue: (decoder.decodeObjectForKey("selectedSort") as! Int))!
        if let otraslRawValue =  decoder.decodeObjectForKey("otrasl") {
           self.otrasl = Otrasl(rawValue:otraslRawValue as! String)!
        }
        
        if let ratingRawValue =  decoder.decodeObjectForKey("rating") {
            self.rating = Rating(rawValue: ratingRawValue as! String)!
        }
        
        if let sektorRawValue =  decoder.decodeObjectForKey("sektor") {
            self.sektor = Sektor(rawValue: sektorRawValue as! String)!
        }
        
        if let periodRawValue =  decoder.decodeObjectForKey("period") {
            self.period = Period(rawValue: periodRawValue as! String)!
        }
        
        if let amortizacRawValue =  decoder.decodeObjectForKey("amortizac") {
            self.amortizac = Amortizac(rawValue: amortizacRawValue as! String)!
        }
        
        if let vidkuponaRawValue =  decoder.decodeObjectForKey("vidkupona") {
            self.vidkupona = Vidkupona(rawValue: vidkuponaRawValue as! String)!
        }

    }
    
    
    func encodeWithCoder(coder: NSCoder) {
//        coder.encodeObject(PISettingsManager.sharedInstance.bond.datePeriod.rawValue, forKey: "datePeriod")
//        coder.encodeObject(PISettingsManager.sharedInstance.bond.selectedSort.rawValue, forKey: "selectedSort")
//        coder.encodeObject(PISettingsManager.sharedInstance.bond.otrasl.rawValue, forKey: "otrasl")
//        coder.encodeObject(PISettingsManager.sharedInstance.bond.rating.rawValue, forKey: "rating")
//        coder.encodeObject(PISettingsManager.sharedInstance.bond.sektor.rawValue, forKey: "sektor")
//        coder.encodeObject(PISettingsManager.sharedInstance.bond.period.rawValue, forKey: "period")
//        coder.encodeObject(PISettingsManager.sharedInstance.bond.amortizac.rawValue, forKey: "amortizac")
//        coder.encodeObject(PISettingsManager.sharedInstance.bond.vidkupona.rawValue, forKey: "vidkupona")
        
        
        coder.encodeObject(self.datePeriod.rawValue, forKey: "datePeriod")
        coder.encodeObject(self.selectedSort.rawValue, forKey: "selectedSort")
        coder.encodeObject(self.otrasl.rawValue, forKey: "otrasl")
        coder.encodeObject(self.rating.rawValue, forKey: "rating")
        coder.encodeObject(self.sektor.rawValue, forKey: "sektor")
        coder.encodeObject(self.period.rawValue, forKey: "period")
        coder.encodeObject(self.amortizac.rawValue, forKey: "amortizac")
        coder.encodeObject(self.vidkupona.rawValue, forKey: "vidkupona")
        
    }
    
    
    override var filters:[Filters] {
        get {
            return [Filters.BondOtrasl, Filters.BondSektor, Filters.BondRating, Filters.BondPeriod, Filters.BondAmor, Filters.BondVidk]
        }
        set {}
    }
    
    override var usingFilters:[Filters] {
        get {
            var filters:[Filters] = []
            if otrasl != .All { filters.append(.BondOtrasl) }
            if sektor != .All { filters.append(.BondSektor) }
            if rating != .All { filters.append(.BondRating) }
            if period != .All { filters.append(.BondPeriod) }
            if amortizac != .All { filters.append(.BondAmor) }
            if vidkupona != .All { filters.append(.BondVidk) }

            return filters
        }
        set {}
    }
    
    var otrasl:Otrasl = .All

    enum Otrasl: String {
        case All = ""
        case Banks = "Банки"
        case Transportation = "Транспорт"
        case Other = "Другое"
        case Munic = "Муницип"
        case Communication = "Телеком"
        case Finance = "Финансы"
        case OilGaz = "Нефтегаз"
        case Construction = "Строительство"
        case Food = "Пищевая"
        case EngineeringIndustry = "Машиностроение"
        case Govern = "Государственные"
        
        static let allValues = [All, Banks, Transportation, Communication, Munic, Finance, OilGaz, Construction, Food, EngineeringIndustry, Govern, Other]
        
        var description: String {

            switch self {
                case .All: return "Все"
                case .Banks: return "Банки"
                case .Transportation: return "Транспорт"
                case .Other: return "Другое"
                case .Munic: return "Муницип"
                case .Communication: return "Телеком"
                case .Finance: return "Финансы"
                case .OilGaz: return "Нефтегаз"
                case .Construction: return "Строительство"
                case .Food: return "Пищевая"
                case .EngineeringIndustry: return "Машиностроение"
                case .Govern: return "Государственные"
                
            }
        }
    }
    
    var rating: Rating = .All
    enum Rating: String {
        case All = ""
        case Yes = "есть"
        case No = "нет"
        
        static let allValues = [All, Yes, No]
        
        var description: String {
            switch self {
                case .All: return "Все"
                case .Yes: return "Есть"
                case .No: return "Нет"
            }
        }
    }
    
    var sektor: Sektor = .All
    enum Sektor: String {
        case All = ""
        case Corporate = "Корпоративные"
        case Munic = "Муниципальные"
        case Govern = "Государственные"
        
        static let allValues = [All, Corporate, Munic, Govern]
        
        var description: String {
            switch self {
                case .All: return "Все"
                case .Corporate: return "Корпоративные"
                case .Munic: return "Муниципальные"
                case .Govern: return "Государственные"
            }
        }
    }
    
    var period: Period = .All
    
    enum Period: String {
        case All = ""
        case F2t3 = "2-3 года"
        case F3t5 = "3-5 лет"
        case F5 = "Более 5 лет"
        
        static let allValues = [All, F2t3, F3t5, F5]
        
        var description: String {
            switch self {
                case .All: return "Все"
                case .F2t3: return "2-3 года"
                case .F3t5: return "3-5 лет"
                case .F5: return "Более 5 лет"
            }
        }
    }
    
    var amortizac: Amortizac = .All
    
    enum Amortizac: String {
        case All = ""
        case Yes = "есть"
        case No = "нет"
        
        static let allValues = [All, Yes, No]
        
        var description: String {
            switch self {
                case .All: return "Все"
                case .Yes: return "Есть"
                case .No: return "Нет"
            }
        }
    }
    
    var vidkupona: Vidkupona = .All
    
    enum Vidkupona: String {
        case All = ""
        case Fix = "фиксированный"
        case Permanent = "постоянный"
        case Variable = "переменный"
        
        static let allValues = [All, Fix, Permanent, Variable]
        
        
        var description: String {
            switch self {
                case .All: return "Все"
                case .Fix: return "Фиксированный"
                case .Permanent: return "Постоянный"
                case .Variable: return "Переменный"
            }
        }
    }
    
    
    
    
    override func descriptionFilterRow(row: Int) -> String {
        switch selectedFilter {
            case .BondOtrasl: return PIBondSettings.Otrasl.allValues[row].description
            case .BondRating: return PIBondSettings.Rating.allValues[row].description
            case .BondSektor: return PIBondSettings.Sektor.allValues[row].description
            case .BondPeriod: return PIBondSettings.Period.allValues[row].description
            case .BondAmor: return PIBondSettings.Amortizac.allValues[row].description
            case .BondVidk: return PIBondSettings.Vidkupona.allValues[row].description
            default: return "error"
        }
    }
    
    override func countFilterRows() -> Int {
        switch selectedFilter {
            case .BondOtrasl: return PIBondSettings.Otrasl.allValues.count
            case .BondRating: return PIBondSettings.Rating.allValues.count
            case .BondSektor: return PIBondSettings.Sektor.allValues.count
            case .BondPeriod: return PIBondSettings.Period.allValues.count
            case .BondAmor: return PIBondSettings.Amortizac.allValues.count
            case .BondVidk: return PIBondSettings.Vidkupona.allValues.count
            default: print("error"); return -1

        }
    }
    
    override func selectFilterRow(row: Int) {
        switch selectedFilter {
//            case .BondOtrasl: PISettingsManager.sharedInstance.bond.otrasl = PIBondSettings.Otrasl.allValues[row]
//            case .BondRating: PISettingsManager.sharedInstance.bond.rating = PIBondSettings.Rating.allValues[row]
//            case .BondSektor: PISettingsManager.sharedInstance.bond.sektor = PIBondSettings.Sektor.allValues[row]
//            case .BondPeriod: PISettingsManager.sharedInstance.bond.period = PIBondSettings.Period.allValues[row]
//            case .BondAmor: PISettingsManager.sharedInstance.bond.amortizac = PIBondSettings.Amortizac.allValues[row]
//            case .BondVidk: PISettingsManager.sharedInstance.bond.vidkupona = PIBondSettings.Vidkupona.allValues[row]
            
            case .BondOtrasl: self.otrasl = PIBondSettings.Otrasl.allValues[row]
            case .BondRating: self.rating = PIBondSettings.Rating.allValues[row]
            case .BondSektor: self.sektor = PIBondSettings.Sektor.allValues[row]
            case .BondPeriod: self.period = PIBondSettings.Period.allValues[row]
            case .BondAmor: self.amortizac = PIBondSettings.Amortizac.allValues[row]
            case .BondVidk: self.vidkupona = PIBondSettings.Vidkupona.allValues[row]
            default: print("error")
        }
    }
    
    override func selectedFilterRow() -> Int {
        switch selectedFilter {
//            case .BondOtrasl: return PIBondSettings.Otrasl.allValues.indexOf(PISettingsManager.sharedInstance.bond.otrasl)!
//            case .BondRating: return PIBondSettings.Rating.allValues.indexOf(PISettingsManager.sharedInstance.bond.rating)!
//            case .BondSektor: return PIBondSettings.Sektor.allValues.indexOf(PISettingsManager.sharedInstance.bond.sektor)!
//            case .BondPeriod: return PIBondSettings.Period.allValues.indexOf(PISettingsManager.sharedInstance.bond.period)!
//            case .BondAmor: return PIBondSettings.Amortizac.allValues.indexOf(PISettingsManager.sharedInstance.bond.amortizac)!
//            case .BondVidk: return PIBondSettings.Vidkupona.allValues.indexOf(PISettingsManager.sharedInstance.bond.vidkupona)!
            
            case .BondOtrasl: return PIBondSettings.Otrasl.allValues.indexOf(self.otrasl)!
            case .BondRating: return PIBondSettings.Rating.allValues.indexOf(self.rating)!
            case .BondSektor: return PIBondSettings.Sektor.allValues.indexOf(self.sektor)!
            case .BondPeriod: return PIBondSettings.Period.allValues.indexOf(self.period)!
            case .BondAmor: return PIBondSettings.Amortizac.allValues.indexOf(self.amortizac)!
            case .BondVidk: return PIBondSettings.Vidkupona.allValues.indexOf(self.vidkupona)!

                
            default: print("error"); return -1
        }
    }

    override func commit() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let currency = NSKeyedArchiver.archivedDataWithRootObject(self)
        defaults.setObject(currency, forKey: "bondState")
        
    }
    
    override func pull() -> PIBondSettings? {
        if let bond = NSUserDefaults.standardUserDefaults().objectForKey("bondState") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(bond) as? PIBondSettings
        } else {
            return nil
        }
    }
    
}

class PIIndicesSettings: PISettings, NSCoding {
    override var section: Section  {
        get {
            return .IndicesSection
        }
        set {}
    }
    
    override init() {
        super.init()
        self.datePeriod = .OneYear
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.datePeriod = Periods(rawValue: (decoder.decodeObjectForKey("datePeriod") as! Int))!
        self.selectedSort = SortTypes(rawValue: (decoder.decodeObjectForKey("selectedSort") as! Int))!
    }
    
    func encodeWithCoder(coder: NSCoder) {
//        coder.encodeObject(PISettingsManager.sharedInstance.indices.datePeriod.rawValue, forKey: "datePeriod")
//        coder.encodeObject(PISettingsManager.sharedInstance.indices.selectedSort.rawValue, forKey: "selectedSort")
        
        coder.encodeObject(self.datePeriod.rawValue, forKey: "datePeriod")
        coder.encodeObject(self.selectedSort.rawValue, forKey: "selectedSort")
    }
    
    override func commit() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let currency = NSKeyedArchiver.archivedDataWithRootObject(self)
        defaults.setObject(currency, forKey: "indicesState")
        
    }
    
    override func pull() -> PIIndicesSettings? {
        if let indices = NSUserDefaults.standardUserDefaults().objectForKey("indicesState") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(indices) as? PIIndicesSettings
        } else {
            return nil
        }
    }
    
}

class PIStockSettings: PISettings, NSCoding {
    override var section: Section  {
        get {
            return .StocksSection
        }
        set {}
    }
    
    override init() {
        super.init()
    }
    
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.datePeriod = Periods(rawValue: (decoder.decodeObjectForKey("datePeriod") as! Int))!
        self.specialisation = Specialisations(rawValue: (decoder.decodeObjectForKey("specialisation") as! String))!
        self.selectedSort = SortTypes(rawValue: (decoder.decodeObjectForKey("selectedSort") as! Int))!
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
//        coder.encodeObject(PISettingsManager.sharedInstance.stock.datePeriod.rawValue, forKey: "datePeriod")
//        coder.encodeObject(PISettingsManager.sharedInstance.stock.specialisation.rawValue, forKey: "specialisation")
//        coder.encodeObject(PISettingsManager.sharedInstance.stock.selectedSort.rawValue, forKey: "selectedSort")
//        
        coder.encodeObject(self.datePeriod.rawValue, forKey: "datePeriod")
        coder.encodeObject(self.specialisation.rawValue, forKey: "specialisation")
        coder.encodeObject(self.selectedSort.rawValue, forKey: "selectedSort")

    }
    
    
    override var filters:[Filters] {
        get { return [Filters.StockSpec]}
        set {}
    }
    


    override var sorts:[SortTypes] {
        get {
            return [SortTypes.ChangeUp, SortTypes.ChangeDown, SortTypes.CapUp, SortTypes.CapDown]
        }
        set {}
    }
    var specialisation:Specialisations = .All
    
    
    
    enum Specialisations: String {
        case All = ""
        case Banks = "Банки"
        case EngineeringIndustry = "Машиностроение"
        case FerrousMetals = "Металлургия"
        case OilGaz = "Нефть и газ"
        case FoodIndustry = "Пищевая"
        case Construction = "Строительство"
        case Retail = "Потребительский сектор"
        case Transportation = "Транспорт"
        case Power = "Энергетика"
        case Other = "Прочее"
        case MiningIndustry = "Горнодобывающая"
        case Development = "Девелопмент"
        case CommunicationIT = "Телеком медиа IT"
        case Fertilizers = "Удобрения"
        case Pharma = "Фармацевтика"
        case FinancialSector = "Финансовый сектор"
        case ChemicalPetrochemicalIndustry = "Химия и нефтехимия"
        
        static let allValues = [All, Banks, EngineeringIndustry, FerrousMetals, OilGaz, FoodIndustry, Construction, Retail, Transportation, Power, MiningIndustry, Development, CommunicationIT, Fertilizers, Pharma, FinancialSector, ChemicalPetrochemicalIndustry, Other]
        
      
        var description: String {
            if true {
                switch self {
                    case .All: return "Ваще все"
                    case .Banks: return "Рептилойды"
                        //            case .lightIndustry: return "Other"
                    case .EngineeringIndustry: return "Аннунаки"
                    case .FerrousMetals: return "Иллюминаты"
                    case .OilGaz: return "Масоны"
                    case .FoodIndustry: return "Сайентологи"
                    case .Construction: return "Каббалисты"
                        //            case .communication: return "communication"
                    case .Retail: return "Восточные тамплиеры"
                    case .Transportation: return "Комитет 300"
                        //            case .finance: return "finance"
                        //            case .chemicalIndustry: return "chemicalIndustry"
                    case .Power: return "Дети Чубайса"
                    case .MiningIndustry: return "Чумазики"
                    case .Development: return "Прорабы"
                    case .CommunicationIT: return "Очкастые"
                    case .Fertilizers: return "Запах успеха"
                    case .Pharma: return "Драгдиллеры"
                    case .FinancialSector: return "Сионистские мудрецы"
                    case .ChemicalPetrochemicalIndustry: return "Варщики"
                    case .Other: return "И тому подобная фигня"
                }

            } else {
                switch self {
                    case .All: return "all"
                    case .Banks: return "banks"
                        //            case .lightIndustry: return "Other"
                    case .EngineeringIndustry: return "engineeringIndustry"
                    case .FerrousMetals: return "ferrousMetals"
                    case .OilGaz: return "oilGaz"
                    case .FoodIndustry: return "foodIndustry"
                    case .Construction: return "construction"
                        //            case .communication: return "communication"
                    case .Retail: return "retail"
                    case .Transportation: return "transportation"
                        //            case .finance: return "finance"
                        //            case .chemicalIndustry: return "chemicalIndustry"
                    case .Power: return "power"
                    case .Other: return "other"
                    case .MiningIndustry: return "miningIndustry"
                    case .Development: return "development"
                    case .CommunicationIT: return "communicationIT"
                    case .Fertilizers: return "fertilizers"
                    case .Pharma: return "pharma"
                    case .FinancialSector: return "financialSector"
                    case .ChemicalPetrochemicalIndustry: return "chemicalPetrochemicalIndustry"
                }
            }
        }
    }
    
    override func descriptionFilterRow(row: Int) -> String {
        return PIStockSettings.Specialisations.allValues[row].description
    }
    
    override func countFilterRows() -> Int {
        return PIStockSettings.Specialisations.allValues.count
    }
    
    override func selectFilterRow(row: Int) {
//        PISettingsManager.sharedInstance.stock.specialisation = PIStockSettings.Specialisations.allValues[row]
        self.specialisation = PIStockSettings.Specialisations.allValues[row]
    }
    
    override func selectedFilterRow() -> Int {
//        return PIStockSettings.Specialisations.allValues.indexOf(PISettingsManager.sharedInstance.stock.specialisation)!
        
        return PIStockSettings.Specialisations.allValues.indexOf(self.specialisation)!
    }
    
    override func commit() {
    
        let defaults = NSUserDefaults.standardUserDefaults()
        let stock = NSKeyedArchiver.archivedDataWithRootObject(self)
        defaults.setObject(stock, forKey: "stockState")
        
    }
    
    override func pull() -> PIStockSettings? {
        if let stock = NSUserDefaults.standardUserDefaults().objectForKey("stockState") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(stock) as? PIStockSettings
        } else {
            return nil
        }
    }
}

enum Periods: Int {
    case FiveYears
    case ThreeYears
    case OneYear
    case OneMonth
    case OneWeek
    case OneDay
}

enum Section: String {
    case Dashboard
    case StocksSection
    case CurrenciesSection
    case RealEstatesSection
    case BondsSection
    case WorldIndicesSection
    case IndicesSection
    case RusIndicesSection
    case MutualFundsSection
    
    var description: String {
        switch self {
        case .Dashboard: return "dashboard"
        case .StocksSection: return "Stocks"
        case .CurrenciesSection: return "Currencies"
        case .RealEstatesSection: return "RealEstate"
        case .BondsSection: return "Bonds"
        case .WorldIndicesSection: return "WorldIndices"
        case .RusIndicesSection: return "RusIndices"
        case .MutualFundsSection: return "MutualFunds"
        case .IndicesSection: return "indices"
        }
    }
}


extension NSDate: Comparable { }


