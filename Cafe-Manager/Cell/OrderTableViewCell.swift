//
//  ItemViewController.swift
//  Cafe-Manager
//
//  Created by dev on 5/8/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lbllStatus: UILabel!
    
    class var reuseIdentifier: String {
            return "OrderViewCellReusable"
        }
        
        class var nibName: String {
            return "OrderTableViewCell"
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
        func configXIB(order: Order) {
            switch order.status_code {
            case 0:
                lbllStatus.text = "Pending"
            case 1:
                lbllStatus.text = "Preparing"
            case 2:
                lbllStatus.text = "Ready"
            case 3:
                lbllStatus.text = "Done"
            case 4:
                lbllStatus.text = "Arriving"
            case 5:
                lbllStatus.text = "Cancelled"
            default:
                return
            }
            
            lblOrderID.text = order.orderID
            lblCustomerName.text = order.cust_name
        }
        
    }
