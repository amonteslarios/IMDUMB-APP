//
//  SplashPresenter.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

final class SplashPresenter {

    private weak var view: SplashView?
    private let configService: RemoteConfigServiceProtocol

    // SOLID - SRP: solo coordina la lógica de Splash (configuración inicial + navegación).
    init(view: SplashView, configService: RemoteConfigServiceProtocol) {
        self.view = view
        self.configService = configService
    }

    func onViewDidLoad() {
        view?.showLoading(true)
        configService.fetch { [weak self] result in
            guard let self = self else { return }
            self.view?.showLoading(false)
            switch result {
            case .success:
                self.view?.navigateToMain()
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
}
