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
    private var playTime = 15
    private var playTimeInSeconds: Int = 15 * 60
    private var selectIndexPath: IndexPath?
    var timer: Timer?
    
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
    private let timerLabel = UILabel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MainViewCell.self, forCellWithReuseIdentifier: identifier)
        cv.isUserInteractionEnabled = true
        cv.showsVerticalScrollIndicator = false
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
        configureTimeLabel()
        convigureVisualEffectView()
    }
    
    //MARK: - Configure UI
    private func convigureVisualEffectView() {
        let blureEffect = UIBlurEffect(style: .dark)
        visualEffectView.effect = blureEffect
        
        self.view.addSubview(visualEffectView)
        visualEffectView.alpha = 0
        
        visualEffectView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeTimerView))
        visualEffectView.addGestureRecognizer(tap)
        
        visualEffectView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func animateIn() {
        timerCustomView.transform = CGAffineTransform(scaleX: 1.4 , y: 1.4)
        timerCustomView.alpha = 0
        visualEffectView.isUserInteractionEnabled = true
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
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
                make.top.equalToSuperview().offset(-68)
            } else if UIDevice.current.screenType == .iPhones_6_6s_7_8_SE2 || UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus {
                make.top.equalToSuperview().offset(-40)
            } else {
                make.top.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
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
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
                make.bottom.equalToSuperview().offset(100)
            } else if UIDevice.current.screenType == .iPhones_6_6s_7_8_SE2 || UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus{
                make.bottom.equalToSuperview().offset(60)
            } else {
                make.bottom.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(227)
        }
    }
    
    private func configureNatureLabel() {
        natureLabel.setTitle("Nature", for: .normal)
        natureLabel.titleLabel?.font = UIFont(name: "MontserratAlternates-Regular", size: 20.0)
        natureLabel.tintColor = .white
        natureLabel.addTarget(self, action: #selector(natureButtonAction), for: .touchUpInside)
        self.view.addSubview(natureLabel)
        guard  let image = UIImage(named: "Oval") else { return }
        natureDot.image = image
        self.view.addSubview(natureDot)
        
        //Setup constreints
        natureLabel.snp.makeConstraints { make in
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
                make.top.equalToSuperview().offset(40)
                make.leading.equalToSuperview().inset(50)
            } else if UIDevice.current.screenType == .iPhones_6_6s_7_8_SE2 || UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus {
                make.top.equalToSuperview().offset(50)
                make.leading.equalToSuperview().inset(60)
            } else {
                make.top.equalToSuperview().offset(80)
                make.leading.equalToSuperview().inset(60)
            }
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
        noiseLable.setTitle("Noise", for: .normal)
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
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
                make.trailing.equalToSuperview().inset(51)
            } else {
                make.trailing.equalToSuperview().inset(61)
            }
            make.centerY.equalTo(natureLabel)
            make.height.equalTo(24)
            make.width.equalTo(70)
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
        if presenter.lastPlaying == nil {
            stopPlayButton.alpha = 0.5
            stopPlayButton.isEnabled = false
        }
        self.view.addSubview(stopPlayButton)
        
        //Setup constreints
        stopPlayButton.snp.makeConstraints { make in
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
                make.bottom.equalTo(bottomImage.snp.bottom).inset(115)
            } else if UIDevice.current.screenType == .iPhones_6_6s_7_8_SE2 || UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus {
                make.bottom.equalTo(bottomImage.snp.bottom).inset(80)
            } else {
                make.bottom.equalTo(bottomImage.snp.bottom).inset(50)
            }
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
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
                make.width.equalTo(200)
            } else {
                make.width.equalTo(241)
            }
            make.centerX.equalToSuperview()
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
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE || UIDevice.current.screenType == .iPhones_6_6s_7_8_SE2 || UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus {
                $0.centerY.equalTo(stopPlayButton)
                $0.trailing.equalToSuperview().inset(60)
            } else {
                $0.bottom.equalTo(volumeSlider.snp.bottom).inset(50)
                $0.trailing.equalToSuperview().inset(30)
            }
            
            $0.width.height.equalTo(28)
        }
    }
    
    private func configureCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .background
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
        
        
        //Setup constraints
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
        
        //Setup constraints
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
        
        //Setup constraints
        bottomTriangle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(bottomImage.snp.top)
            make.width.height.equalTo(80)
        }
    }
    
    private func configureConteinerView() {
        self.view.addSubview(timerCustomView)
        timerCustomView.layer.cornerRadius = 25
        timerCustomView.delegate = self
        timerCustomView.isUserInteractionEnabled = true
        
        //Setup constraints
        timerCustomView.snp.makeConstraints {
            $0.width.equalTo(250)
            $0.height.equalTo(250)
            $0.trailing.equalToSuperview().inset(6)
            $0.bottom.equalToSuperview().inset(136)
        }
    }
    
    private func configureTimeLabel() {
        view.addSubview(timerLabel)
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 25, weight: .regular) //(name: "MontserratAlternates-Regular", size: 25.0)
        timerLabel.text = "15:00"
        timerLabel.textAlignment = .center
        timerLabel.textColor = .white
        timerLabel.adjustsFontSizeToFitWidth = false
        
        //Setup constraints
        timerLabel.snp.makeConstraints {
            if UIDevice.current.screenType == .iPhones_5_5s_5c_SE  {
                $0.leading.equalToSuperview().inset(10)
            } else if UIDevice.current.screenType == .iPhones_6_6s_7_8_SE2 ||  UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus {
                $0.leading.equalToSuperview().inset(20)
            } else {
                $0.centerX.equalTo(stopPlayButton)
            }
            $0.centerY.equalTo(timerButton)
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
    
    @objc private func playerPause() {
        if !presenter.isPlaying {
            presenter.playStopTogle(audio: presenter.lastPlaying?.audioUrl ?? "", name: presenter.lastPlaying?.titleEn ?? "", time: playTime, isSelected: false, volume: volumeSlider.value)
            if playTime != 1 {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            }
            stopPlayButton.setImage(UIImage(named: "Pause"), for: .normal)
        } else {
            presenter.pause()
            stopPlayButton.setImage(UIImage(named: "Play"), for: .normal)
            timer?.invalidate()
        }
    }
    
    @objc private func changeVolume(_ slider: UISlider) {
        let value = volumeSlider.value
        presenter.changeVolume(volume: value)
    }
    
    @objc private func showTimer() {
        self.configureConteinerView()
        self.animateIn()
    }
    
    @objc private func closeTimerView(sender: UIView) {
        timerButtonTapped()
    }
}

// ----------------------------------------------------------------------------

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.screenType == .iPhone_XSMax_11ProMax {
            return CGSize(width: 100, height: 176)
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            return CGSize(width: 70, height: 110)
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8_SE2 {
            return CGSize(width: 90, height: 140)
        } else if UIDevice.current.screenType == .iPhones_X_XS || UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus {
            return CGSize(width: 90, height: 166)
        } else {
            return CGSize(width: 100, height: 166)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            return UIEdgeInsets(top: 35, left: 34, bottom: 20, right: 34)
        } else if UIDevice.current.screenType == .iPhone_XSMax_11ProMax {
            return UIEdgeInsets(top: 60, left: 34, bottom: 0, right: 34)
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8_SE2 {
            return UIEdgeInsets(top: 25, left: 34, bottom: 20, right: 34)
        } else if UIDevice.current.screenType == .iPhone_XR_11 {
            return UIEdgeInsets(top: 60, left: 34, bottom: 0, right: 34)
        } else if UIDevice.current.screenType == .iPhones_X_XS || UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus {
            return UIEdgeInsets(top: 30, left: 25, bottom: 0, right: 25)
        } else {
            return UIEdgeInsets(top: 46, left: 34, bottom: 43, right: 34)
        }
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
        resetTimerLabel()
        timer?.invalidate()
        if let cell = collectionView.cellForItem(at: indexPath) as? MainViewCell {
            if noiseFlag == false {
                guard let model = presenter.natureSounds?[indexPath.row] else { return }
                presenter.lastPlaying = model
                presenter.playStopTogle(audio: model.audioUrl, name: model.titleEn, time: playTime, isSelected: model.selected, volume: volumeSlider.value)
                if model.selected == false {
                    if selectIndexPath != nil {
                        presenter.natureSounds?[selectIndexPath!.row].selected = false
                        presenter.noiseSounds?[selectIndexPath!.row].selected = false
                        selectIndexPath = indexPath
                    } else {
                        selectIndexPath = indexPath
                    }
                    if playTime != 1 {
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
                    }
                    presenter.natureSounds?[indexPath.row].selected = true
                    stopPlayButton.setImage(UIImage(named: "Pause"), for: .normal)
                    stopPlayButton.alpha = 1
                    stopPlayButton.isEnabled = true
                    cell.highlites(with: model)
                } else {
                    timer?.invalidate()
                    presenter.natureSounds?[indexPath.row].selected = false
                    cell.deleteHighlites()
                    stopPlayButton.setImage(UIImage(named: "Play"), for: .normal)
                    stopPlayButton.alpha = 0.5
                    stopPlayButton.isEnabled = false
                    presenter.lastPlaying = nil
                    resetTimerLabel()
                }
            } else {
                guard let model = presenter.noiseSounds?[indexPath.row] else { return }
                presenter.lastPlaying = model
                presenter.playStopTogle(audio: model.audioUrl, name: model.titleEn, time: playTime, isSelected: model.selected, volume: volumeSlider.value)
                if model.selected == false {
                    if selectIndexPath != nil {
                        presenter.natureSounds?[selectIndexPath!.row].selected = false
                        presenter.noiseSounds?[selectIndexPath!.row].selected = false
                        selectIndexPath = indexPath
                    } else {
                        selectIndexPath = indexPath
                    }
                    if playTime != 1 {
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
                    }
                    presenter.noiseSounds?[indexPath.row].selected = true
                    stopPlayButton.setImage(UIImage(named: "Pause"), for: .normal)
                    stopPlayButton.alpha = 1
                    stopPlayButton.isEnabled = true
                    cell.highlites(with: model)
                } else {
                    timer?.invalidate()
                    presenter.noiseSounds?[indexPath.row].selected = false
                    cell.deleteHighlites()
                    stopPlayButton.setImage(UIImage(named: "Play"), for: .normal)
                    stopPlayButton.alpha = 0.5
                    stopPlayButton.isEnabled = false
                    presenter.lastPlaying = nil
                    resetTimerLabel()
                }
            }
            HapticFeedback.add()
        }
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

extension MainViewController: TimerViewDelegate {
    
    fileprivate func updateTimerLabelAfterTapped(_ playTime: Int) {
        timerLabel.text = presenter.timeFormatted(playTime)
        self.playTime = playTime
        self.playTimeInSeconds = playTime * 60
    }
    
    func timeButtonTapped(playTime: Int, isPaid: Bool) {
        if !isPaid {
            updateTimerLabelAfterTapped(playTime)
            timerButtonTapped()
            if playTime != 1 {
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            } else {
                timer?.invalidate()
                resetTimerLabel()
            }
        } else {
            if !PurchaseManager.shared.isUserPremium {
                timerButtonTapped()
                let vc = ControllerBuilder.createSubscriptionController()
                
                self.present(vc, completion: nil)
            } else {
                updateTimerLabelAfterTapped(playTime)
                timerButtonTapped()
                if playTime != 1 {
                    timer?.invalidate()
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
                } else {
                    timer?.invalidate()
                    resetTimerLabel()
                }
            }
        }
    }
    
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

extension MainViewController {
    
    @objc func updateTimerLabel() {
        if playTimeInSeconds > 0 {
            let seconds: Int = playTimeInSeconds % 60
            let minutes: Int = (playTimeInSeconds / 60) % 60
            let hour: Int = playTimeInSeconds / 3600
            let aaa = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
            
            
            timerLabel.text = aaa
            playTimeInSeconds -= 1
        } else {
            timer?.invalidate()
            presenter.pause()
            resetTimerLabel()
            stopPlayButton.setImage(UIImage(named: "Play"), for: .normal)
        }
    }
    
    private func resetTimerLabel() {
        if playTime == 1 {
            timerLabel.text = "∞"
        } else {
            playTimeInSeconds = playTime * 60
            let seconds: Int = playTimeInSeconds % 60
            let minutes: Int = (playTimeInSeconds / 60) % 60
            let hour: Int = playTimeInSeconds / 3600
            let aaa = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
            
            timerLabel.text = aaa
        }
    }
}
