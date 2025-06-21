//
//  RootView.swift
//  MusicAppCustomOnBoarding
//
//  Created by Hakob Ghlijyan on 20.06.2025.
//

import SwiftUI

struct RootView: View {
    @State var showHomeView: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                if showHomeView {
                    HomeView()
                        .transition(.slide)
                } else {
                    OnBoardingView(showHomeView: $showHomeView)
                }
            }
        }
    }
}

#Preview {
    RootView().preferredColorScheme(.dark)
}
