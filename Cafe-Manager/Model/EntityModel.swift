//
//  MainHomeViewController.swift
//  Cafe-Manager
//
//  Created by dev on 5/2/21.
//  Copyright © 2021 dev. All rights reserved.
//

import Foundation

struct User{
    var userEmail: String
    var userPassword: String
    var userPhone: String
    
}
struct FoodItem{
    var _id: String
    var foodName: String
    var foodDescription: String
    var foodPrice: Double
    var discount: Int
    var image: String
    var category: String
    var isActive: Bool
}

struct Category {
    var categoryID: String
    var categoryName: String
    }

struct Order {
    var orderID: String
    var cust_email: String
    var cust_name: String
    var date: Double
    var status_code: Int
    var orderItems: [OrderItem] = []
}

struct OrderItem {
    var item_name: String
    var price: Double
}
