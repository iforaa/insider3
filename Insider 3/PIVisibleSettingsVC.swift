//
//  PIVisibleSettingsVC.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 11.01.16.
//  Copyright © 2016 PKMR. All rights reserved.
//

import UIKit

class PIVisibleSettingsVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var selectDeselectAll: UIBarButtonItem!
    var sectionManager:PISectionManager = PISectionManager()
//    var section:Section?
    var isSelected: Bool = true
    
    let itemCellIdentifier = "ItemCell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        self.searchBar.delegate = self
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
        return self.sectionManager.count()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(itemCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = self.sectionManager.ticker(indexPath.row)
        
        if self.sectionManager.getTicker(indexPath.row).Show == true {//self.sectionManager.inExludeList(self.sectionManager.getTicker(indexPath.row)) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let ticker = self.sectionManager.getTicker(indexPath.row)
        self.sectionManager.switchVisibility(indexPath.row)
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
        
        self.sectionManager.switchVisibilityForAll(isSelected)
        self.tableView.reloadData()
    }
    

    
    let showVisibleSettingsSegue = "showVisibleSettingsSegue"
    
    
    override func viewWillDisappear(animated: Bool) {
        self.sectionManager.withSettings = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.sectionManager.searchFilterText = searchText
        self.tableView.reloadData()
        
        if searchText.characters.count == 0 {
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}