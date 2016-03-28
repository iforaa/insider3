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
        
        
        
        if indexPath.row == 0 {
            vc.prepareForSection(.dashboard)
            vc.title = "Дэшборд"
        } else if indexPath.row == 1 {
            vc.prepareForSection(.stocksSection)
            vc.title = "Акции"
        } else if indexPath.row == 2 {
            vc.prepareForSection(.currenciesSection)
            vc.title = "Валюта"
        } else if indexPath.row == 3 {
            vc.prepareForSection(.realEstatesSection)
            vc.title = "Недвижимость"
        } else if indexPath.row == 4 {
            vc.prepareForSection(.bondsSection)
            vc.title = "Облигации"
        } else if indexPath.row == 5 {
            vc.prepareForSection(.indicesSection)
            vc.title = "Индексы"
        } else if indexPath.row == 6 {
            vc.prepareForSection(.mutualFundsSection)
            vc.title = "Пифы"
        }
      
        let nc = UINavigationController(rootViewController: vc)
        
        
        
        self.frostedViewController.contentViewController = nc
        self.frostedViewController.hideMenuViewController()
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
