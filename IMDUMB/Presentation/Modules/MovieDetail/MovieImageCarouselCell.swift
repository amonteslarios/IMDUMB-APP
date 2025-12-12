//
//  MovieImageCarouselCell.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

final class MovieImageCarouselCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    private var loadId: UUID?

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if let loadId { ImageLoader.shared.cancel(loadId) }
        loadId = nil
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 8
    }

    func configure(with url: URL) {
        imageView.image = UIImage(systemName: "photo")

        loadId = ImageLoader.shared.load(url) { [weak self] image in
            self?.imageView.image = image ?? UIImage(systemName: "photo")
        }
    }

    func configurePlaceholder() {
        imageView.image = UIImage(systemName: "photo")
    }
}
