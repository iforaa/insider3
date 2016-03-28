//
//  PIREFrostedVC.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 10.08.15.
//  Copyright (c) 2015 PKMR. All rights reserved.
//

import Foundation
import REFrostedViewController

class PIREFrostedVC: REFrostedViewController {

    
    override func awakeFromNib() {
        
        let nc = UINavigationController(rootViewController: self.storyboard!.instantiateViewControllerWithIdentifier("contentController") )
        
        self.contentViewController = nc
        self.menuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("menuController")
        print("yes")
    }
    

    
}
