//
//  UIImageView+.swift
//  Gutenberg
//
//  Created by MacMini 20 on 8/26/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CusomImageView: UIImageView {
    var imageUrlString: String?

    func setUpImage(using urlString: String) {
        image = nil
        imageUrlString = urlString
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = imageFromCache
            return
        }

        let url = URL(string: urlString)!
        let urlTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error occured")
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache as AnyObject, forKey: urlString as AnyObject)
                if self?.imageUrlString == urlString {
                    self?.image = imageToCache
                }
            }
        }
        urlTask.resume()
    }
}
