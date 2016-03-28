//
//  PIREFrostedNC.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 11.08.15.
//  Copyright (c) 2015 PKMR. All rights reserved.
//

import UIKit

class PIREFrostedNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let panGestureRecognizer = UIPanGestureRecognizer(target:self, action: "panGestureRecognized:")
        self.view.addGestureRecognizer(panGestureRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func panGestureRecognized(sender: UIPanGestureRecognizer) {
       // self.view.endEditing(true)
       // self.frostedViewController.view.endEditing(true)
       // self.frostedViewController.panGestureRecognized(sender)
    }
    
    
}
