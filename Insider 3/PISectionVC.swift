//
//  ViewController.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 22.07.15.
//  Copyright (c) 2015 PKMR. All rights reserved.
//

import UIKit


extension PISectionVC: UIPopoverPresentationControllerDelegate {
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
        let nav = UINavigationController(rootViewController: controller.presentedViewController)
        nav.topViewController!.navigationItem.leftBarButtonItem = btnDone
        return nav
    }
}

class PISectionVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PIDatesAndSortsViewDelegate, PIPopoverSortDelegate, PIPopoverFilterDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    var settings: PISettings = PIStockSettings()
    //PISettingsManager.sharedInstance.stock
    var sectionManager: PISectionManager = PIStocksManager()
    var progressView: PIProgressView?

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let textCellIdentifier = "TextCell"

    override func viewDidLoad() {

        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.progressView = PIProgressView(self.view)
        
        let datesAndSorts:PIDatesAndSortsView = PIDatesAndSortsView(settings: self.settings, true, false)
        datesAndSorts.delegate = self
        self.view.addSubview(datesAndSorts)
        datesAndSorts.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(65)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.searchBar.snp_top)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.settings.commit()
    }
    
    func request() {
        self.progressView?.show()
        self.sectionManager.requestInBackground(self.settings) { (success) -> Void in
            if (success) {
                self.progressView?.hide()
                self.sectionManager.excludeControl()
                self.tableView.reloadData()
            } else {
                self.progressView?.hideWithError()
            }
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.request()
        
    }
    
    
    @IBAction func showMenuAction(sender: AnyObject) {
        
        self.frostedViewController.presentMenuViewController()
        
    }
    
    @IBAction func showSettingsAction(sender: AnyObject) {
        
        
        
    }
    

    override func viewDidLayoutSubviews() {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func makeSort() {
        self.sectionManager.sort(self.settings)
        self.tableView.reloadData()
    }
    
    func makeFilter() {
        self.sectionManager.filter(self.settings)
        self.tableView.reloadData()
    }
    
    
    func openPopover(sourceView: UIView, type: PopoverType) {
        var popoverVC:UIViewController

        if type == .Sort {
            popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopoverVCSort")
            let vc:PopoverSortVC = popoverVC as! PopoverSortVC
            vc.delegate = self
            vc.settings = self.settings
            
            vc.modalPresentationStyle = UIModalPresentationStyle.Popover
            vc.popoverPresentationController!.delegate = self
            vc.popoverPresentationController!.sourceView = sourceView
            vc.popoverPresentationController!.sourceRect = sourceView.bounds
            vc.popoverPresentationController!.permittedArrowDirections = UIPopoverArrowDirection.Up
            
            presentViewController(vc, animated: true, completion: nil)
        } else {

            let vc:PopoverFilterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopoverVCFilter") as! PopoverFilterVC
            vc.modalPresentationStyle = UIModalPresentationStyle.Popover
            vc.popoverPresentationController!.delegate = self
            vc.popoverPresentationController!.sourceView = sourceView
            vc.popoverPresentationController!.sourceRect = sourceView.bounds
            vc.popoverPresentationController!.permittedArrowDirections = UIPopoverArrowDirection.Up
            vc.delegate = self
            vc.settings = self.settings
            presentViewController(vc, animated: true, completion: nil)
            
            
        }

    }
    
    func openPopover(popover: PopoverFilterVC) {
        self.dismissViewControllerAnimated(true, completion: {
            self.presentViewController(popover, animated: true, completion: nil)
        })
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionManager.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:PISectionViewCell? = tableView.dequeueReusableCellWithIdentifier("CELL") as? PISectionViewCell
        
        if cell == nil {
            cell = PISectionViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        cell!.title.text = self.sectionManager.ticker(indexPath.row) as String
        cell!.rate.text = "\(self.sectionManager.currentRate(indexPath.row))"
        cell!.change.text = "\(self.sectionManager.change(indexPath.row))"

        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let picontentVC = mainStoryboard.instantiateViewControllerWithIdentifier("PIContentVC") as! PIContentVC
        
        self.sectionManager.selectedTickerNum = indexPath.row
        picontentVC.ticker = self.sectionManager.getSelectedTicker()
        picontentVC.manager = self.sectionManager
        let contentSettings = PISettings()
        contentSettings.datePeriod = self.settings.datePeriod
        picontentVC.settings = contentSettings
        
        picontentVC.placeViews()
        picontentVC.request()
        
        
        self.navigationController?.pushViewController(picontentVC, animated: true)
    }

    let showContentSegue = "showContentSegue"
    let showVisibleSettingsSegue = "showVisibleSettingsSegue"
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showVisibleSettingsSegue {
            if let destination = segue.destinationViewController as? PIVisibleSettingsVC {
                destination.sectionManager = self.sectionManager
                destination.sectionManager.withSettings = false
                
            }
        }
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.sectionManager.searchFilterText = searchText
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.sectionManager.searchFilterText = nil
        self.sectionManager.sort(self.settings)
        self.sectionManager.filter(self.settings)
        self.tableView.reloadData()
    }
}

