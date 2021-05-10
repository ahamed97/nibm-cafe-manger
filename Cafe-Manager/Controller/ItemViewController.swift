//
//  ItemViewController.swift
//  Cafe-Manager
//
//  Created by dev on 5/8/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ItemViewController: UIViewController {
    
    @IBOutlet weak var txtFoodName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var imgFood: UIImageView!

    
    let databaseReference = Database.database().reference()
    
    var categoryPicker = UIPickerView()
    var selectedCategoryIndex = 0
    var categoryList: [Category] = []
    
    var selectedImage: UIImage?
    var imagePicker: ImagePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.onPickImageClicked))
        self.imgFood.isUserInteractionEnabled = true
        self.imgFood.addGestureRecognizer(gesture)
        self.refreshCategories()
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        if txtFoodName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            let alert = UIAlertController(title: "Error", message: "All fields required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
        
        let foodItem = FoodItem(
            _id: "",
            foodName: txtFoodName.text ?? "",
            foodDescription: txtDescription.text ?? "",
            foodPrice: Double(txtPrice.text ?? "") ?? 0,
            discount: Int(txtDiscount.text ?? "") ?? 0,
            image: "",
            category: categoryList[selectedCategoryIndex].categoryName,
            isActive: true)
        
        self.addFoodItem(foodItem: foodItem)
    }
    
    @objc func onPickImageClicked(_ sender: UIImageView){
            self.imagePicker.present(from: sender)
        }
    }

    extension ItemViewController {
        
        func addFoodItem(foodItem: FoodItem) {
            
            guard let image = self.selectedImage else {
                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let uploadData = image.jpegData(compressionQuality: 0.5) {
                
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                
                Storage.storage().reference().child("foodItemImages").child(foodItem.foodName).putData(uploadData, metadata: metaData) {
                    meta, error in
                    
                    if let error = error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    Storage.storage().reference().child("foodItemImages").child(foodItem.foodName).downloadURL(completion: {
                        (url,error) in
                        guard let downloadURL = url else {
                            if let error = error {
                                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            return
                        }
                        
                        let data = [
                            "food_name" : foodItem.foodName,
                            "description" : foodItem.foodDescription,
                            "price" : foodItem.foodPrice,
                            "discount" : foodItem.discount,
                            "category" : foodItem.category,
                            "isActive" : foodItem.isActive,
                            "image" : downloadURL.absoluteString
                        ] as [String : Any]
                        
                        self.databaseReference
                            .child("foodItems")
                            .childByAutoId()
                            .setValue(data) {
                                error, ref in
                                if let error = error {
                                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    let alert = UIAlertController(title: "Info", message: "Food Added", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        
                    })
                }
            }
            
        }
        
        func refreshCategories() {
            self.categoryList.removeAll()
            databaseReference
                .child("categories")
                .observeSingleEvent(of: .value, with: {
                    snapshot in
                    if snapshot.hasChildren() {
                        guard let data = snapshot.value as? [String: Any] else {
                            return
                        }
                        
                        for category in data {
                            if let categoryInfo = category.value as? [String: String] {
                                self.categoryList.append(Category(categoryID: category.key, categoryName: categoryInfo["name"]!))
                            }
                        }
                        self.setupCategoryPicker()
                    }
                })
        }
    }

    extension ItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        func setupCategoryPicker() {
            let pickerToolBar = UIToolbar()
            pickerToolBar.sizeToFit()
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onPickerCancelled))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            pickerToolBar.setItems([space, cancelButton], animated: true)
            
            txtCategory.inputAccessoryView = pickerToolBar
            txtCategory.inputView = categoryPicker
            categoryPicker.delegate = self
            categoryPicker.dataSource = self
        }
        
        @objc func onPickerCancelled() {
            self.view.endEditing(true)
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return categoryList.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return categoryList[row].categoryName
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            txtCategory.text = categoryList[row].categoryName
            selectedCategoryIndex = row
        }
    }

    extension ItemViewController: ImagePickerDelegate {
        func didSelect(image: UIImage?) {
            self.imgFood.image = image
            self.selectedImage = image
        }
    }

