//
//  StaticAudioVisualizerView.swift
//  MusicAppCustomOnBoarding
//
//  Created by Hakob Ghlijyan on 21.06.2025.
//

import SwiftUI

struct StaticAudioVisualizerView: View {
    @State var waveformSamples: [CGFloat] = []
    @State var dragProgress: Double = 0.0
    @GestureState private var isDragging = false
    var audioPlayer: AudioPlayerViewModel
    @Binding var selectedSong: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(audioPlayer.currentTimeDisplay ) | \(audioPlayer.totalTimeDisplay)")
                .font(.headline)
                .frame(width: 100, height: 40)
            
            HStack(spacing: 2) {
                let minHeight: CGFloat = 1
                let maxHeight: CGFloat = 70
                
                ForEach(0..<waveformSamples.count, id: \.self) { index in
                    let normalizedHeight = min(max(waveformSamples[index] * maxHeight, minHeight), maxHeight)
                    let color = (index < Int(Double(waveformSamples.count) * (isDragging ? dragProgress : audioPlayer.playbackProgress))) ? Color.orange : Color.gray
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: 2, height: normalizedHeight)
                }
            }
            .padding()
            .gesture(
                DragGesture()
                    .updating($isDragging) { value, state, transaction in
                        state = true
                        let dragMultiplier: CGFloat = 1.6
                        let totalWidth = UIScreen.main.bounds.width - 40
                        let startPosition = audioPlayer.playbackProgress * totalWidth
                        let adjustedTranslation = value.translation.width * dragMultiplier
                        let dragPosition = min(max(0, (startPosition + adjustedTranslation) / totalWidth), 1)
                        dragProgress = dragPosition
                        
                        let currentDraggedTime = dragProgress * audioPlayer.duration
                        let draggedMinutes = Int(currentDraggedTime) / 60
                        let draggedSeconds = Int(currentDraggedTime) % 60
                        audioPlayer.currentTimeDisplay = String(format: "%d:%02d", draggedMinutes, draggedSeconds)
                    }
                    .onEnded { value in
                        audioPlayer.seekTo(progress: dragProgress)
                    }
            )
            
            HStack(spacing: 30) {
                Button {
                    
                } label: {
                    Image(systemName: "shuffle")
                        .font(.callout)
                }
                
                Button {
                    audioPlayer.previousTrack()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.title)
                }
                
                Button {
                    audioPlayer.togglePlayPause()
                } label: {
                    Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                }
                
                Button {
                    audioPlayer.nextTrack()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title)
                }
                
                Button {
                    audioPlayer.nextTrack()
                } label: {
                    Image(systemName: "repeat.1")
                        .font(.callout)
                        .foregroundStyle(audioPlayer.isRepeating ? .white : .gray)
                }
            }
            .tint(.primary)
            .padding()

        }
        .onChange(of: selectedSong) { oldValue, newValue in
            loadWaveform()
        }
        .onAppear {
            loadWaveform()
        }
    }
    
    func loadWaveform() {
        guard let song = selectedSong else { return }
        let generator = WaveFormGenerator()
        if let url = Bundle.main.url(forResource: song, withExtension: "mp3") {
            waveformSamples = generator.generateWaveform(for: url, numberOfSamples: 80)
        } else {
            print("Audio file not found.")
        }
    }
}

#Preview {
    StaticAudioVisualizerView(audioPlayer: AudioPlayerViewModel(), selectedSong: .constant("m1"))
        .preferredColorScheme(.dark)
}

struct ControllBarView: View {
    var body: some View {
        VStack(spacing: 64) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray)
                    .frame(height: 8)
                RoundedRectangle(cornerRadius: 12)
                    .fill(.black)
                    .frame(width: 90, height: 8)
                    .overlay(alignment: .trailing) {
                        Circle()
                            .fill(.white)
                            .frame(width: 14, height: 14)
                            .padding(.leading)
                    }
            }
            .padding(.horizontal, 44)
            HStack(spacing: 40) {
                Image(systemName: "shuffle")
                Image(systemName: "backward.fill")
                Image(systemName: "play.fill")
                    .font(.system(size: 28))
                Image(systemName: "forward.fill")
                Image(systemName: "rectangle.expand.vertical")
            }
            .font(.title2)
            .padding(.top, 20)
        }
    }
}
