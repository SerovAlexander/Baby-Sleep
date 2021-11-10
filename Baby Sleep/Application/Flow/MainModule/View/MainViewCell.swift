// ----------------------------------------------------------------------------
//
//  MainViewCell.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 17.07.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import FirebaseStorageUI
import SnapKit
import UIKit

// ----------------------------------------------------------------------------

class MainViewCell: UICollectionViewCell {

    // MARK: - Properties

    let image = UIImageView()
    let nameLabel = UILabel()
    let storageRef = Storage.storage().reference()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        setupNameLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func highlites(with model: SoundModel){
        let color = UIColor(red: CGFloat(model.color.red),
                            green: CGFloat(model.color.green),
                            blue: CGFloat(model.color.blue),
                            alpha: CGFloat(model.color.alpha))
        nameLabel.textColor = color
        nameLabel.layer.shadowColor = color.cgColor
        nameLabel.layer.shadowRadius = 3.0
        nameLabel.layer.shadowOpacity = 1.0
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        nameLabel.layer.masksToBounds = false
        contentView.layer.shadowColor = color.cgColor
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.masksToBounds = false
    }

    func deleteHighlites() {
        nameLabel.textColor = .white
        nameLabel.layer.shadowColor = nil
        contentView.layer.shadowColor = nil
        contentView.layer.shadowRadius = 0
        contentView.layer.shadowOpacity = 0
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    func configureWithFirebase(with model: SoundModel) {
        nameLabel.text = model.titleRu
        let ref = storageRef.child(model.imageUrl)
        image.sd_setImage(with: ref, placeholderImage: UIImage(named: model.titleEn))
        deleteHighlites()
    }

    // MARK: - Private Methods

    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 16.0)
        nameLabel.textColor = .white
        nameLabel.snp.makeConstraints { make in
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
                make.top.equalTo(image.snp.bottom).offset(10)
            } else {
                make.top.equalTo(image.snp.bottom).offset(16)
            }
            make.centerX.equalTo(image)
            make.height.equalTo(20)
        }
    }

    private func makeHighlites(color: UIColor) {
        nameLabel.textColor = color
        nameLabel.layer.shadowColor = color.cgColor
        nameLabel.layer.shadowRadius = 3.0
        nameLabel.layer.shadowOpacity = 1.0
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        nameLabel.layer.masksToBounds = false
        contentView.layer.shadowColor = color.cgColor
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.masksToBounds = false
    }

    private func setupImage() {
        contentView.addSubview(image)
        image.contentMode = .scaleAspectFill

        //Setup Constreints
        image.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
                make.height.equalTo(100)
                make.width.equalTo(60)
            } else if UIDevice.current.screenType == .iPhones_6_6s_7_8_SE2 || UIDevice.current.screenType == .iPhones_X_XS {
                make.height.equalTo(130)
            } else {
                make.height.equalTo(142)
            }
        }
    }
}
