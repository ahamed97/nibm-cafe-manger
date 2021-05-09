//
//  CategoryViewController.swift
//  Cafe-Manager
//
//  Created by dev on 5/6/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit
import Firebase

class CategoryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var ref = Database.database().reference()
    
    var CategoryList: [Category] = []

    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var txtCategory: UITextField!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.categoryName(category: CategoryList[indexPath.row])
                    return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                ref.child("categories")
                            .child(CategoryList[indexPath.row].categoryID)
                            .removeValue() {
                                error, databaseReference in
                                if error != nil{
                                    if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                            }
                                }
                                self.refreshCategories()
                        }
                
        }
    }
    
    
    @IBAction func btnAddCategory(_ sender: UIButton) {
        ref
        .child("categories")
        .childByAutoId()
        .child("name")
            .setValue(txtCategory.text) {
            error, ref in
            if let error = error {
    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
                }
            }
        
        self.refreshCategories()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshCategories()
    }
    
    func refreshCategories() {
        self.CategoryList.removeAll()
        ref.child("categories")
            .observeSingleEvent(of: .value, with: {
                    snapshot in
                    if snapshot.hasChildren() {
                        guard let data = snapshot.value as? [String: Any] else {
                            return
                        }
                        
                        for category in data {
                            if let categoryInfo = category.value as? [String: String] {
                                self.CategoryList.append(Category(categoryID: category.key, categoryName: categoryInfo["name"]!))
                        }
                    }
                        self.tableView.reloadData()
                }
        })
    }
    
    func categoryName(category: Category) -> String {
        return category.categoryName
    }
    
}

