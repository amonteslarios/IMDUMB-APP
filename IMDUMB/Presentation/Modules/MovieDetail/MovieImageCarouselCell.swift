//
//  MovieImageCarouselCell.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

final class MovieImageCarouselCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    func configure(with url: URL) {
        // Para el reto puedes dejar un placeholder o implementar carga de imagen simple.
        imageView.image = UIImage(systemName: "film")
    }

    func configurePlaceholder() {
        imageView.image = UIImage(systemName: "film")
    }
}
