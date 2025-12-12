//
//  FirebaseConfigService.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation
import FirebaseRemoteConfig

protocol RemoteConfigServiceProtocol {
    func fetch(completion: @escaping (Result<Void, Error>) -> Void)
}

final class FirebaseRemoteConfigService: RemoteConfigServiceProtocol {

    private let remoteConfig: RemoteConfig

    init(remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()) {
        self.remoteConfig = remoteConfig
    }

    func fetch(completion: @escaping (Result<Void, Error>) -> Void) {
        remoteConfig.fetchAndActivate { status, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Ejemplo: leer toggle para mocks
            let useMocks = self.remoteConfig["use_mock_data"].boolValue
            AppConfiguration.useMockRemoteDataStore = useMocks

            completion(.success(()))
        }
    }
}
