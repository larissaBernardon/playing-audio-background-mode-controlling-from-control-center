//
//  ViewController.swift
//  audioBook
//
//  Created by Tag Livros on 22/03/20.
//  Copyright © 2020 Tag Livros. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var playPause: UIButton!
    
    // MARK: - Properties
    var audioPlayer = AVAudioPlayer()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupAudioPlayer()
        setupRemoteTransportControls()
        setupNowPlaying()
    }
    
    // MARK: - Functions
    private func setupAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sample", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            
            setupAudioBackgroundMode()
            
        } catch {
            print("Error..")
        }
    }
    
    private func setupAudioBackgroundMode() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playback, mode: .default)
        } catch {
            print("Não foi possivel configurar background mode")
        }
    }
    
    private func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            print("Play command - is playing: \(self.audioPlayer.isPlaying)")
            if !self.audioPlayer.isPlaying {
                self.audioPlayer.play()
                return .success
            }
            
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            print("Pause command - is playing: \(self.audioPlayer.isPlaying)")
            if self.audioPlayer.isPlaying {
                self.audioPlayer.pause()
                return .success
            }
            
            return .commandFailed
        }
    }
    
    private func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Audiobook"

        if let image = UIImage(named: "artist") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func updateNowPlaying(isPause: Bool) {
        // Define Now Playing Info
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!
        
        print(audioPlayer.currentTime)
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPause ? 0 : 1

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    // MARK: - Actions
    @IBAction func play(_ sender: Any) {
        if audioPlayer.isPlaying {
            playPause.setImage(UIImage(named: "play"), for: .normal)
            audioPlayer.pause()
            updateNowPlaying(isPause: true)
            print("Pause - current time: \(audioPlayer.currentTime) - is playing: \(audioPlayer.isPlaying)")
        } else {
            playPause.setImage(UIImage(named: "pause2"), for: .normal)
            audioPlayer.play()
            updateNowPlaying(isPause: false)
            print("Pause - current time: \(audioPlayer.currentTime) - is playing: \(audioPlayer.isPlaying)")
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        audioPlayer.currentTime = 0
        audioPlayer.play()
        updateNowPlaying(isPause: true)
        updateNowPlaying(isPause: false)
    }
}

