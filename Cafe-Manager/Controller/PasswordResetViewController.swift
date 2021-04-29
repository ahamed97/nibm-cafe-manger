//
//  PasswordResetViewController.swift
//  Cafe-Manager
//
//  Created by dev on 4/29/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    @IBAction func BtnPReset(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: email.text!) { error in
          if let e = error {
              print(e)
              let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          } else {
              let alert = UIAlertController(title: "Info", message: "Password Reset Email sent", preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
        }
    }
    
}
