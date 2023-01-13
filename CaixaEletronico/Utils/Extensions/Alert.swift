//
//  Alert.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/13/23.
//

import UIKit

extension UIAlertController {

    static func basicAlert(viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)

        alertController.addAction(action)
        viewController.present(alertController, animated: true)
    }
}
