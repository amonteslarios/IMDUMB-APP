//
//  SplashViewController.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

// Protocolo que usa el Presenter
protocol SplashView: AnyObject {
    func showLoading(_ isLoading: Bool)
    func showError(_ message: String)
    func navigateToMain()
}

final class SplashViewController: BaseViewController, SplashView {

    // MARK: - Outlets (conectados desde SplashViewController.xib)
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Dependencias
    var presenter: SplashPresenter!

    // MARK: - Ciclo de vida

    /// Sobrescribimos loadView para cargar el XIB manualmente
    /// y evitar el crash de "view outlet was not set".
    override func loadView() {
        let nib = UINib(nibName: "SplashViewController", bundle: nil)

        // El primer objeto del nib debe ser la vista raíz (UIView)
        guard let rootView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("No se pudo instanciar la vista raíz desde SplashViewController.xib")
        }

        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }

    // MARK: - SplashView

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reintentar",
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.presenter.onViewDidLoad()
        }))
        present(alert, animated: true)
    }

    func navigateToMain() {
        SplashRouter.navigateToCategories(from: self)
    }
}
