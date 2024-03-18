//
//  LikedDrinkList.swift
//  JUDA
//
//  Created by phang on 1/31/24.
//

import SwiftUI

// MARK: - 술찜 리스트 탭 화면
struct LikedDrinkList: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        if let user = authViewModel.currentUser,
           !user.likedDrinks.isEmpty {
            // MARK: iOS 16.4 이상
            if #available(iOS 16.4, *) {
                ScrollView() {
                    LikedDrinkListContent()
                }
                .scrollBounceBehavior(.basedOnSize, axes: .vertical)
                // MARK: iOS 16.4 미만
            } else {
                ViewThatFits(in: .vertical) {
                    LikedDrinkListContent()
                        .frame(maxHeight: .infinity, alignment: .top)
                    ScrollView {
                        LikedDrinkListContent()
                    }
                }
            }
        } else {
            Text("좋아하는 술이 없어요!")
                .font(.medium16)
                .foregroundStyle(.mainBlack)
        }
    }
}

// MARK: - 스크롤 뷰 or 뷰 로 보여질 술찜 리스트
struct LikedDrinkListContent: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        if let user = authViewModel.currentUser, 
            !user.likedDrinks.isEmpty {
            LazyVStack {
                ForEach(user.likedDrinks, id: \.drinkField.drinkID) { drink in
                    NavigationLink(value: Route
                        .DrinkDetailWithUsedTo(drink: drink,
                                               usedTo: .liked)) {
                        DrinkListCell(drink: drink,
                                      usedTo: .liked)
                    }
                                               .buttonStyle(EmptyActionStyle())
                }
            }
        }
    }
}

#Preview {
    LikedDrinkList()
}