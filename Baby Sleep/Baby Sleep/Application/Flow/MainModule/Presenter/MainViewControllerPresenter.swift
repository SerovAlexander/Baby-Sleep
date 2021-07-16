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
    func play(audio: String, name: String, time: Int)
    func pause()
    func changeVolume(volume: Float)
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

    func play(audio: String, name: String, time: Int) {
        audioPlayer.play(audio: audio, name: name)
        if time != 1 {
            let seconds = TimeInterval(time * 60)//DispatchTime(uptimeNanoseconds: UInt64(time * 60))
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
                guard let self = self else { return }
                self.audioPlayer.pause()
            }
        }
    }

    func pause() {
        audioPlayer.pause()
    }

    func changeVolume(volume: Float) {
        audioPlayer.changeVolume(volume: volume)
    }

    private struct Inner {
        static let natureSound = "nature"
        static let noiseSound = "noise"
    }

}
