//
//  PISettings.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 04.08.15.
//  Copyright (c) 2015 PKMR. All rights reserved.
//

import Foundation

class PISettingsManager {
    
    var dashboard:PIDashboardSettings = PIDashboardSettings()
    var stock:PIStockSettings = PIStockSettings()
    var currency:PICurrencySettings = PICurrencySettings()
    var realEstate:PIRealEstateSettings = PIRealEstateSettings()
    var bond:PIBondSettings = PIBondSettings()
    var indices:PIIndicesSettings = PIIndicesSettings()
    var mutualFund:PIMutualFundSettings = PIMutualFundSettings()
    

    var settings:PISettings = PISettings()
    
    
    
    class var sharedInstance: PISettingsManager {
        struct Singleton {
            static let instance = PISettingsManager()
        }
        return Singleton.instance
    }
    
    func commit() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let dashboard = NSKeyedArchiver.archivedDataWithRootObject(PISettingsManager.sharedInstance.dashboard)
        defaults.setObject(dashboard, forKey: "dashboardState")
        let stock = NSKeyedArchiver.archivedDataWithRootObject(PISettingsManager.sharedInstance.stock)
        defaults.setObject(stock, forKey: "stockState")

        
    }
    
    func pull() {
        if let dashboard = NSUserDefaults.standardUserDefaults().objectForKey("dashboardState") as? NSData {
            PISettingsManager.sharedInstance.dashboard = NSKeyedUnarchiver.unarchiveObjectWithData(dashboard) as! PIDashboardSettings
        } else {
            PISettingsManager.sharedInstance.dashboard.populateWithDefaultTickers()
            
        }
        
        if let stock = NSUserDefaults.standardUserDefaults().objectForKey("stockState") as? NSData {
            PISettingsManager.sharedInstance.stock = NSKeyedUnarchiver.unarchiveObjectWithData(stock) as! PIStockSettings
        }
        
        
    }
}



class PISettings: NSObject {
    
    
    var selectedFilter:Filters = .stockSpec
    var filters:[Filters] = []
    var tickers: [TickerModel] = [] // persistent tickers collection
    var datePeriod:Periods = .oneDay

    var sorts:[SortTypes] = [SortTypes.changeUp,SortTypes.changeDown]
    var selectedSort:SortTypes = SortTypes.changeUp
    var excludedTickers: Set<String> = Set() // excluded from list
    var includedTickers: DashboardContainer = DashboardContainer()
    
    
    enum Filters: Int {
        case stockSpec
        case bondOtrasl
        case bondRating
        case bondSektor
        case bondPeriod
        case bondAmor
        case bondVidk
        
        var description: String {
            switch self {
            case .stockSpec: return "Специализация"
            case .bondOtrasl: return "Отрасль"
            case .bondRating: return "Рейтинг"
            case .bondSektor: return "Сектор"
            case .bondPeriod: return "Период"
            case .bondAmor: return "Амортизация"
            case .bondVidk: return "Вид купона"
            }
        }
    }
    
    enum SortTypes: Int {
        case changeUp
        case changeDown
        case capUp
        case capDown
        var description: String {
            if true {
                switch self {
                case .changeUp: return "Растущие"
                case .changeDown: return "Падающие"
                case .capUp: return "Дорогие"
                case .capDown: return "Дешевые"
                }
            }
        }
    }
    
    func applyExcludeListAtTickers(tickers: [TickerModel]) -> [TickerModel] {
        let correction1:[TickerModel] = tickers.map{ (var ticker: TickerModel) in
            if containsInExlideList(ticker.Title) {
                ticker.Show = false
            } else {
                ticker.Show = true
            }
            return ticker
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
        excludedTickers.add(itemId)
    }
    
    func removeItemFromExludeList(itemId:String) {
        excludedTickers.remove(itemId)
    }
    
    func containsInExlideList(itemId:String) -> Bool {
        return excludedTickers.contains(itemId)
    }
    
    func containsInDashboard(ticker: TickerModel) -> Bool {
        return includedTickers.contains(DashboardTickerModel(key: ticker.Key, title: ticker.Title, section: ticker.section, ID: ticker.ID))
    }
    
    func addToDashboard(ticker: TickerModel) {
        includedTickers.addElement(DashboardTickerModel(key: ticker.Key, title: ticker.Title, section: ticker.section, ID: ticker.ID))
    }
    
    func removeFromDashboard(ticker: TickerModel) {
        includedTickers.removeElement(DashboardTickerModel(key: ticker.Key, title: ticker.Title, section: ticker.section, ID: ticker.ID))
    }
    
    func dashboardTickers() -> [DashboardTickerModel] {
        return includedTickers.tickers
    }
    
    
    func dateTill() -> NSString {
        let currentDate = NSDate()
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var newDate:NSDate
        let formatter = NSDateFormatter();
        formatter.dateFormat = "dd.MM.yyyy";

        newDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: currentDate, options: [])!
        
        return formatter.stringFromDate(newDate);
    }
    

    func dateFrom() -> NSString {
    
        let currentDate = NSDate()
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var newDate:NSDate

        let formatter = NSDateFormatter();
        formatter.dateFormat = "dd.MM.yyyy";

        
        
        switch (datePeriod) {
        case .oneDay:
            newDate = calendar.dateByAddingUnit(.Day, value: 0, toDate: currentDate, options: [])!
            
        case .oneWeek:
            newDate = calendar.dateByAddingUnit(.Day, value: -7, toDate: currentDate, options: [])!
            
        case .oneMonth:
            newDate = calendar.dateByAddingUnit(.Month, value: -1, toDate: currentDate, options: [])!
            
        case .oneYear:
            newDate = calendar.dateByAddingUnit(.Year, value: -1, toDate: currentDate, options: [])!

        case .threeYears:
            newDate = calendar.dateByAddingUnit(.Year, value: -3, toDate: currentDate, options: [])!
        
        case .fiveYears:
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

}

class PIDashboardSettings: PISettings, NSCoding {
    
    
    override init() {
        super.init()
        self.datePeriod = .oneMonth
    
    }
    
    func populateWithDefaultTickers() {
        self.includedTickers.addElement(DashboardTickerModel(key: "Аэрофлот-ао", title: "Аэрофлот-ао", section: .stocksSection, ID: "4200"))
        self.includedTickers.addElement(DashboardTickerModel(key: "Абсолют Банк-3-боб", title: "Абсолют Банк-3-боб", section: .bondsSection, ID: "89964"))
        self.includedTickers.addElement(DashboardTickerModel(key: "R01235", title: "Доллар США", section: .currenciesSection, ID: "USD"))
    }

    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.datePeriod = Periods(rawValue: (decoder.decodeObjectForKey("datePeriod") as! Int))!
        self.selectedFilter = Filters(rawValue: (decoder.decodeObjectForKey("selectedFilter") as! Int))!
        self.selectedSort = SortTypes(rawValue: (decoder.decodeObjectForKey("selectedSort") as! Int))!
        self.includedTickers.tickers = decoder.decodeObjectForKey("includedTickers") as! [DashboardTickerModel]
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(PISettingsManager.sharedInstance.dashboard.datePeriod.rawValue, forKey: "datePeriod")
        coder.encodeObject(PISettingsManager.sharedInstance.dashboard.selectedFilter.rawValue, forKey: "selectedFilter")
        coder.encodeObject(PISettingsManager.sharedInstance.dashboard.selectedSort.rawValue, forKey: "selectedSort")
        coder.encodeObject(PISettingsManager.sharedInstance.dashboard.includedTickers.tickers, forKey: "includedTickers")
        
    }
}

class PIMutualFundSettings: PISettings {
    override init() {
        super.init()
        self.datePeriod = .oneYear
    }
}

class PICurrencySettings: PISettings {
    override init() {
        super.init()
        self.datePeriod = .oneWeek
    }
    
}

class PIRealEstateSettings: PISettings {
    override init() {
        super.init()
        self.datePeriod = .oneYear
    }

}

class PIBondSettings: PISettings {

    
    override init() {
        super.init()
        self.selectedFilter = .bondOtrasl
    }
    
    override var filters:[Filters] {
        get { return [Filters.bondOtrasl, Filters.bondSektor, Filters.bondRating, Filters.bondPeriod, Filters.bondAmor, Filters.bondVidk]}
        set {}
    }
    
    
    
    var otrasl:Otrasl = .all

    enum Otrasl: String {
        case all = ""
        case banks = "Банки"
        case transportation = "Транспорт"
        case other = "Другое"
        case munic = "Муницип"
        case communication = "Телеком"
        case finance = "Финансы"
        case oilGaz = "Нефтегаз"
        case construction = "Строительство"
        case food = "Пищевая"
        case engineeringIndustry = "Машиностроение"
        case govern = "Государственные"
        
        static let allValues = [all, banks, transportation, communication, munic, finance, oilGaz, construction, food, engineeringIndustry, govern, other]
        
        
        var description: String {

            switch self {
                case .all: return "Все"
                case .banks: return "Банки"
                case .transportation: return "Транспорт"
                case .other: return "Другое"
                case .munic: return "Муницип"
                case .communication: return "Телеком"
                case .finance: return "Финансы"
                case .oilGaz: return "Нефтегаз"
                case .construction: return "Строительство"
                case .food: return "Пищевая"
                case .engineeringIndustry: return "Машиностроение"
                case .govern: return "Государственные"
                
            }
        }
    }
    
    var rating: Rating = .all
    enum Rating: String {
        case all = ""
        case yes = "есть"
        case no = "нет"
        
        static let allValues = [all, yes, no]
        
        var description: String {
            switch self {
                case .all: return "Все"
                case .yes: return "Есть"
                case .no: return "Нет"
            }
        }
    }
    
    var sektor: Sektor = .all
    enum Sektor: String {
        case all = ""
        case corporate = "Корпоративные"
        case munic = "Муниципальные"
        case govern = "Государственные"
        
        static let allValues = [all, corporate, munic, govern]
        
        var description: String {
            switch self {
                case .all: return "Все"
                case .corporate: return "Корпоративные"
                case .munic: return "Муниципальные"
                case .govern: return "Государственные"
            }
        }
    }
    
    var period: Period = .all
    
    enum Period: String {
        case all = ""
        case f2t3 = "2-3 года"
        case f3t5 = "3-5 лет"
        case f5 = "Более 5 лет"
        
        static let allValues = [all, f2t3, f3t5, f5]
        
        var description: String {
            switch self {
                case .all: return "Все"
                case .f2t3: return "2-3 года"
                case .f3t5: return "3-5 лет"
                case .f5: return "Более 5 лет"
            }
        }
    }
    
    var amorticac: Amortizac = .all
    
    enum Amortizac: String {
        case all = ""
        case yes = "есть"
        case no = "нет"
        
        static let allValues = [all, yes, no]
        
        var description: String {
            switch self {
                case .all: return "Все"
                case .yes: return "Есть"
                case .no: return "Нет"
            }
        }
    }
    
    var vidkupona: Vidkupona = .all
    
    enum Vidkupona: String {
        case all = ""
        case fix = "Фиксированный"
        case permanent = "Постоянный"
        case variable = "Переменный"
        
        static let allValues = [all, fix, permanent, variable]
        
        var description: String {
            switch self {
                case .all: return "Все"
                case .fix: return "Фиксированный"
                case .permanent: return "Постоянный"
                case .variable: return "Переменный"
            }
        }
    }
    
    
    override func descriptionFilterRow(row: Int) -> String {
        switch selectedFilter {
            case .bondOtrasl: return PIBondSettings.Otrasl.allValues[row].description
            case .bondRating: return PIBondSettings.Rating.allValues[row].description
            case .bondSektor: return PIBondSettings.Sektor.allValues[row].description
            case .bondPeriod: return PIBondSettings.Period.allValues[row].description
            case .bondAmor: return PIBondSettings.Amortizac.allValues[row].description
            case .bondVidk: return PIBondSettings.Vidkupona.allValues[row].description
            default: return "error"
        }
    }
    
    override func countFilterRows() -> Int {
        switch selectedFilter {
            case .bondOtrasl: return PIBondSettings.Otrasl.allValues.count
            case .bondRating: return PIBondSettings.Rating.allValues.count
            case .bondSektor: return PIBondSettings.Sektor.allValues.count
            case .bondPeriod: return PIBondSettings.Period.allValues.count
            case .bondAmor: return PIBondSettings.Amortizac.allValues.count
            case .bondVidk: return PIBondSettings.Vidkupona.allValues.count
            default: print("error"); return -1

        }
    }
    
    override func selectFilterRow(row: Int) {
        switch selectedFilter {
            case .bondOtrasl: PISettingsManager.sharedInstance.bond.otrasl = PIBondSettings.Otrasl.allValues[row]
            case .bondRating: PISettingsManager.sharedInstance.bond.rating = PIBondSettings.Rating.allValues[row]
            case .bondSektor: PISettingsManager.sharedInstance.bond.sektor = PIBondSettings.Sektor.allValues[row]
            case .bondPeriod: PISettingsManager.sharedInstance.bond.period = PIBondSettings.Period.allValues[row]
            case .bondAmor: PISettingsManager.sharedInstance.bond.amorticac = PIBondSettings.Amortizac.allValues[row]
            case .bondVidk: PISettingsManager.sharedInstance.bond.vidkupona = PIBondSettings.Vidkupona.allValues[row]
            default: print("error")
        }
    }
    
    override func selectedFilterRow() -> Int {
        switch selectedFilter {
            case .bondOtrasl: return PIBondSettings.Otrasl.allValues.indexOf(PISettingsManager.sharedInstance.bond.otrasl)!
            case .bondRating: return PIBondSettings.Rating.allValues.indexOf(PISettingsManager.sharedInstance.bond.rating)!
            case .bondSektor: return PIBondSettings.Sektor.allValues.indexOf(PISettingsManager.sharedInstance.bond.sektor)!
            case .bondPeriod: return PIBondSettings.Period.allValues.indexOf(PISettingsManager.sharedInstance.bond.period)!
            case .bondAmor: return PIBondSettings.Amortizac.allValues.indexOf(PISettingsManager.sharedInstance.bond.amorticac)!
            case .bondVidk: return PIBondSettings.Vidkupona.allValues.indexOf(PISettingsManager.sharedInstance.bond.vidkupona)!
            default: print("error"); return -1
        }
    }

}

class PIIndicesSettings: PISettings {
    
    override init() {
        super.init()
        self.datePeriod = .oneYear
    }
}

class PIWorldIndicesSettings: PISettings {

}

class PIRusIndicesSettings: PISettings {

}

class PIStockSettings: PISettings, NSCoding {
    
    
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
        coder.encodeObject(PISettingsManager.sharedInstance.stock.datePeriod.rawValue, forKey: "datePeriod")
        coder.encodeObject(PISettingsManager.sharedInstance.stock.specialisation.rawValue, forKey: "specialisation")
        coder.encodeObject(PISettingsManager.sharedInstance.stock.selectedSort.rawValue, forKey: "selectedSort")

    }
    
    
    override var filters:[Filters] {
        get { return [Filters.stockSpec]}
        set {}
    }
    


    override var sorts:[SortTypes] {
        get {
            return [SortTypes.changeUp, SortTypes.changeDown, SortTypes.capUp, SortTypes.capDown]
        }
        set {}
    }
    var specialisation:Specialisations = .all
    
    
    
    enum Specialisations: String {
        case all = ""
        case banks = "Банки"
        case engineeringIndustry = "Машиностроение"
        case ferrousMetals = "Металлургия"
        case oilGaz = "Нефть и газ"
        case foodIndustry = "Пищевая"
        case construction = "Строительство"
        case retail = "Потребительский сектор"
        case transportation = "Транспорт"
        case power = "Энергетика"
        case other = "Прочее"
        case miningIndustry = "Горнодобывающая"
        case development = "Девелопмент"
        case communicationIT = "Телеком медиа IT"
        case fertilizers = "Удобрения"
        case pharma = "Фармацевтика"
        case financialSector = "Финансовый сектор"
        case chemicalPetrochemicalIndustry = "Химия и нефтехимия"
        
        static let allValues = [all, banks, engineeringIndustry, ferrousMetals, oilGaz, foodIndustry, construction, retail, transportation, power, miningIndustry, development, communicationIT, fertilizers, pharma, financialSector, chemicalPetrochemicalIndustry, other]
        
      
        var description: String {
            if true {
                switch self {
                case .all: return "Ваще все"
                case .banks: return "Рептилойды"
                    //            case .lightIndustry: return "Other"
                case .engineeringIndustry: return "Аннунаки"
                case .ferrousMetals: return "Иллюминаты"
                case .oilGaz: return "Масоны"
                case .foodIndustry: return "Сайентологи"
                case .construction: return "Каббалисты"
                    //            case .communication: return "communication"
                case .retail: return "Восточные тамплиеры"
                case .transportation: return "Комитет 300"
                    //            case .finance: return "finance"
                    //            case .chemicalIndustry: return "chemicalIndustry"
                case .power: return "Дети Чубайса"
                case .miningIndustry: return "Чумазики"
                case .development: return "Прорабы"
                case .communicationIT: return "Очкастые"
                case .fertilizers: return "Запах успеха"
                case .pharma: return "Драгдиллеры"
                case .financialSector: return "Сионистские мудрецы"
                case .chemicalPetrochemicalIndustry: return "Варщики"
                case .other: return "И тому подобная фигня"
                }

            } else {
                switch self {
                case .all: return "all"
                case .banks: return "banks"
                    //            case .lightIndustry: return "Other"
                case .engineeringIndustry: return "engineeringIndustry"
                case .ferrousMetals: return "ferrousMetals"
                case .oilGaz: return "oilGaz"
                case .foodIndustry: return "foodIndustry"
                case .construction: return "construction"
                    //            case .communication: return "communication"
                case .retail: return "retail"
                case .transportation: return "transportation"
                    //            case .finance: return "finance"
                    //            case .chemicalIndustry: return "chemicalIndustry"
                case .power: return "power"
                case .other: return "other"
                case .miningIndustry: return "miningIndustry"
                case .development: return "development"
                case .communicationIT: return "communicationIT"
                case .fertilizers: return "fertilizers"
                case .pharma: return "pharma"
                case .financialSector: return "financialSector"
                case .chemicalPetrochemicalIndustry: return "chemicalPetrochemicalIndustry"
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
        PISettingsManager.sharedInstance.stock.specialisation = PIStockSettings.Specialisations.allValues[row]
    }
    
    override func selectedFilterRow() -> Int {
        return PIStockSettings.Specialisations.allValues.indexOf(PISettingsManager.sharedInstance.stock.specialisation)!
    }
    
}

enum Periods: Int {
    case fiveYears
    case threeYears
    case oneYear
    case oneMonth
    case oneWeek
    case oneDay
}

enum Section: String {
    case dashboard
    case stocksSection
    case currenciesSection
    case realEstatesSection
    case bondsSection
    case worldIndicesSection
    case indicesSection
    case rusIndicesSection
    case mutualFundsSection
    
    var description: String {
        switch self {
        case .dashboard: return "dashboard"
        case .stocksSection: return "Stocks"
        case .currenciesSection: return "Currencies"
        case .realEstatesSection: return "RealEstate"
        case .bondsSection: return "Bonds"
        case .worldIndicesSection: return "WorldIndices"
        case .rusIndicesSection: return "RusIndices"
        case .mutualFundsSection: return "MutualFunds"
        case .indicesSection: return "indices"
        }
    }
    
    
}


extension NSDate: Comparable { }

struct Set<T: Hashable> {
    typealias Element = T
    private var contents: [Element: Bool]
    
    init() {
        self.contents = [Element: Bool]()
    }
    
    /// The number of elements in the Set.
    var count: Int { return contents.count }
    
    /// Returns `true` if the Set is empty.
    var isEmpty: Bool { return contents.isEmpty }
    
    /// The elements of the Set as an array.
    var elements: [Element] { return Array(self.contents.keys) }
    
    /// Returns `true` if the Set contains `element`.
    func contains(element: Element) -> Bool {
        return contents[element] ?? false
    }
    
    /// Add `newElements` to the Set.
    mutating func add(newElements: Element...) {
        newElements.map { self.contents[$0] = true }
    }
    
    /// Remove `element` from the Set.
    mutating func remove(element: Element) -> Element? {
        return contents.removeValueForKey(element) != nil ? element : nil
    }
}

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