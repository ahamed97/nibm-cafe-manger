//
//  RegisterViewController.swift
//  Cafe-Manager
//
//  Created by dev on 4/29/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class RegisterViewController: UIViewController {

    var ref = Database.database().reference()
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    @IBAction func BtnRegister(_ sender: UIButton) {
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || phone.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            let alert = UIAlertController(title: "Error", message: "All fields required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
        else{
        if let email = email.text, let password = password.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let user = User(userEmail: email , userPassword: password , userPhone: self.phone.text ?? "")
                    let userData = [
                        "userEmail" : user.userEmail,
                        "userPhone" : user.userPhone,
                        "userPassword" : user.userPassword
                    ]
                    
                    self.ref.child("users")
                        .child(user.userEmail
                            .replacingOccurrences(of: "@", with: "_")
                            .replacingOccurrences(of: ".", with: "_")).setValue(userData) {
                    (error, ref) in
                    if let err = error {
                        print(err.localizedDescription)
                        let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.performSegue(withIdentifier: "RegisterToMainHome", sender: self)
                }
            }
        }
    }
    }
}
}
