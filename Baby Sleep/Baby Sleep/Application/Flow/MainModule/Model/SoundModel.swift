// ----------------------------------------------------------------------------
//
//  SoundModel.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 12.07.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import AVFoundation
import FirebaseDatabase
import Foundation
import UIKit

// ----------------------------------------------------------------------------

public struct SoundModel: Codable {
    let titleEn: String
    let titleRu: String
    let imageUrl: String
    let audioUrl: String
    var color: Color

    init(titleEn: String, titleRu: String, imageUrl: String, audioUrl: String, color: Color) {
        self.titleEn = titleEn
        self.titleRu = titleRu
        self.imageUrl = imageUrl
        self.audioUrl = audioUrl
        self.color = color
    }

    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let titleEn = value["titleEn"] as? String,
              let titleRu = value["titleRu"] as? String,
              let imageUrl = value["imageUrl"] as? String,
              let audioUrl = value["audioUrl"] as? String else { return nil }

        let colorSnapshot = snapshot.childSnapshot(forPath: "color")
        guard let color = colorSnapshot.value as? [String: Any],
              let alpha = color["alpha"] as? Double,
              let red = color["red"] as? Double,
              let blue = color["blue"] as? Double,
              let green = color["green"] as? Double else { return nil }

        self.titleEn = titleEn
        self.titleRu = titleRu
        self.imageUrl = imageUrl
        self.audioUrl = audioUrl
        self.color = Color(alpha: alpha, red: red, green: green, blue: blue)

    }
}

struct Color: Codable {
    var alpha: Double
    var red: Double
    var green: Double
    var blue: Double

    init(alpha: Double, red: Double, green: Double, blue: Double ) {
        self.alpha = alpha
        self.red = red
        self.green = green
        self.blue = blue
    }
}
