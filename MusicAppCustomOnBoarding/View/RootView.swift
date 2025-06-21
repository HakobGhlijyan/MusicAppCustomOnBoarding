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
        ZStack {
            if showHomeView {
                HomeView()
                    .transition(.scale(0, anchor: .trailing))
            } else {
                OnBoardingView(showHomeView: $showHomeView)
                    .transition(.scale(0, anchor: .leading))
            }
        }
    }
}

#Preview {
    RootView().preferredColorScheme(.dark)
}
