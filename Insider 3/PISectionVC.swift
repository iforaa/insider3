//
//  ViewController.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 22.07.15.
//  Copyright (c) 2015 PKMR. All rights reserved.
//

import UIKit


extension ViewController: UIPopoverPresentationControllerDelegate {
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
        let nav = UINavigationController(rootViewController: controller.presentedViewController)
        nav.topViewController!.navigationItem.leftBarButtonItem = btnDone
        return nav
    }
    
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,PIDatesAndSortsViewDelegate, PIPopoverSortDelegate, PIPopoverFilterDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    var sectionManager: PISectionManager!
    var settings: PISettings!
    var progressView:PIProgressView?

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "TextCell"

    var currentSection:Section = .stocksSection//

    func selectManager(section:Section) {
        switch(section) {
        case .dashboard:
            self.settingsButton.enabled = false
            self.sectionManager = PIDashboardManager()
            self.settings = PISettingsManager.sharedInstance.dashboard
        case .stocksSection:
            self.sectionManager = PIStocksManager()
            self.settings = PISettingsManager.sharedInstance.stock
        case .currenciesSection:
            self.sectionManager = PICurrenciesManager()
            self.settings = PISettingsManager.sharedInstance.currency
        case .bondsSection:
            self.sectionManager = PIBondsManager()
            self.settings = PISettingsManager.sharedInstance.bond
        case .realEstatesSection:
            self.sectionManager = PIRealEstatesManager()
            self.settings = PISettingsManager.sharedInstance.realEstate
        case .indicesSection:
            self.sectionManager = PIIndicesManager()
            self.settings = PISettingsManager.sharedInstance.indices
        case .mutualFundsSection:
            self.sectionManager = PIMutualFundsManager()
            self.settings = PISettingsManager.sharedInstance.mutualFund
        default: print("Error in SectionVC")
        }
        self.sectionManager.section = section
        self.sectionManager.settings = self.settings
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.selectManager(currentSection)
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        
        self.progressView = PIProgressView(self.view)
        self.request()
        
        let datesAndSorts:PIDatesAndSortsView = PIDatesAndSortsView(frame: CGRectNull, sectionManager: self.sectionManager)
        datesAndSorts.delegate = self
        self.view.addSubview(datesAndSorts)
        datesAndSorts.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(65)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.searchBar.snp_top)
        }
        
        //self.searchBar.invalidateIntrinsicContentSize()
        //self.searchBar.sizeToFit()
        
//        self.searchBar.snp_updateConstraints { (make) in
//            
//            make.left.equalTo(self.view)
//            make.right.equalTo(self.view)
//            
//        }
//        
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.sectionManager.excludeControl()
        self.tableView.reloadData()
    }
    
    func prepareForSection(section: Section) {
        self.currentSection = section

    }
    
    
    @IBAction func showMenuAction(sender: AnyObject) {
        
        self.frostedViewController.presentMenuViewController()
        
    }
    
    @IBAction func showSettingsAction(sender: AnyObject) {
        
        
        
    }
    // переписать секшен контроллер на основе протоколов
    func request() {

        self.progressView?.show()
        self.sectionManager.requestInBackground() { (success) -> Void in
            if (success) {
                self.progressView?.hide()
                self.sectionManager.excludeControl()
                self.tableView.reloadData()
            } else {
                self.progressView?.hideWithError()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func makeSort() {
        self.sectionManager.sort()
        self.tableView.reloadData()
    }
    
    func makeFilter() {
        self.sectionManager.filter()
        self.tableView.reloadData()
    }
    
    
    func openPopover(sourceView: UIView, type: PopoverType) {
        var popoverVC:UIViewController
        
        
        

        if type == .sort {
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
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) 
        
        if let tickerLabel = cell.viewWithTag(100) as? UILabel {
            tickerLabel.text = self.sectionManager.ticker(indexPath.row) as String
        }
        
        if let rateLabel = cell.viewWithTag(101) as? UILabel {
            rateLabel.text = "\(self.sectionManager.currentRate(indexPath.row))"
        }
        
        if let changeLabel = cell.viewWithTag(102) as? UILabel {
            changeLabel.text = "\(self.sectionManager.change(indexPath.row))"
        }

        return cell
    }

    let showContentSegue = "showContentSegue"
    let showVisibleSettingsSegue = "showVisibleSettingsSegue"
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showContentSegue {
            if let destination = segue.destinationViewController as? PIContentVC {
                if let tickerIndex = tableView.indexPathForSelectedRow?.row {
                    self.sectionManager.selectedTickerNum = tickerIndex
                    destination.ticker = self.sectionManager.getSelectedTicker()
                    destination.manager = self.sectionManager                }
            }
        } else if segue.identifier == showVisibleSettingsSegue {
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
        self.sectionManager.sort()
        self.sectionManager.filter()
        self.tableView.reloadData()
    }
}

