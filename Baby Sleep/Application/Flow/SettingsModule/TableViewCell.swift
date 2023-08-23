//
//  TableViewCell.swift
//  Baby Sleep
//
//  Created by Серов Александр on 23.08.2023.
//  Copyright © 2023 Aleksandr Serov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static var identifier = "TableViewCell"
    
    private lazy var settingImage = SettingsImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct FeedbackSettingsModel {
    private var name: String
    private var image: UIImage
    private var backgroundColor: UIColor
    private var action: () -> ()
}
