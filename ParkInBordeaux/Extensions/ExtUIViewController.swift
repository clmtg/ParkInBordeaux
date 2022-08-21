//
//  ExtUIViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 19/08/2022.
//

import Foundation
import UIKit

//Extension of UIViewController to add ability to display an alert, dismiss the vitural keyboard and disable button if needed
extension UIViewController {
    /// Display an iOS alert to the user
    /// - Parameters:
    ///   - title: Alert's title
    ///   - message: Alert's message
    ///   - actions: List of action otpions which could be included within the alert. (By default = nil)
    func displayAnAlert(title: String, message: String, actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    /// Hide the iOS keyboard. When called the UITextField provided is no longer first responder
    /// - Parameter firstResponder:UITextField to make resign
    func dismissKeyboard(firstResponder: UITextField) {
        firstResponder.resignFirstResponder()
    }
}
