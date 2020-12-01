// ----------------------------------------------------------------------------
//
//  MainViewControllerPresenter.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 01.12.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import FirebaseDatabase
import Foundation

// ----------------------------------------------------------------------------

protocol MainViewControllerProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol MainVCPresenterProtocol {
    init(view: MainViewControllerProtocol, networkService: NetworkService, audioPlayer: AudioPlayerProtocol)
    var natureSounds: [SoundModel]? { get set }
    var noiseSounds: [SoundModel]? { get set }
    func getSound()
    func play(audio: String, name: String)
    func pause()
}

class MainVCPresenter: MainVCPresenterProtocol {
    
    weak var view: MainViewControllerProtocol?
    private let networkService: NetworkService
    private let audioPlayer: AudioPlayerProtocol
    var natureSounds: [SoundModel]?
    var noiseSounds: [SoundModel]?


    required init(view: MainViewControllerProtocol, networkService: NetworkService, audioPlayer: AudioPlayerProtocol) {
        self.view = view
        self.networkService = networkService
        self.audioPlayer = audioPlayer
    }

    func getSound() {
        networkService.fetchData(type: Inner.natureSound) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let natureSounds):
                self.natureSounds = natureSounds
                DispatchQueue.main.async {
                    self.view?.succes()
                }
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }
        networkService.fetchData(type: Inner.noiseSound) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let noiseSounds):
                self.noiseSounds = noiseSounds
                DispatchQueue.main.async {
                    self.view?.succes()
                }
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }
    }

    func play(audio: String, name: String) {
        audioPlayer.play(audio: audio, name: name)
    }

    func pause() {
        audioPlayer.pause()
    }

    private struct Inner {
        static let natureSound = "nature"
        static let noiseSound = "noise"
    }

}
