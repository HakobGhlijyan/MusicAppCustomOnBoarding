//
//  WaveFormGenerator.swift
//  MusicAppCustomOnBoarding
//
//  Created by Hakob Ghlijyan on 21.06.2025.
//

import SwiftUI
import AVFoundation

class WaveFormGenerator {
    func generateWaveform(for url: URL, numberOfSamples: Int) -> [CGFloat] {
        var samples: [CGFloat] = Array(repeating: 0.5, count: numberOfSamples)
        
        guard let audioFile = try? AVAudioFile(forReading: url) else {
            print("Failed to load audio file.")
            return samples
        }
        
        let frameCount = AVAudioFrameCount(audioFile.length)
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: frameCount)!
        
        do {
            try audioFile.read(into: buffer)
        } catch {
            print("Failed to read audio data: \(error)")
            return samples
        }
        
        let channelData = buffer.floatChannelData![0]
        let stride = Int(buffer.frameLength) / numberOfSamples
        
        for i in 0..<numberOfSamples {
            let sampleIndex = i * stride
            let sampleValue = channelData[sampleIndex]
            samples[i] = CGFloat(abs(sampleValue))
        }
        
        return samples
    }
}
