//
//  AppUtil.swift
//  StockStocker
//
//  Created by MacMini 20 on 8/12/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//
import UIKit
class AppUtil {
    class func showMessage(_ messageText:String, messageTitle:String, buttonTitle:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: messageTitle, message: messageText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
            var topVC = UIApplication.shared.keyWindow?.rootViewController
            while((topVC!.presentedViewController) != nil){
                 topVC = topVC!.presentedViewController
            }
            topVC?.present(alert, animated: true, completion: nil)
        }
    }
    
}
