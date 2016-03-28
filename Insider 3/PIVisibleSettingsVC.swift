//
//  PIVisibleSettingsVC.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 11.01.16.
//  Copyright © 2016 PKMR. All rights reserved.
//

import UIKit

class PIVisibleSettingsVC: UITableViewController {
    
    @IBOutlet weak var selectDeselectAll: UIBarButtonItem!
    var manager:PISectionManager = PISectionManager()
//    var section:Section?
    var isSelected: Bool = true
    
    let itemCellIdentifier = "ItemCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return self.manager.count()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(itemCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = manager.ticker(indexPath.row)
        if manager.inExludeList(manager.getTicker(indexPath.row)) {
            cell.accessoryType = .None
        } else {
            cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ticker = manager.getTicker(indexPath.row)
        manager.switchVisibility(ticker)
        self.tableView.reloadData()
    }

    
    @IBAction func tapSelectDeselectAll(sender: AnyObject) {
        if isSelected {
            selectDeselectAll.title = "Deselect all"
            isSelected = false
        } else {
            selectDeselectAll.title = "Select all"
            isSelected = true
        }
        
        manager.switchVisibilityForAll(isSelected)
        self.tableView.reloadData()
    }
    

    
    let showVisibleSettingsSegue = "showVisibleSettingsSegue"
    
    
    override func viewWillDisappear(animated: Bool) {
        self.manager.withSettings = true
    }

}