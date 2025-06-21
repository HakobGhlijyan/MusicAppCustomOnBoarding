//
//  MusicView.swift
//  MusicExpandablePlayer
//
//  Created by Hakob Ghlijyan on 21.06.2025.
//

import SwiftUI

struct MusicView: View {
    var audioPlayer: AudioPlayerViewModel
    
    @State var show = false
    @State var dragOffset: CGFloat = 0
    @State var lastDragPosition: CGFloat = 0
    @State var opacity: Double = 1.0
    @Binding var selectedSong: Song?
    @State var hideing = false
    
    var opacity2: Double {
        show ? max((1 - Double(dragOffset) / 100), 0) : min((Double(dragOffset / 2000)), 1)
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Group {
                    ZStack(alignment: hideing ? .center : .leading) {
                        ImageView(image: selectedSong?.image ?? "", dragOffset: dragOffset, show: show, geo: geo.size)
                        
                        Group {
                            if hideing {
                                VStack {
                                    TextView(name: selectedSong?.title ?? "", dragOffset: dragOffset, show: show, geo: geo.size, opacity: opacity)
                                    
                                    TextView(name: selectedSong?.singer ?? "", dragOffset: dragOffset, show: show, geo: geo.size, opacity: opacity, fontSize: .headline)
                                }
                            } else {
                                HStack {
                                    TextView(name: selectedSong?.title ?? "", dragOffset: dragOffset, show: show, geo: geo.size, opacity: opacity)
                                    
                                    Spacer()
                                    
                                    Button {
                                        audioPlayer.togglePlayPause()
                                    } label: {
                                        Image (systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(Color(.systemGray5), in: .rect(cornerRadius: 16))
                                    }
                                }
                            }
                        }
                        .frame(width: hideing ? nil : geo.size.width - 20)
                    }
                }
                .padding(.top, show ? (geo.size.height / 2 - 300 - dragOffset / 8) : (10 + dragOffset / 10))
                .padding(.leading, show ? 0 : max(10 - dragOffset, 10))
                                
                //Player Controll
                StaticAudioVisualizerView(audioPlayer: audioPlayer, selectedSong: Binding(get: {
                    selectedSong?.filename
                }, set: { newValue in
                    if let filename = newValue {
                        selectedSong = audioPlayer.playlist.first { $0.filename == filename }
                    } else {
                        selectedSong = nil
                    }
                }))
                .opacity(opacity2)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: show ? .infinity : (70 + dragOffset))
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: show ? max(40 - dragOffset / 10 , 24) : min(24 + dragOffset / 10 , 40)))
        .offset(y: show ? dragOffset : 0)
        .gesture(
            DragGesture()
                .onChanged { value in
                    let dragChange = value.translation.height / 2
                    lastDragPosition = value.translation.height
                    
                    if show {
                        withAnimation(.smooth) {
                            dragOffset = dragChange * 2
                            dragOffset = max(0, dragOffset)
                        }
                    } else {
                        dragOffset -= dragChange
                        dragOffset = max(0, dragOffset)
                    }
                    
                    opacity = max((1 - Double(dragOffset) / 100), 0)
                }
                .onEnded { value in
                    lastDragPosition = 0
                    
                    if show && dragOffset > 50 {
                        withAnimation { show = false }
                    } else if !show && dragOffset > 50 {
                        withAnimation { show = true }
                    }
                    
                    withAnimation { dragOffset = 0 }
                    
                    withAnimation {
                        if !show {
                            hideing = false
                        } else {
                            hideing = true
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline:.now() + 0.2) { opacity = 1 }
                }
        )
        .animation(.bouncy(duration: 0.2), value: show)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(show ? (min(dragOffset / 20, 30)) : (30 - min(dragOffset / 20, 30)))
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}

struct ImageView: View {
    var image: String
    var dragOffset: CGFloat
    var show: Bool
    var geo: CGSize
    
    private var sizeWidth: CGFloat {
        show ? max(250 - dragOffset / 4, 50) : min(50 + dragOffset / 4, 250)
    }
    
    private var paddingSize: CGFloat {
        show ? 0 + dragOffset / 3 : max(geo.width - dragOffset / 2 , geo.width / 10)
    }
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: sizeWidth, height: sizeWidth)
            .clipShape(.rect(cornerRadius: 12))
            .padding(.trailing, paddingSize)
    }
}

struct TextView: View {
    var name: String
    var dragOffset: CGFloat
    var show: Bool
    var geo: CGSize
    var opacity: Double
    var fontSize: Font = .title
    
    var body: some View {
        HStack {
            Text(name)
                .font(show ? fontSize : .callout)
                .bold()
                .offset(y: show ? 180 : 0)
                .offset(x: show ? 0 : dragOffset / 5)
                .padding(.leading, show ? 0 : 65)
                .opacity(opacity)
                .animation(.none, value: show)
        }
    }
}
