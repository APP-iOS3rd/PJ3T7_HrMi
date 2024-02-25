//
//  MainView.swift
//  JUDA
//
//  Created by 홍세희 on 2024/01/24.
//

import SwiftUI
import Lottie

// MARK: - 메인 탭
struct MainView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var authService: AuthService
    
	@Binding var selectedTabIndex: Int
	
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                // 날씨 와 어울리는 술 + 안주
                WeatherAndFood()
                Spacer()
                // 오늘의
                DrinkTopView(selectedTabIndex: $selectedTabIndex)
                Spacer()
                PostTopView(selectedTabIndex: $selectedTabIndex)
            }
            .padding(.bottom, 15)
            .padding(.horizontal, 20)
            .onAppear {
                appViewModel.tabBarState = .visible
            }
        }
        .toolbar(appViewModel.tabBarState, for: .tabBar)
    }
}

#Preview {
	MainView(selectedTabIndex: .constant(0))
}
