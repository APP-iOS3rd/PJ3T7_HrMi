//
//  MainView.swift
//  FinalHrmiProjects
//
//  Created by 홍세희 on 2024/01/24.
//

import SwiftUI

struct MainView: View {
    @State private var isLoggedIn = false
    var body: some View {
        NavigationView {
            VStack(alignment:.center) {
                VStack(alignment:.center, spacing: 20) {
                    WeatherView(isLoggedIn: $isLoggedIn)
                        .padding(.bottom, 20)
                    SuggestSulView(isLoggedIn: $isLoggedIn)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    MainView()
}

