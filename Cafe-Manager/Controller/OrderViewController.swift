//
//  OrderViewController.swift
//  Cafe-Manager
//
//  Created by dev on 5/8/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit
import Firebase

class OrderViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
let ref = Database.database().reference()
    @IBOutlet weak var tblOrders: UITableView!
    @IBOutlet weak var segTabs: UISegmentedControl!
    
    var orders: [Order] = []
    var filteredOrders: [Order] = []
    

    override func viewDidLoad() {
          super.viewDidLoad()
          tblOrders.register(UINib(nibName: OrderTableViewCell.nibName, bundle: nil), forCellReuseIdentifier:OrderTableViewCell.reuseIdentifier)
        tblOrders.delegate = self
        tblOrders.dataSource = self
    }
      
    override func viewDidAppear(_ animated: Bool) {
          self.fetchOrders()
    }

    @IBAction func onStatusSegChanged(_ sender: UISegmentedControl) {
      filterOrders(status: sender.selectedSegmentIndex)
    }
    
    func filterOrders(status: Int) {
        filteredOrders.removeAll()
        filteredOrders = self.orders.filter {$0.status_code == status}
        tblOrders.reloadData()
    }
    
    func fetchOrders() {
        self.filteredOrders.removeAll()
        self.orders.removeAll()
        self.ref
            .child("orders")
            .observe(.value, with: {
                snapshot in
                self.filteredOrders.removeAll()
                self.orders.removeAll()
                if snapshot.hasChildren() {
                    guard let data = snapshot.value as? [String: Any] else {
                        return
                    }
                    
                    for order in data {
                        if let orderInfo = order.value as? [String: Any] {
                            
                            var singleOrder = Order(orderID: order.key,
                                                    cust_email: orderInfo["cust_email"] as! String,
                                                    cust_name: orderInfo["cust_name"] as! String,
                                                    date: orderInfo["date"] as! Double,
                                                    status_code: orderInfo["status"] as! Int)
                            
                            if let orderItems = orderInfo["orderItems"] as? [String: Any] {
                                for item in orderItems {
                                    if let singleItem = item.value as? [String: Any] {
                                        singleOrder.orderItems.append(
                                            OrderItem(item_name: singleItem["foodName"] as! String,
                                                      price: singleItem["foodPrice"] as! Double))
                                    }
                                }
                            }
                            
                            self.orders.append(singleOrder)
                        }
                    }
                    
                    self.filteredOrders.append(contentsOf: self.orders)
                    self.onStatusSegChanged(self.segTabs)
                } else {
                    let alert = UIAlertController(title: "Info", message: "No Orders", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOrders.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as! OrderTableViewCell
        cell.selectionStyle = .none
        cell.configXIB(order: filteredOrders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}


