//
//  ItemListViewController.swift
//  Cafe-Manager
//
//  Created by dev on 5/8/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit
import Firebase

class ItemListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,FoodItemCellActions {
    func onFoodItemStatusChanged(foodItem: FoodItem, status: Bool) {
        self.changeFoodStatus(foodItem: foodItem, status: status)
    }
    
@IBOutlet weak var tblFoodItems: UITableView!
    var ref = Database.database().reference()
    
    var FoodItemList: [FoodItem] = []
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.FoodItemList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblFoodItems.dequeueReusableCell(withIdentifier: FoodItemTableViewCell.reuseIdentifier, for: indexPath) as! FoodItemTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configXIB(foodItem: FoodItemList[indexPath.row], index: indexPath.row)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblFoodItems.register(UINib(nibName: FoodItemTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FoodItemTableViewCell.reuseIdentifier)
        tblFoodItems.delegate = self
        tblFoodItems.dataSource = self
        self.refreshFoodItems()
    }
    
    func refreshFoodItems() {
        self.FoodItemList.removeAll()
        ref.child("foodItems")
            .observeSingleEvent(of: .value, with: {
                    snapshot in
                    if snapshot.hasChildren() {
                        guard let data = snapshot.value as? [String: Any] else {
                            return
                        }
                        
                        for food in data {
                            if let foodInfo = food.value as? [String: Any] {
                                self.FoodItemList.append(
                                    FoodItem(
                                        _id: food.key,
                                        foodName: foodInfo["food_name"] as! String,
                                        foodDescription: foodInfo["description"] as! String,
                                        foodPrice: foodInfo["price"] as! Double,
                                        discount: foodInfo["discount"] as! Int,
                                        image: foodInfo["image"] as! String,
                                        category: foodInfo["category"] as! String,
                                        isActive: foodInfo["isActive"] as! Bool))
                            }
                    }
                        self.tblFoodItems.reloadData()
                }
        })
    }
    
    func changeFoodStatus(foodItem: FoodItem, status: Bool) {
        ref
            .child("foodItems")
            .child(foodItem._id)
            .child("isActive")
            .setValue(status) {
                error, reference in
                
                if error != nil {
let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
self.present(alert, animated: true, completion: nil)
                }
            }
    }
}

