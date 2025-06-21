//
//  HomeView.swift
//  MusicAppCustomOnBoarding
//
//  Created by Hakob Ghlijyan on 20.06.2025.
//

import SwiftUI
import AVFoundation
import Observation

struct HomeView: View {
    @State var audioPlayer = AudioPlayerViewModel()
    @State private var selectedSong: Song?
    
    var body: some View {
        ZStack {
            //LIST Music
            ScrollView {
                VStack(spacing: 16) {
                    Text("Discover Music")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(audioPlayer.playlist, id: \.filename) { song in
                        HStack {
                            Image(song.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(.rect(cornerRadius: 16))
                            
                            VStack(alignment: .leading) {
                                Text(song.title)
                                Text(song.singerInfo)
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Text("\(audioPlayer.durationText(for: song))")
                                .foregroundStyle(.gray)
                        }
                        .padding(10)
                        .background(Color(.systemGray6), in: .rect(cornerRadius: 24))
                        .onTapGesture {
                            withAnimation {
                                selectedSong = song
                                audioPlayer.loadAudioFile(for: song)
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding(12)
            .safeAreaPadding(.bottom, 80)
            
            //Player
            if selectedSong != nil {
                MusicView(audioPlayer: audioPlayer, selectedSong: $selectedSong)
                    .transition(.offset(y: 200))
            }
        }
        .onAppear {
            audioPlayer.onTrackChange = { newSong in
                selectedSong = audioPlayer.playlist.first { $0.filename == newSong }
            }
        }
        .navigationTitle("Discover Your Music")
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
