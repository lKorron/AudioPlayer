//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Григорий Никитин on 20/03/2020.
//  Copyright © 2020 Григорий Никитин. All rights reserved.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var playButtonOutlet: UIButton!
    @IBOutlet weak var songPictureImageView: UIImageView!
    
    //MARK: - Fields
    private var player = AVAudioPlayer()
    private var image = UIImage()
    private var timer = Timer()
    private var isPlayingButton = false
    
    
    //MARK: - Application cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image = UIImage(named: "bloodImage")!
    
        setSongPicture(image: image, imageViewToSet: songPictureImageView)
        setPlayer(nameOfSong: "BloodOfKings", player: player)
        setProgressSlider()
    }

    // MARK: - Setting methods
    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    private func setSongPicture(image: UIImage, imageViewToSet:UIImageView){
        imageViewToSet.image = image
    }
    
    private func setPlayer(nameOfSong: String, player: AVAudioPlayer){
        
        do {
            if let path = Bundle.main.path(forResource: nameOfSong, ofType: "mp3") {
                try self.player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            }
        }
            
        catch  {
            print("Loading error")
        }
    }
    private func setProgressSlider(){
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = Float(player.duration)
        progressSlider.isContinuous = false
        
        //slider targets
        progressSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        progressSlider.addTarget(self, action: #selector(sliderStartChanging), for: .touchDown)
    }
    
    // MARK: - target methods
    
    
    @objc func sliderStartChanging(){
        timer.invalidate()
    }
    
    @objc func sliderChanged(){
        
        
        player.stop()
        player.currentTime = TimeInterval(progressSlider.value)
        player.prepareToPlay()
        
        if isPlayingButton {
            player.play()
            startTimer()
        }
    }
    
    @objc func update(){
        progressSlider.setValue(Float(player.currentTime), animated: true)
        
    }
    
    
    
    
    // MARK: - Actions
    @IBAction private func playButton(_ sender: Any) {
        if !player.isPlaying{
            playButtonOutlet.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            player.prepareToPlay()
            player.play()
            startTimer()
            isPlayingButton = true
            
        }
        else {
            playButtonOutlet.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player.pause()
            timer.invalidate()
            isPlayingButton = false
        }
    }
    
    
    @IBAction private func volumeChanged(_ sender: Any) {
        self.player.volume = self.volumeSlider.value
    }
}

