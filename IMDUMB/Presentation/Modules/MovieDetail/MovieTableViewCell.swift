//
//  MovieTableViewCell.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {

    static let rowHeight: CGFloat = 120

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImage.contentMode = .scaleAspectFill
        posterImage.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = nil
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = String(format: "%.1f", movie.rating)

        if let url = movie.posterURL {
            posterImage.setImage(from: url)
        } else {
            posterImage.image = UIImage(systemName: "photo")
        }
    }
}
