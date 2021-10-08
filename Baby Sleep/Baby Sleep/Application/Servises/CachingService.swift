// ----------------------------------------------------------------------------
//
//  CachingService.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 13.08.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import FirebaseStorage
import Foundation

// ----------------------------------------------------------------------------

class CashingService {

    //MARK: - Public Methods

    public func cashingAudio(shortLink: String, fileName: String, comletion: @escaping (Result<URL, Error>) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let isLandRef = storageRef.child(shortLink)
        if let localURL = getLocalUrl(fileName: fileName) {
            comletion(.success(localURL))
        } else {
            guard let localURL = createLocalURL(fileName: fileName) else { return }
            let downloadTask = isLandRef.write(toFile: localURL)
            
            downloadTask.observe(.success) { snapshot in
                if let error = snapshot.error {
                    comletion(.failure(error))
                } else {
                    comletion(.success(localURL))
                }
            }
        }
    }

    //MARK: - private Methods

    private func getLocalUrl(fileName: String) -> URL? {
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let url = cacheDir.appendingPathComponent(fileName, isDirectory: true)
        if FileManager.default.fileExists(atPath: url.path) {
            return url
        }
        return nil
    }
    
    private func createLocalURL(fileName: String) -> URL? {
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let url = cacheDir.appendingPathComponent(fileName, isDirectory: true)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        
        return url
    }
}
