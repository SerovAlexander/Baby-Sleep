// ----------------------------------------------------------------------------
//
//  NetworkService.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 05.08.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import FirebaseDatabase
import Foundation

// ----------------------------------------------------------------------------

final class NetworkService {

    //MARK: - Public Methods

    let ref: DatabaseReference = Database.database().reference()
    func fetchData(type: String, comletion: @escaping (Result<[SoundModel], Error>) -> Void) {
        ref.child("sounds").child(type).observe(.value) { snapshot in
            DispatchQueue.global().async {
                var soundsArray = [SoundModel]()
                for child in snapshot.children {
                    if let soundSnapshot = child as? DataSnapshot,
                       let sound = SoundModel(snapshot: soundSnapshot) {
                        soundsArray.append(sound)
                    } else {
                        let error: Error = "Вот тут ошибка" as! Error
                        comletion(.failure(error))
                    }
                }
                comletion(.success(soundsArray))
            }
        }
    }
}
