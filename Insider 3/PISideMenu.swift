//
//  PISideMenu.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 11.08.15.
//  Copyright (c) 2015 PKMR. All rights reserved.
//




import UIKit



class PISideMenu: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 0, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 7
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath) 

        if indexPath.row == 0 {
            cell.textLabel?.text = "Дэшборд"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Акции"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Валюта"
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "Недвижимость"
        } else if indexPath.row == 4 {
            cell.textLabel?.text = "Облигации"
        } else if indexPath.row == 5 {
            cell.textLabel?.text = "Индексы"
        } else if indexPath.row == 6 {
            cell.textLabel?.text = "Пифы"
        }

        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc:ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("contentController") as! ViewController
        
        switch indexPath.row {
            case 0:
                vc.settingsButton.enabled = false
                vc.sectionManager = PIDashboardManager()
                vc.settings = PISettingsManager.sharedInstance.dashboard
            case 1:
                vc.sectionManager = PIStocksManager()
                vc.settings = PISettingsManager.sharedInstance.stock
            case 2:
                vc.sectionManager = PICurrenciesManager()
                vc.settings = PISettingsManager.sharedInstance.currency
            case 3:
                vc.sectionManager = PIRealEstatesManager()
                vc.settings = PISettingsManager.sharedInstance.realEstate
            case 4:
                vc.sectionManager = PIBondsManager()
                vc.settings = PISettingsManager.sharedInstance.bond
            case 5:
                vc.sectionManager = PIIndicesManager()
                vc.settings = PISettingsManager.sharedInstance.indices
            case 6:
                vc.sectionManager = PIMutualFundsManager()
                vc.settings = PISettingsManager.sharedInstance.mutualFund
            default:
                print("rows more then 7")
        }
        
        vc.title = vc.settings.section.description
        
        let nc = UINavigationController(rootViewController: vc)
        
        self.frostedViewController.contentViewController = nc
        self.frostedViewController.hideMenuViewController()
        
        
    }
    

}
