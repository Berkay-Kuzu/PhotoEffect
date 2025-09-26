//
//  AlertManager.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

class AlertManager {
   static func showAlert(title :String , message: String, destinationVC: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        destinationVC.present(alert, animated: true)
    }
}
