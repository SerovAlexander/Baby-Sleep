// ----------------------------------------------------------------------------
//
//  MainViewController.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 12.07.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import AVFoundation
import FirebaseStorage
import SnapKit
import UIKit

// ----------------------------------------------------------------------------

private let identifier = "cell"

class MainViewController: UIViewController {
    
    // MARK: - Propertise
    var presenter: MainVCPresenterProtocol!
    private var noiseSounds: [SoundModel] = []
    private var noiseFlag = false
    private var player: AVAudioPlayer!
    private let storageRef = Storage.storage().reference()
    private let cashingService = CashingService()
    
    // MARK: - UI
    private let topImage = UIImageView()
    private let topTriangle = UIImageView()
    private let natureLabel = UIButton()
    private let natureDot = UIImageView()
    private let noiseDot = UIImageView()
    private let noiseLable = UIButton()
    private let bottomImage = UIImageView()
    private let bottomTriangle = UIImageView()
    private let stopPlayButton = UIButton()
    private let volumeSlider = UISlider()
    private let loudVolumeImage = UIImageView()
    private let quiteVolumeImage = UIImageView()
    private let timerButton = UIButton()
    private lazy var timerCustomView = ChoiseTimerView()
    private let visualEffectView = UIVisualEffectView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 15)
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MainViewCell.self, forCellWithReuseIdentifier: identifier)
        cv.isUserInteractionEnabled = true
        return cv
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getSound()
        self.view.backgroundColor = .background
        configureTopRectangle()
        setupBottomRectangle()
        configureStopPlayButton()
        configureVolumeSlider()
        configureTimerButton()
        configureCollectionView()
        configureTopTriangle()
        configureBottomTriangle()
        configureNatureLabel()
        configureNoiseLabel()
//        configureTimerCustomView()
//        configureConteinerView()
        convigureVisualEffectView()
    }
    
    //MARK:- Configure UI
    
    private func convigureVisualEffectView() {
        let blureEffect = UIBlurEffect(style: .light)
        visualEffectView.effect = blureEffect
        
        self.view.addSubview(visualEffectView)
        visualEffectView.alpha = 0
        
        visualEffectView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func animateIn() {
        timerCustomView.transform = CGAffineTransform(scaleX: 1.4 , y: 1.4)
        timerCustomView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.timerCustomView.transform = CGAffineTransform.identity
            self.timerCustomView.alpha = 1
            self.visualEffectView.alpha = 1
        }
    }
    
    private func configureTopRectangle() {
        guard let image = UIImage(named: "Rectangletop") else { return }
        topImage.backgroundColor = .background
        topImage.image = image
        topImage.contentMode = .scaleToFill
        self.view.addSubview(topImage)
        
        //Setup constreints
        topImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(148)
        }
    }
    
    private func setupBottomRectangle() {
        guard let image = UIImage(named: "Rectanglebottom") else { return }
        bottomImage.image = image
        bottomImage.backgroundColor = .background
        bottomImage.contentMode = .scaleToFill
        self.view.addSubview(bottomImage)
        
        //Setup constreints
        bottomImage.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(227)
        }
    }
    
    private func configureNatureLabel() {
        natureLabel.setTitle("Природа", for: .normal)
        natureLabel.titleLabel?.font = UIFont(name: "MontserratAlternates-Regular", size: 20.0)
        natureLabel.tintColor = .white
        natureLabel.addTarget(self, action: #selector(natureButtonAction), for: .touchUpInside)
        self.view.addSubview(natureLabel)
        guard  let image = UIImage(named: "Oval") else { return }
        natureDot.image = image
        self.view.addSubview(natureDot)
        
        //Setup constreints
        natureLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(60)
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(24)
            make.width.equalTo(101)
        }
        natureDot.snp.makeConstraints { make in
            make.width.height.equalTo(6)
            make.centerX.equalTo(natureLabel)
            make.top.equalTo(natureLabel.snp.bottom).offset(5)
        }
    }
    
    private func configureNoiseLabel() {
        noiseLable.setTitle("Шум", for: .normal)
        noiseLable.titleLabel?.font = UIFont(name: "MontserratAlternates-Regular", size: 20.0)
        noiseLable.tintColor = .white
        noiseLable.titleLabel?.alpha = 0.5
        noiseLable.addTarget(self, action: #selector(noiseButtonAction), for: .touchUpInside)
        self.view.addSubview(noiseLable)
        
        guard  let image = UIImage(named: "Oval") else { return }
        noiseDot.image = image
        noiseDot.isHidden = true
        self.view.addSubview(noiseDot)
        
        //Setup constreints
        noiseLable.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(61)
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(24)
            make.width.equalTo(53)
        }
        noiseDot.snp.makeConstraints { make in
            make.height.width.equalTo(6)
            make.centerX.equalTo(noiseLable)
            make.top.equalTo(noiseLable.snp.bottom).offset(5)
        }
    }
    
    private func configureStopPlayButton() {
        guard let image = UIImage(named: "Play") else { return }
        stopPlayButton.setImage(image, for: .normal)
        stopPlayButton.addTarget(self, action: #selector(playerPause), for: .touchUpInside)
        self.view.addSubview(stopPlayButton)

        //Setup constreints
        stopPlayButton.snp.makeConstraints { make in
            make.bottom.equalTo(bottomImage.snp.bottom).inset(50)
            make.centerX.equalToSuperview()
        }
    }

    private func configureVolumeSlider() {
        guard let loudImage = UIImage(named: "SoundLoud") else { return }
        guard let quiteImage = UIImage(named: "SoundQuiet") else { return }
        volumeSlider.value = 0.5
        volumeSlider.tintColor = .white
        volumeSlider.addTarget(self, action: #selector(changeVolume), for: .valueChanged)
        loudVolumeImage.image = loudImage
        quiteVolumeImage.image = quiteImage
        self.view.addSubview(volumeSlider)
        self.view.addSubview(loudVolumeImage)
        self.view.addSubview(quiteVolumeImage)

        //Setup constreints
        volumeSlider.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(241)
            make.bottom.equalTo(stopPlayButton.snp.bottom).inset(60)
        }
        loudVolumeImage.snp.makeConstraints { make in
            make.centerY.equalTo(volumeSlider)
            make.leading.equalTo(volumeSlider.snp.trailing).offset(16)
        }
        quiteVolumeImage.snp.makeConstraints { make in
            make.centerY.equalTo(volumeSlider)
            make.trailing.equalTo(volumeSlider.snp.leading).offset(-16)
        }
    }

    private func configureTimerButton() {
        self.view.addSubview(timerButton)
        guard let timer = UIImage(named: "timer") else { return }
        
        timerButton.setImage(timer, for: .normal)
        timerButton.contentMode = .scaleAspectFit
        timerButton.addTarget(self, action: #selector(showTimer), for: .touchUpInside)
        
        timerButton.snp.makeConstraints {
            $0.bottom.equalTo(volumeSlider.snp.bottom).inset(50)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(28)
        }
    }

    private func configureCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .background
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 70, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
        

        //Setup constreints
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topImage.snp.bottom)
            make.bottom.equalTo(bottomImage.snp.top)
        }
    }

    private func configureTopTriangle() {
        guard let image = UIImage(named: "triangletop") else { return }
        topTriangle.image = image
        self.view.addSubview(topTriangle)

        //Setup constreints
        topTriangle.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(topImage.snp.bottom)
            make.width.height.equalTo(80)
        }
    }

    private func configureBottomTriangle() {
        guard let image = UIImage(named: "trianglebottom") else { return }
        bottomTriangle.image = image
        self.view.addSubview(bottomTriangle)

        //Setup constreints
        bottomTriangle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(bottomImage.snp.top)
            make.width.height.equalTo(80)
        }
    }
    
//    private func configureTimerCustomView() {
//        let screenSize: CGRect = UIScreen.main.bounds
//        timerCustomView = ChoiseTimerView(frame: screenSize)
//        self.view.addSubview(timerCustomView)
//        timerCustomView.isHidden = true
//        timerCustomView.alpha = 0
//    }
    
    private func configureConteinerView() {
        self.view.addSubview(timerCustomView)
        timerCustomView.layer.cornerRadius = 25
        timerCustomView.delegate = self
        timerCustomView.snp.makeConstraints {
            $0.width.equalTo(250)
            $0.height.equalTo(250)
            $0.trailing.equalToSuperview().inset(6)
            $0.bottom.equalToSuperview().inset(136)
        }
    }
    
    //MARK:- Private Methods

    @objc private func natureButtonAction() {
        noiseFlag = false
        noiseDot.isHidden = true
        noiseLable.titleLabel?.alpha = 0.5
        natureDot.isHidden = false
        natureLabel.titleLabel?.alpha = 1
        collectionView.reloadData()
    }

    @objc private func noiseButtonAction() {
        noiseFlag = true
        natureDot.isHidden = true
        natureLabel.titleLabel?.alpha = 0.5
        noiseDot.isHidden = false
        noiseLable.titleLabel?.alpha = 1
        collectionView.reloadData()
    }

    @objc private func playerPause(){
        presenter.pause()
        stopPlayButton.setImage(UIImage(named: "Play"), for: .normal)
    }

    @objc private func changeVolume(_ slider: UISlider) {
        let value = volumeSlider.value
        presenter.changeVolume(volume: value)
    }
    
    @objc private func showTimer() {
//        UIView.animate(withDuration: 0.3) {
            self.configureConteinerView()
            self.animateIn()
//        }
    }
}

// ----------------------------------------------------------------------------

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 3.5), height: 176)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if noiseFlag == true {
            return presenter.noiseSounds?.count ?? 0
        } else {
            return presenter.natureSounds?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if noiseFlag == true {
            guard let model = presenter.noiseSounds?[indexPath.row] else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MainViewCell else { return UICollectionViewCell() }
            cell.configureWithFirebase(with: model)
            return cell
        } else {
            guard let model = presenter.natureSounds?[indexPath.row] else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MainViewCell else { return UICollectionViewCell() }
            cell.configureWithFirebase(with: model)
            return cell
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MainViewCell {
            if noiseFlag == false {
                guard let model = presenter.natureSounds?[indexPath.row] else { return }
                presenter.play(audio: model.audioUrl, name: model.titleEn)
                cell.highlites(with: model)
            } else {
                guard let model = presenter.noiseSounds?[indexPath.row] else { return }
                presenter.play(audio: model.audioUrl, name: model.titleEn)
                cell.highlites(with: model)
            }
        }
        HapticFeedback.add()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MainViewCell {
            cell.deleteHighlites()
        }
    }
}

extension MainViewController: MainViewControllerProtocol {

    func succes() {
        collectionView.reloadData()
    }
    
    func failure(error: Error) {
        print(error)
    }
}

extension MainViewController: timerViewDelegate {
    func timerButtonTapped() {
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 0
            self.timerCustomView.alpha = 0
            self.timerCustomView.transform = CGAffineTransform(scaleX: 1.4 , y: 1.4)
        } completion: { (_) in
            self.timerCustomView.removeFromSuperview()
        }

    }
}
