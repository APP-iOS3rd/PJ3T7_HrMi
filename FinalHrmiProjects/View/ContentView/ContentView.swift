//
//  ContentView.swift
//  FinalHrmiProjects
//
//  Created by 정인선 on 1/26/24.
//

import SwiftUI

struct ContentView: View {
    // 현재 선택된 탭의 인덱스. 초기값 0
    @State private var selectedTabIndex = 0
    @State private var postSearchText = ""
    
    init() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            ForEach(0..<TabItem.tabItems.count, id: \.self) { index in
                let item = TabItem.tabItems[index]
                tabItemView(viewType: item.viewType)
                    .tabItem {
                        // symbolType에 따라 Image 파라미터 다르게 생성
                        switch item.symbolType {
                            // 커스텀된 symbol일 때, Image(_: String) 사용
                        case .customSymbol:
                            Image(item.symbolName)
                            // 탭 선택 시, symbol fill로 변경되게 환경 변수 변경
                                .environment(\.symbolVariants, selectedTabIndex == index ? .fill : .none)
                            // sf symbol 사용할 때, Image(systemName: String) 사용
                        case .sfSymbol:
                            Image(systemName: item.symbolName)
                                .environment(\.symbolVariants, selectedTabIndex == index ? .fill : .none)
                        }
                        Text(item.name)
                            .font(.medium10)
                    }
                    .tag(index)
            }
        }
        .tint(.mainAccent03)
        
    }
    
    // viewType에 따라 특정 View를 리턴해주는 함수
    @ViewBuilder
    private func tabItemView(viewType: ViewType) -> some View {
        switch viewType {
        case .main:
            MainView(selectedTabIndex: $selectedTabIndex)
        case .drinkInfo:
            DrinkInfoView()
        case .posts:
            PostsView(postSearchText: $postSearchText)
        case .liked:
            LikedView()
        case .myPage:
            MypageView()
        }
    }
}

#Preview {
    ContentView()
}