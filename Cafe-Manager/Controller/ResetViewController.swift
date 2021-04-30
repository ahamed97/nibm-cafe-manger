//
//  ResetViewController.swift
//  Cafe-Manager
//
//  Created by dev on 4/30/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit
import Firebase

class ResetViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBAction func BtnPReset(_ sender: UIButton) {
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            let alert = UIAlertController(title: "Error", message: "Email required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
        else{
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
}
