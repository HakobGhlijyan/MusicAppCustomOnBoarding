//
//  LoopingPlayerView.swift
//  MusicAppCustomOnBoarding
//
//  Created by Hakob Ghlijyan on 20.06.2025.
//

import SwiftUI
import AVKit

struct LoopingPlayerView: UIViewRepresentable {
    var videoName: String
    var videoType: String
    var isPlaying: Bool

    func makeUIView(context: Context) -> some UIView {
        PlayerUIView(frame: .zero, videoName: videoName, videoType: videoType)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let playerUIView = uiView as? PlayerUIView {
            isPlaying ? playerUIView.player.play() : playerUIView.player.pause()
        }
    }
    
    static func dismantleUIView(_ uiView: UIViewType, coordinator: ()) {
        (uiView as? PlayerUIView)?.player.pause()
    }
}

class PlayerUIView: UIView {
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    init(frame: CGRect, videoName: String, videoType: String) {
        super.init(frame: frame)
        guard let url = Bundle.main.url(forResource: videoName, withExtension: videoType) else { return }
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            self?.player.seek(to: .zero)
            self?.player.play()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    override func layoutSubviews() {
        playerLayer.frame = bounds
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
}
