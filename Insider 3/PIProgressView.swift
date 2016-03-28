//
//  PIProgressView.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 29.02.16.
//  Copyright © 2016 PKMR. All rights reserved.
//

import Foundation
import MBProgressHUD


class PIProgressView {
    
    let view:UIView?
    var loadingNotification:MBProgressHUD = MBProgressHUD()
    
    init(_ view: UIView) {
        self.view = view

    }
    
    func show() {
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
    }
    
    func hide() {
        loadingNotification.hide(true)
    }

    func hideWithError() {
        loadingNotification.labelText = "no tickers yet"
        loadingNotification.hide(true, afterDelay: 2)
    }
    
}