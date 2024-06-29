//
//  UIImageView+LoadImage.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import UIKit

extension UIImageView {
    func loadImage(url: URL, completion: ((Data) -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                completion?(data)
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
