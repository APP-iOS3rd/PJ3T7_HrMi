//
//  SuggestSulView.swift
//  FinalHrmiProjects
//
//  Created by 백대홍 on 1/29/24.
//

import SwiftUI
// MARK: - 오늘의 추천 술 전체 뷰
struct SuggestDrinkCell: View {
    @Binding var isLoggedIn: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment:.leading, spacing: 10) {
                Text("오늘의 추천 술")
                    .font(.semibold18)
                
                TodayDrinkView(todaySul: TodaysulData)
                    .opacity(isLoggedIn ? 1.0 : 0.8)
                    .blur(radius: isLoggedIn ? 0 : 3)
            }
            .padding(.top,30)

        }
    }
}
