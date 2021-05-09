//
//  StoreViewController.swift
//  Cafe-Manager
//
//  Created by dev on 5/3/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    var tabBarContainer: UITabBarController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedViewSag" {
            self.tabBarContainer = segue.destination as? UITabBarController
            
        }
        self.tabBarContainer?.tabBar.isHidden = true
    }
    @IBAction func onSegIndexChange(_ sender: UISegmentedControl) {
        tabBarContainer?.selectedIndex = sender.selectedSegmentIndex
    }
    

}
