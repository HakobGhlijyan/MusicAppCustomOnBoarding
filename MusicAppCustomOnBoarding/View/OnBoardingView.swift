//
//  OnBoardingView.swift
//  MusicAppCustomOnBoarding
//
//  Created by Hakob Ghlijyan on 20.06.2025.
//

import SwiftUI

struct OnBoardingView: View {
    @Binding var showHomeView: Bool
    @State var currentScreen: DataModel?
    
    var screens: [DataModel] = [
        DataModel(
            title: "OnBoarding",
            detail: "In order to be able to move from phone to next screen you have to drag to the left of each screen that contains an explanatory video to learn more about the application",
            video: "v1"
        ),
        DataModel(
            title: "Expandable Player",
            detail: "After selecting a song, the music view will appear. You can drag it up to expand it with fun animations and more features to have fun.",
            video: "v2"
        ),
        DataModel(
            title: "Music control",
            detail:
                "music control press on the next button to go to the next song or the previous OR play or pass. Also, you can repeat the song",
            video: "v3"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            GeometryReader { geo in
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(screens) { screen in
                                VStack(spacing: 0) {
                                    LoopingPlayerView(videoName: screen.video, videoType: "mp4", isPlaying: currentScreen == screen)
                                    .frame(width: geo.size.width, height: geo.size.height / 1.5)
                                    .scaleEffect(0.85)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(screen.title)
                                            .foregroundStyle(.primary)
                                            .font(.system(size: 45))
                                        Text(screen.detail)
                                            .font(.callout)
                                            .foregroundStyle(.secondary)
                                        
                                        Spacer()
                                        
                                        if screens.last == screen {
                                            Button {
                                                withAnimation { showHomeView = true }
                                            } label: {
                                                Text("Get is Started")
                                                    .bold()
                                                    .frame(height: 55)
                                                    .frame(maxWidth: .infinity)
                                                    .background(.gray.opacity(0.3), in: .capsule)
                                            }
                                            .tint(.white)
                                            .padding(.bottom, 40)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Spacer()
                                
                                }
                                .id(screen)
                                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                        .blur(radius: phase.isIdentity ? 0 : 10)
                                }
                                .onAppear {
                                    currentScreen = screen
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $currentScreen)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                    .ignoresSafeArea()
                    
                    //Indicator
                    HStack(spacing: 10) {
                        ForEach(screens) { screen in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundStyle(currentScreen == screen ? .primary : .secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

#Preview {
    OnBoardingView(showHomeView: .constant(false))
        .preferredColorScheme(.dark)
}
