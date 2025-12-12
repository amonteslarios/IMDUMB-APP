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

final class RecommendModalViewController: BaseViewController, RecommendModalView, UITextViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var acceptButton: UIButton!
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Escribe tu comentario aquí..."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.alpha = 0.2
        return label
    }()

    var presenter: RecommendModalPresenter!
   
    override func loadView() {
        let nib = UINib(nibName: "RecommendModalViewController", bundle: nil)
        guard let rootView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("No se pudo instanciar RecommendModalViewController.xib")
        }
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.cornerRadius = 8
        commentTextView.clipsToBounds = true

        placeholderLabel.frame = CGRect(x: 5, y: 8,
                                        width: commentTextView.bounds.width - 10,
                                        height: 20)

        commentTextView.addSubview(placeholderLabel)
        commentTextView.delegate = self
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
