//
//  AudioPlayer.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 01.12.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioPlayerProtocol {
    func play(audio: String, name: String, volume: Float)
    func fadeVolumeAndPause()
    func changeVolume(volume: Float)
}

class AudioPlayer: AudioPlayerProtocol {
    var timer: Timer?
    private let cashingService = CashingService()
    private var player: AVAudioPlayer?

    func play(audio: String, name: String, volume: Float) {
        self.cashingService.cashingAudio(shortLink: audio, fileName: name, comletion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let url):
                do {
                    try AVAudioSession.sharedInstance().setMode(.default)
                    try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                    try self.player = AVAudioPlayer(contentsOf: url)
                    guard let player = self.player else { return }
                    player.volume = 0
                    player.prepareToPlay()
                    player.play()
                    player.setVolume(volume, fadeDuration: 10)
                    player.numberOfLoops = -1
                } catch {
                    print("Play error \(error)")
                }
            case .failure( _):
                print("ошибка тут")
            }
        })
    }

    func changeVolume(volume: Float) {
        player?.volume = volume
    }
    
    func fadeVolumeAndPause() {
        if player?.volume ?? 0.1 > 0.0 {
            player?.volume = self.player!.volume - 0.1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.fadeVolumeAndPause()
            }
        } else {
            player?.pause()
        }
    }
}
