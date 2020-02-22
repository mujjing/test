//
//  UIViewControllerAlert.swift
//  JhTabProject
//
//  Created by Jh's MacbookPro on 2019/12/23.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String = "error", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
