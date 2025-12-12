//
//  RecommendModalViewController.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

protocol RecommendModalView: AnyObject {
    func showMovie(title: String, detail: String)
    func closeWithSuccess()
}

final class RecommendModalViewController: BaseViewController, RecommendModalView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!

    var presenter: RecommendModalPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }

    func showMovie(title: String, detail: String) {
        titleLabel.text = title
        detailLabel.text = detail
    }

    func closeWithSuccess() {
        let alert = UIAlertController(
            title: "Éxito",
            message: "Tu recomendación fue enviada.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    @IBAction func confirmTapped(_ sender: UIButton) {
        presenter.confirmRecommendation(comment: commentTextView.text)
    }
}
