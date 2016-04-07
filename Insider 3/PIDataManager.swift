//
//  File.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 02.02.16.
//  Copyright © 2016 PKMR. All rights reserved.
//

import Foundation
import Gloss
import Alamofire
import Haneke

class PIDataManager {
    
    let url = "http://parusappnew.com/"
    
    func requestSection(section: Section, date_from:NSString, date_till: NSString, completion: (result: [TickerModel]) -> Void) {
        
        if #available(iOS 9.0, *) {
            Alamofire.Manager.sharedInstance.session.getAllTasksWithCompletionHandler { tasks in
                for task in tasks {
                    task.cancel()
                }
            }
        } else {
            print("Not iOS 9")
        }
        
        
        let cache = Shared.JSONCache
        let url = "\(self.url)?date_from=\(date_from)&date_till=\(date_till)&sections=\(section.description.lowercaseString)&limited=1".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let URL = NSURL(string:url!)!
        
        cache.fetch(URL: URL).onSuccess { json in
            
            let baseModel: BaseModel = BaseModel(json: json.dictionary)!
            completion(result: baseModel.Tickers)
        
            Alamofire.request(.GET, self.url, parameters: ["sections": section.description.lowercaseString,"date_from":date_from,"date_till":date_till, "limited":"1"]).responseJSON {response in
                
                if let data = response.result.value {
                    
                    let baseJSON: JSON = data as! JSON
                    let baseModel: BaseModel = BaseModel(json: baseJSON)!
                    
                    cache.set(value: JSONHaneke.Dictionary(data as! Dictionary), key: URL.absoluteString)
                    completion(result: baseModel.Tickers)
                    
                }
            }
            
            
        }.onFailure { (error) in
            
            Alamofire.request(.GET, self.url, parameters: ["sections": section.description.lowercaseString,"date_from":date_from,"date_till":date_till, "limited":"1"]).responseJSON {response in
                
                print(response.request?.URL)
                if let data = response.result.value {
                    
                    let baseJSON: JSON = data as! JSON
                    let baseModel: BaseModel = BaseModel(json: baseJSON)!
                    
                    
                    completion(result: baseModel.Tickers)
                    
                }
            }
            
            
        }
    }
    
    
    func fetchTicker(section: Section, dateFrom: NSString, dateTill: NSString, ticker: NSString, completion:
        (fetchedItems: TickerModel) -> Void) {
        
//        let cacheName = section.description + (dateFrom as String) + (dateTill as String) + (ticker as String)
            

            let cache = Shared.JSONCache
            let url = "\(self.url)?date_from=\(dateFrom)&date_till=\(dateTill)&sections=\(section.description)&tickers=\(ticker)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let URL = NSURL(string:url!)!
            
            
            cache.fetch(URL: URL).onSuccess { json in
                
                let baseModel: BaseModel = BaseModel(json: json.dictionary)!
                if baseModel.Tickers.count > 0 {
                    completion(fetchedItems:baseModel.Tickers[0])
                }

            }
    }
}
