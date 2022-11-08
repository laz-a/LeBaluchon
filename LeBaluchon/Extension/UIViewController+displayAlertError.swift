//
//  UIViewController+.swift
//  LeBaluchon
//
//  Created by laz on 07/11/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func displayAlertError(message: String) {
        let errorAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        errorAlertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(errorAlertController, animated: true)
    }
}
