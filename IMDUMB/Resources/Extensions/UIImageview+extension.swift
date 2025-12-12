//
//  UIImageview+extension.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

private let imageCache = NSCache<NSURL, UIImage>()

extension UIImageView {
    func setImage(from url: URL) {
        // Si ya está cacheada, úsala
        if let cached = imageCache.object(forKey: url as NSURL) {
            self.image = cached
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data)
            else { return }

            imageCache.setObject(image, forKey: url as NSURL)

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
