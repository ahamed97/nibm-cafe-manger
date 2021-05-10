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
        
    var orders: [Order] = []
    var filteredOrders: [Order] = []
    
    var selectedSagSt = 0

    override func viewDidLoad() {
          super.viewDidLoad()
          tblOrders.register(UINib(nibName: OrderTableViewCell.nibName, bundle: nil), forCellReuseIdentifier:OrderTableViewCell.reuseIdentifier)
        tblOrders.delegate = self
        tblOrders.dataSource = self
    }
      
    override func viewDidAppear(_ animated: Bool) {
          self.fetchOrders()
    }
    
    
    @IBAction func onStatusSegChange(_ sender: UISegmentedControl) {
        filterOrders(status: sender.selectedSegmentIndex)
        selectedSagSt = sender.selectedSegmentIndex
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
                    self.filterOrders(status: 0)
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        [UITableViewRowAction?]()
        let btnPreparing = UITableViewRowAction(style: .normal,title:"Preparing"){
            (rowAction,indexPath) in
            self.changeOrderStatus(orderId :self.filteredOrders[indexPath.row].orderID,status :1)
        }
        let btnReady = UITableViewRowAction(style: .normal,title:"Ready"){
            (rowAction,indexPath) in
            self.changeOrderStatus(orderId :self.filteredOrders[indexPath.row].orderID,status :2)
        }
        let btnDone = UITableViewRowAction(style: .normal,title:"Done"){
            (rowAction,indexPath) in
            self.changeOrderStatus(orderId :self.filteredOrders[indexPath.row].orderID,status :3)
        }
        let btnArrive = UITableViewRowAction(style: .normal,title:"Arrive"){
            (rowAction,indexPath) in
            self.changeOrderStatus(orderId :self.filteredOrders[indexPath.row].orderID,status :4)
        }
        let btnCancel = UITableViewRowAction(style: .normal,title:"Cancel"){
            (rowAction,indexPath) in
            self.changeOrderStatus(orderId :self.filteredOrders[indexPath.row].orderID,status :5)
        }
        let btnDelete = UITableViewRowAction(style: .normal,title:"Delete"){
            (rowAction,indexPath) in 
            self.deleteOrder(orderId :self.filteredOrders[indexPath.row].orderID)
        }
        btnPreparing.backgroundColor = UIColor.black
        btnReady.backgroundColor = UIColor.brown
        btnDone.backgroundColor = UIColor.systemIndigo
        btnArrive.backgroundColor = UIColor.gray
        btnCancel.backgroundColor = UIColor.red
        btnDelete.backgroundColor = UIColor.red
        
        if(selectedSagSt == 0){
            return [btnPreparing,btnCancel]
        }
        else if(selectedSagSt == 1){
            return [btnReady,btnCancel]
        }
        else if(selectedSagSt == 2){
            return [btnDone,btnCancel]
        }
        else if(selectedSagSt == 3){
            return [btnArrive,btnDelete]
        }
        else {
            return [btnDelete]
        }
    }
    
    func changeOrderStatus(orderId: String, status: Int) {
            ref
                .child("orders")
                .child(orderId)
                .child("status")
                .setValue(status) {
                    error, reference in
                    if error != nil {
    let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
                    }
                }
        filterOrders(status: status)
        }
    
    func deleteOrder(orderId: String) {
            ref
                .child("orders")
                .child(orderId)
                .removeValue() {
                                error, databaseReference in
                                if error != nil{
                                    if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                            }
                                }
                }
        filterOrders(status: 0)
        }
    
}


