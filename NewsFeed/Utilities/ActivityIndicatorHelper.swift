//
//  ActivityIndicatorHelper.swift
//  NewsFeed
//
//  Created by MacMini 20 on 8/26/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit

class ActivityIndicatorHelper {
  
  static var sharedInstance = ActivityIndicatorHelper()
  let baseView = UIView()
  let animationView = STSpotLoadView()
  
  init() {
  }

  func startLoader() {
    DispatchQueue.main.async {
        if let window = UIApplication.shared.keyWindow {
            self.baseView.frame = window.bounds
            self.baseView.backgroundColor = UIColor(white: 1, alpha: 0.2)
            window.addSubview(self.baseView)
            self.animationView.frame.size = CGSize(width: 70, height: 100)
            self.baseView.addSubview(self.animationView)
            self.animationView.center = self.baseView.center
            self.animationView.startAnimation()
            if let view = window.rootViewController?.view {
                view.endEditing(true)
            }
        }
    }
  }
  
  func stopLoader(_ animationStopped: (() -> Void)? = nil) {
    DispatchQueue.main.async {
        self.animationView.stopAnimation {
          self.baseView.removeFromSuperview()
          animationStopped?()
        }
    }
  }
}

