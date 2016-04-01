//
//  PIJSONModels.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 01.02.16.
//  Copyright © 2016 PKMR. All rights reserved.
//

import Foundation
import Gloss

protocol TickerModel {
    var Key: String {get set} // ключ для запросов
    var Title: String {get set}
    var CurrentRate: Float {get set}
    var Change: Float {get set}
    var ID: String {get set}
    var Items:[ItemModel] {get set}
    var section: Section {get}
    var Show: Bool {get set}

}

class DashboardTickerModel:NSObject, TickerModel, NSCoding {
    var Key: String = ""
    var Title: String = ""
    var CurrentRate: Float = 0.0
    var Change: Float = 0.0
    var ID: String = ""
    var Items:[ItemModel] = []
    var section: Section
    var Show: Bool = true
    
    
    init(key:String, title:String, section: Section, ID: String) {
        self.Key = key
        self.Title = title
        self.section = section
        self.ID = ID
        
        self.CurrentRate = 0
        self.Change = 0
        self.Items = []
        self.Show = true
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init(key:"", title:"", section:.dashboard, ID:"")
        self.Key = decoder.decodeObjectForKey("Key") as! String
        self.Title = decoder.decodeObjectForKey("Title") as! String
        self.section = Section(rawValue: (decoder.decodeObjectForKey("Section") as! String))!
        self.ID = decoder.decodeObjectForKey("ID") as! String
        
        self.CurrentRate = 0
        self.Change = 0
        self.Items = []
        self.Show = true
    }

    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.Key, forKey: "Key")
        coder.encodeObject(self.Title, forKey: "Title")
        coder.encodeObject(self.section.rawValue, forKey: "Section")
        coder.encodeObject(self.ID, forKey: "ID")
    }

}

protocol ItemModel {
    var Date: NSDate {get set}
    var Rate: Float {get set}
    var Change: Float {get set}
}

struct BaseModel: Decodable {
    var Error: String?
    
    
    
    var Tickers: [TickerModel] = []
    var Stocks: [StockTickerModel]?
    var Currencies: [CurrencyTickerModel]?

    var RealEstates: [RealEstateTickerModel]?
    var Bonds: [BondTickerModel]?
    var WorldIndices: [WorldIndicesTickerModel]?
    var RusIndices: [RusIndicesTickerModel]?
    var MutualFunds: [MutualFundTickerModel]?

    
    init?(json: JSON) {
        self.Error = "Error" <~~ json
        
        self.Stocks = "Stocks" <~~ json
        self.Currencies = "Currencies" <~~ json
        self.RealEstates = "RealEstate" <~~ json
        self.Bonds = "Bonds" <~~ json
        self.WorldIndices = "WorldIndices" <~~ json
        self.RusIndices = "RusIndices" <~~ json
        self.MutualFunds = "MutualFunds" <~~ json

        
        if (self.Stocks != nil) {
            for ticker in self.Stocks! {
                self.Tickers.append(ticker)
            }
        } else if (self.Currencies != nil) {
            for ticker in self.Currencies! {
                self.Tickers.append(ticker)
            }
        } else if (self.RealEstates != nil) {
            for ticker in self.RealEstates! {
                self.Tickers.append(ticker)
            }
        } else if (self.Bonds != nil) {
            for ticker in self.Bonds! {
                self.Tickers.append(ticker)
            }
        } else if (self.WorldIndices != nil) {
            for ticker in self.WorldIndices! {
                self.Tickers.append(ticker)
            }
        } else if (self.RusIndices != nil) {
            for ticker in self.RusIndices! {
                self.Tickers.append(ticker)
            }
        } else if (self.MutualFunds != nil) {
            for ticker in self.MutualFunds! {
                self.Tickers.append(ticker)
            }
        }
        
    }
}

  
struct StockTickerModel: Decodable, TickerModel {
    

    var Title: String = ""
    var Key: String = ""
    var CurrentRate: Float = 0
    var Change: Float = 0
    var ID: String = ""
    var Items:[ItemModel] = []
    var realItems: [StockItemModel]?
    
    let LongTicker: String?
    let ShortTicker: String?
    var Specialisation: PIStockSettings.Specialisations?
    var EmitionCount: Double?
    var Capitalisation: Double = 0.0
    let Pairs: String?
    let MFDTicker: String?
    let InvestFundsTicker: String?
    var section: Section = .stocksSection
    var Show: Bool = true
    
    
    

    init?(json: JSON) {
        self.ID = ("ID" <~~ json)!
        self.realItems = "Items" <~~ json

        for item in self.realItems! {
            self.Items.append(item)
        }
        
        self.Title = ("Ticker" <~~ json)!
        self.Key = self.Title
        self.CurrentRate = self.Items[0].Rate
        self.Change = Decoder.decodeStringToFloat("ChangeRel")(json)!
        
        self.LongTicker = "LongTicker" <~~ json
        self.ShortTicker = "ShortTicker" <~~ json
        self.Specialisation = "Specialisation" <~~ json
       
        if self.Specialisation == nil {
            self.Specialisation = .other
        }
        
        self.EmitionCount = Decoder.decodeStringToDouble("EmitionCount")(json)
        self.Pairs = "Pairs" <~~ json
        self.MFDTicker = "MFDTicker" <~~ json
        self.InvestFundsTicker = "InvestFundsTicker" <~~ json
        
        
        if let ec = self.EmitionCount {
            self.Capitalisation =  Double(self.CurrentRate) * ec
        } else {

        }
    }
}



struct StockItemModel: Decodable, ItemModel {
    
    var Date: NSDate = NSDate()
    var Rate: Float = 0
    var Change: Float = 0
    var ChangeAbs: Float?
    var Time: String?


    
    init?(json: JSON) {
        let formatter = NSDateFormatter();
        formatter.dateFormat = "dd.MM.yyyy";
        
        self.Date = Decoder.decodeDate("Date", dateFormatter: formatter)(json)!
        self.Rate = Decoder.decodeStringToFloat("Rate")(json)!
        self.Change = Decoder.decodeStringToFloat("ChangeRel")(json)!
        self.ChangeAbs = Decoder.decodeStringToFloat("ChangeAbs")(json)
        self.Time = "Time" <~~ json
    }
}

struct CurrencyTickerModel: Decodable, TickerModel {
    var ID: String = ""
    var Title: String = ""
    var Key: String = ""
    var CurrentRate: Float = 0
    var Change: Float = 0
    var Items: [ItemModel] = []
    var realItems: [CurrencyItemModel]?
    let section: Section = .currenciesSection
    
    let RusName: String?
    let EngName: String?
    
    var Show: Bool = true


    
    init?(json: JSON) {
        self.ID = ("Ticker" <~~ json)!
        self.Key = self.ID
        self.Title = ("RusName" <~~ json)!
        self.RusName = "RusName" <~~ json
        self.EngName = "EngName" <~~ json
        self.realItems = "Items" <~~ json
        for item in self.realItems! {
            self.Items.append(item)
        }
        
        self.CurrentRate = self.Items[0].Rate
        self.Change = Decoder.decodeStringToFloat("ChangeRel")(json)!
    }
}

struct CurrencyItemModel: Decodable, ItemModel {
    
    
    var Date: NSDate = NSDate()
    var Rate: Float = 0
    var Change: Float = 0
  
    var Nominal:Float?
    

    init?(json: JSON) {
        let formatter = NSDateFormatter();
        formatter.dateFormat = "dd.MM.yyyy";
        
        self.Date = Decoder.decodeDate("Date", dateFormatter: formatter)(json)!
        self.Rate = Decoder.decodeStringToFloat("Value")(json)!
        self.Nominal = Decoder.decodeStringToFloat("Nominal")(json)
        
    }
}



struct RealEstateTickerModel: Decodable, TickerModel {
    var Key: String = ""
    var Title: String = ""
    var CurrentRate: Float = 0
    var Change: Float = 0
    var ID: String = ""
    var section: Section = .realEstatesSection
    var Show: Bool = true
    var Items: [ItemModel] = []
    var realItems: [RealEstateItemModel]?
    
    init?(json: JSON) {
        self.realItems = "Items" <~~ json
        for item in self.realItems! {
            self.Items.append(item)
        }
        
        self.CurrentRate = self.Items[0].Rate
        self.Change = Decoder.decodeStringToFloat("ChangeRel")(json)!
        
        self.ID = ("ID" <~~ json)!
        self.Title = ("Ticker" <~~ json)!
        self.Key = self.Title

        
        
        
    }
    
}


struct RealEstateItemModel: Decodable, ItemModel {
    
    
    
    var Date: NSDate = NSDate()
    var Rate:Float = 0
    var Change: Float = 0
    
    init?(json: JSON) {
        let formatter = NSDateFormatter();
        formatter.dateFormat = "dd.MM.yyyy";
        self.Date = Decoder.decodeDate("Date", dateFormatter: formatter)(json)!
        self.Rate = Decoder.decodeStringToFloat("Value")(json)!
    
    }
}



struct BondTickerModel: Decodable, TickerModel {
    
    var ID: String = ""
    var Title: String = ""
    var Key: String = ""
    var CurrentRate: Float = 0
    var Change: Float = 0
    var Items: [ItemModel] = []
    var realItems: [BondItemModel]?
    let section: Section = .bondsSection
    var Show: Bool = true

    let Emitent: String?
    let MFDTicker: String?
    

    var Otrasl:PIBondSettings.Otrasl?
    var Rating: PIBondSettings.Rating?
    var Sektor: PIBondSettings.Sektor?
    var Period: PIBondSettings.Period?
    var Amorticac: PIBondSettings.Amortizac?
    var Vidkupona: PIBondSettings.Vidkupona?
    
    init?(json: JSON) {
        
        self.realItems = "Items" <~~ json
        for item in self.realItems! {
            self.Items.append(item)
        }
        self.Title = ("Ticker" <~~ json)!
        self.Key = self.Title
        self.ID = ("ID" <~~ json)!
        
        self.Change = Decoder.decodeStringToFloat("ChangeRel")(json)!
        self.CurrentRate = self.Items[0].Rate
        self.Emitent = "Emitent" <~~ json
        self.MFDTicker = "MFDTicker" <~~ json
        
        
        
        self.Otrasl = "Otrasl" <~~ json
        self.Rating = "Rating" <~~ json
        self.Sektor = "Sektor" <~~ json
        self.Period = "Period" <~~ json
        self.Amorticac = "Amorticac" <~~ json
        self.Vidkupona = "Vidkupona" <~~ json

    
        
    }
}

struct BondItemModel: Decodable, ItemModel {
    var Date: NSDate = NSDate()
    var Rate: Float = 0
    var Change: Float = 0
    
    let MaturityDate: String?
    let ChangeAbs:Float?
    let Yield:Float?
    let DayValue:Float?
    let Time: String?
    let coupon: String?
    
    
    init?(json: JSON) {
        self.Rate = Decoder.decodeStringToFloat("Rate")(json)!
        self.Change = Decoder.decodeStringToFloat("ChangeRel")(json)!
        self.ChangeAbs = Decoder.decodeStringToFloat("ChangeAbs")(json)
        self.MaturityDate = "MaturityDate" <~~ json
        self.Yield = Decoder.decodeStringToFloat("Yield")(json)
        self.DayValue = Decoder.decodeStringToFloat("DayValue")(json)
        self.Time = "Time" <~~ json
        self.coupon = "coupon" <~~ json

        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "dd.MM.yyyy";
        self.Date = Decoder.decodeDate("Date", dateFormatter: formatter)(json)!
    
    }
    
}

struct WorldIndicesTickerModel: Decodable, TickerModel {
    var ID: String = ""
    var Title: String = ""
    var Key: String = ""
    var CurrentRate: Float = 0
    var Change: Float = 0
    let section: Section = .worldIndicesSection
    var Show: Bool = true
    var Items: [ItemModel] = []
    var realItems: [WorldIndicesItemModel]?
    
    
    init?(json: JSON) {

        self.realItems = "Items" <~~ json
        for item in self.realItems! {
            self.Items.append(item)
        }
        
        self.CurrentRate = self.Items[0].Rate
        self.Change = Decoder.decodeStringToFloat("ChangeRel")(json)!
        
        self.ID = ("ID" <~~ json)!
        self.Title = ("Ticker" <~~ json)!
        self.Key = self.Title
        
    }
}

struct WorldIndicesItemModel: Decodable, ItemModel {
    
    var Date: NSDate = NSDate()
    var Rate: Float = 0
    var Change: Float = 0
    
    init?(json: JSON) {
        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "dd.MM.yyyy";
        
        self.Date = Decoder.decodeDate("Date", dateFormatter: formatter)(json)!
        self.Rate = Decoder.decodeStringToFloat("Last")(json)!

        
        
    }
}



struct RusIndicesTickerModel: Decodable, TickerModel {

    var ID: String = ""
    var Title: String = ""
    var Key: String = ""
    var CurrentRate: Float = 0
    var Change: Float = 0
    let section: Section = .rusIndicesSection
    var Show: Bool = true
    var Items: [ItemModel] = []
    var realItems: [RusIndicesItemModel]?

    
    init?(json: JSON) {
        self.realItems = "Items" <~~ json
        for item in self.realItems! {
            self.Items.append(item)
        }
        
        self.CurrentRate = self.Items[0].Rate
        self.Change = Decoder.decodeStringToFloat("ChangeRel")(json)!
        
        self.ID = ("ID" <~~ json)!
        self.Title = ("Ticker" <~~ json)!
        self.Key = self.Title
    }
    
}

struct RusIndicesItemModel: Decodable, ItemModel {
    var Date: NSDate = NSDate()
    var Rate: Float = 0
    var Change: Float = 0
    
    init?(json: JSON) {
        let formatter = NSDateFormatter();
        formatter.dateFormat = "dd.MM.yyyy";
        
        self.Date = Decoder.decodeDate("Date", dateFormatter: formatter)(json)!
        self.Rate = Decoder.decodeStringToFloat("Rate")(json)!
    }
    
    
}


struct MutualFundTickerModel: Decodable, TickerModel {
    
    var Key: String = ""
    var Title: String = ""
    var CurrentRate: Float = 0.0
    var Change: Float = 0.0
    var ID: String = ""
    var Items:[ItemModel] = []
    var realItems: [MutualFundItemModel]?
    var section: Section = .mutualFundsSection
    var Show: Bool = true
    
    let Fundtype: PIMutualFundSettings.FundType?
    let Fundcat: PIMutualFundSettings.FundCat?
    
    
    
    init?(json: JSON) {
        
        self.realItems = "Items" <~~ json
        for item in self.realItems! {
            self.Items.append(item)
        }
        
        
        if let name = self.realItems![0].Fundname {
            self.Title = name
        }
        
        
        self.CurrentRate = self.realItems![0].Rate
        self.Change = self.realItems![0].Change
        self.ID = self.realItems![0].url!
        
        if let ft = self.realItems![0].Fundtype {
            self.Fundtype = ft
        } else {
            self.Fundtype = .None
        }
        
        if let fc = self.realItems![0].Fundcat {
            self.Fundcat = fc
        } else {
            self.Fundcat = .None
        }
    
    }
    
}

struct MutualFundItemModel: Decodable, ItemModel {
    
    var Date: NSDate = NSDate()
    var Rate: Float = 0.0
    var Change: Float = 0.0
    
    let Fundname: String?
    let Ukname: String?
    let Fundtype: PIMutualFundSettings.FundType?
    let Fundcat: PIMutualFundSettings.FundCat?
    let Registrationdate: String?
    let Startformirdate: String?
    let Endformirdate: String?
    let Minsumminvest:Float?
    let Stpaya:Float?
    let Scha:Float?
    let Proc_day:Float?
    let Proc_week:Float?
    let Proc_month1:Float?
    let Proc_month3:Float?
    let Proc_month6:Float?
    let Proc_year1:Float?
    let Proc_year3:Float?
    let Proc_year5:Float?
    let Proc_all:Float?
    let Proc_beginYear2Now:Float?
    let url: String?
    let fundid: String?
    let ukid: String?
    
    init?(json: JSON) {
        
        self.Fundname = "fundname" <~~ json
        self.Ukname = "ukname" <~~ json
        self.Fundtype = "fundtype" <~~ json
        self.Fundcat = "fundcat" <~~ json
        self.Registrationdate = "registrationdate" <~~ json
        self.Startformirdate = "startformirdate" <~~ json
        self.Endformirdate = "endformirdate" <~~ json
        self.Minsumminvest = Decoder.decodeStringToFloat("minsumminvest")(json)
        self.Stpaya = Decoder.decodeStringToFloat("stpaya")(json)
        self.Scha = Decoder.decodeStringToFloat("scha")(json)
        self.Proc_day = Decoder.decodeStringToFloat("proc_day")(json)
        self.Proc_week = Decoder.decodeStringToFloat("proc_week")(json)
        self.Proc_month1 = Decoder.decodeStringToFloat("proc_month1")(json)
        self.Proc_month3 = Decoder.decodeStringToFloat("proc_month3")(json)
        self.Proc_month6 = Decoder.decodeStringToFloat("proc_month6")(json)
        self.Proc_year1 = Decoder.decodeStringToFloat("proc_year1")(json)
        self.Proc_year3 = Decoder.decodeStringToFloat("proc_year3")(json)
        self.Proc_year5 = Decoder.decodeStringToFloat("proc_year5")(json)
        self.Proc_all = Decoder.decodeStringToFloat("proc_all")(json)
        self.Proc_beginYear2Now = Decoder.decodeStringToFloat("proc_beginYear2Now")(json)
        self.url = "url" <~~ json
        self.fundid = "fundid" <~~ json
        self.ukid = "ukid" <~~ json
        
        
        if let cr = self.Stpaya {
            self.Rate = cr
        }
        
        if let ch = self.Proc_month6 {
            self.Change = ch
        }

    }

}


extension Decoder {
    
    static func decodeStringToFloat(key: String) -> JSON -> Float? {
        return {
            json in
            
            if let float = json[key]?.floatValue {
                return float
            }
            
            return nil
        }
    }
    static func decodeStringToDouble(key: String) -> JSON -> Double? {
        return {
            json in
            
            if let double = json[key]?.doubleValue {
                return double
            }
            
            return nil
        }
    }
}
