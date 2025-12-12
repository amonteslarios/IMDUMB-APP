//
//  ImageLoader.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()
    private var tasks: [UUID: URLSessionDataTask] = [:]
    private let lock = NSLock()

    @discardableResult
    func load(_ url: URL, completion: @escaping (UIImage?) -> Void) -> UUID? {
        let key = url as NSURL

        if let cached = cache.object(forKey: key) {
            DispatchQueue.main.async { completion(cached) }
            return nil
        }

        let uuid = UUID()
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            defer { self?.remove(uuid) }

            guard let data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            self?.cache.setObject(image, forKey: key)
            DispatchQueue.main.async { completion(image) }
        }

        store(task, uuid)
        task.resume()
        return uuid
    }

    func cancel(_ uuid: UUID) {
        lock.lock(); defer { lock.unlock() }
        tasks[uuid]?.cancel()
        tasks[uuid] = nil
    }

    private func store(_ task: URLSessionDataTask, _ uuid: UUID) {
        lock.lock(); defer { lock.unlock() }
        tasks[uuid] = task
    }

    private func remove(_ uuid: UUID) {
        lock.lock(); defer { lock.unlock() }
        tasks[uuid] = nil
    }
}

