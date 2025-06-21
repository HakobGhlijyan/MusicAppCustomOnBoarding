//
//  AudioPlayerViewModel.swift
//  MusicAppCustomOnBoarding
//
//  Created by Hakob Ghlijyan on 20.06.2025.
//

import SwiftUI
import AVFoundation
import Observation

@Observable
final class AudioPlayerViewModel: NSObject, AVAudioPlayerDelegate {
    var isPlaying = false
    var playbackProgress: Double = 0.0
    var currentTimeDisplay: String = "0:00"
    var totalTimeDisplay: String = "0:00"
    var isRepeating = false
    
    var playlist: [Song] = [
        Song(title: "Blinding Lights",
             filename: "The_Weeknd_-_Blinding_Lights",
             image: "Blinding_Lights",
             singerInfo: "The Weeknd — Canadian singer, known for his unique voice and 80s-style pop"),
        
        Song(title: "Shape of You",
             filename: "Ed_Sheeran_-_Shape_of_You",
             image: "Shape_of_You",
             singerInfo: "Ed Sheeran — English singer-songwriter known for acoustic pop hits"),
        
        Song(title: "Bad Guy",
             filename: "Billie_Eilish_-_bad_guy",
             image: "Bad_Guy",
             singerInfo: "Billie Eilish — American singer known for dark pop and whispery vocals"),
        
        Song(title: "Dance Monkey",
             filename: "Tones_and_I_-_Dance_Monkey",
             image: "Dance_Monkey",
             singerInfo: "Tones and I — Australian singer with a unique voice and viral debut"),
        
        Song(title: "Levitating",
             filename: "Dua_Lipa_-_Levitating",
             image: "Levitating",
             singerInfo: "Dua Lipa — British-Albanian singer blending disco and modern pop"),
        
        Song(title: "Senorita",
             filename: "Inna_-_Senorita",
             image: "Senorita",
             singerInfo: "Inna — Pop duo known for this romantic duet"),
        
        Song(title: "Believer",
             filename: "Imagine_Dragons_-_Believer",
             image: "Believer",
             singerInfo: "Imagine Dragons — American rock band with energetic anthems"),
        
        Song(title: "Stay",
             filename: "The_Kid_LAROI_Justin_Bieber_-_Stay",
             image: "Stay",
             singerInfo: "The Kid LAROI & Justin Bieber — Collaboration between a rising star and pop icon"),
        
        Song(title: "Peaches",
             filename: "Justin_Bieber_Daniel_Caesar_Giveon_-_Peaches",
             image: "Peaches",
             singerInfo: "Justin Bieber — Canadian pop sensation, with smooth R&B influences"),
        
        Song(title: "Easy On Me",
             filename: "Adele_-_Easy_On_Me",
             image: "Easy_On_Me",
             singerInfo: "Adele — British singer-songwriter known for emotional ballads")
        
    ]
    
    private var currentTrackIndex = 0
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    var onTrackChange: ((String) -> Void)?
    
    var duration: Double {
        return audioPlayer?.duration ?? 0.0
    }
    
    override init() {
        super.init()
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive (true)
        } catch {
            print("Failed to set audio session calegory: \(error)")
        }
    }
    
    
    func loadAudioFile(for song: Song) {
        //Update currentTrackIndex to match the selected song
        if let index = playlist.firstIndex(where: { $0.filename == song.filename }) {
            currentTrackIndex = index
        }
        
        guard let url = Bundle.main.url(forResource: song.filename, withExtension: "mp3") else {
            print("Audio file not found.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            setupProgressUpdater()
            updateTotalTimeDisplay()
            play()
            onTrackChange?(song.filename)
        } catch {
            print("Failed to initialize audio player: \(error)")
        }
    }
    
    func play() {
        audioPlayer?.play()
        setupProgressUpdater()
        isPlaying = true
    }
    
    func pause() {
        audioPlayer?.pause()
        stopProgressUpdater()
        isPlaying = false
    }
    
    func togglePlayPause() {
        isPlaying ? pause() : play()
    }
    
    func toggleRepeat() {
        isRepeating.toggle()
    }
    
    func durationText(for song: Song) -> String {
        guard let url = Bundle.main.url(forResource: song.filename, withExtension: "mp3"), let audioFile = try? AVAudioFile(forReading: url) else {
            return ""
        }
        let songDuration = Double(audioFile.length) / audioFile.fileFormat.sampleRate
        let minutes = Int(songDuration) / 60
        let seconds = Int(songDuration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func seekTo(progress: Double) {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.currentTime = progress * audioPlayer.duration
        playbackProgress = progress
        updateCurrentTimeDisplay()
    }
    
    func nextTrack() {
        // Move to the next track based on currentTrackIndex
        currentTrackIndex = (currentTrackIndex + 1) % playlist.count
        loadAudioFile(for: playlist[currentTrackIndex])
    }
    
    func previousTrack() {
        // Move to the previous track based on currentTrackIndex
        currentTrackIndex = (currentTrackIndex - 1 + playlist.count) % playlist.count
        loadAudioFile(for: playlist[currentTrackIndex])
    }
    
    private func setupProgressUpdater() {
        stopProgressUpdater()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let audioPlayer = self.audioPlayer else { return }
            withAnimation(.linear(duration: 0.1)) {
                self.playbackProgress = audioPlayer.currentTime / audioPlayer.duration
                self.updateCurrentTimeDisplay()
            }
        }
    }
    
    private func stopProgressUpdater() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateCurrentTimeDisplay() {
        let currentSeconds = Int(audioPlayer?.currentTime ?? 0)
        let minutes = currentSeconds / 60
        let seconds = currentSeconds % 60
        currentTimeDisplay = String(format: "%d:%02d", minutes, seconds)
    }
    
    private func updateTotalTimeDisplay() {
        let totalSeconds = Int(duration)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        totalTimeDisplay = String(format: "%d:%02d", minutes, seconds)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isRepeating {
            player.currentTime = 0
            player.play()
            isPlaying = true
        } else {
            isPlaying = false
        }
    }
}
