//
//  UIImageView+Extension.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        activityIndicator.center = self.center

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
            }
        }
    }
}

