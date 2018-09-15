//
//  UIViewControllerExtension.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentSimpleAlertDialog(header: String, message: String) {
        let ac = UIAlertController(
            title: header,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        ac.addAction(UIAlertAction(
            title: "Close",
            style: UIAlertActionStyle.cancel,
            handler: nil))
        
        self.present(ac, animated: true, completion: nil)
    }
}
