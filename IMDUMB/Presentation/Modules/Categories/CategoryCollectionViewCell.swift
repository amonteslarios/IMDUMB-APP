//
//  CategoryCollectionViewCell.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

protocol CategoryCellDelegate: AnyObject {
    func didSelect(movie: Movie)
}

final class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!

    private var movies: [Movie] = []
    weak var delegate: CategoryCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = MovieTableViewCell.rowHeight
        tableView.estimatedRowHeight = MovieTableViewCell.rowHeight
        tableView.register(
            UINib(nibName: "MovieTableViewCell", bundle: nil),
            forCellReuseIdentifier: "MovieTableViewCell"
        )
    }

    func configure(with category: MovieCategory, delegate: CategoryCellDelegate?) {
        titleLabel.text = category.name
        movies = category.movies
        self.delegate = delegate
        tableView.reloadData()
        let totalHeight = CGFloat(movies.count) * MovieTableViewCell.rowHeight
          tableHeightConstraint.constant = totalHeight        
        layoutIfNeeded()
    }
}

extension CategoryCollectionViewCell: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieTableViewCell",
            for: indexPath
        ) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(movie: movies[indexPath.row])
    }
}
