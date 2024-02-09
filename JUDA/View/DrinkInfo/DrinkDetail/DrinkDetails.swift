//
//  DrinkDetails.swift
//  JUDA
//
//  Created by phang on 1/30/24.
//

import SwiftUI

// MARK: - 술 디테일에서 보여주는 상단의 술 정보 부분 (이미지, 이름, 가격 등)
struct DrinkDetails: View {
    // UITest - Drink DummyData
    private let sampleData = DrinkDummyData.sample
    private let numberOfTagged = 12 // 해당 술이 태그된 게시물 수

    var body: some View {
        // 술 정보 (이미지, 이름, 나라, 도수, 가격, 별점, 태그된 게시물)
        HStack(alignment: .center, spacing: 30) {
            // 술 이미지
            Image(sampleData.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 180)
                .padding(10)
                .frame(width: 100)
            // 이름, 나라, 도수, 가격, 별점, 태그된 게시물
            VStack(alignment: .leading, spacing: 10) {
                // 이름
                Text(sampleData.name)
                    .font(.semibold18)
                    .foregroundStyle(.mainBlack)
                    .lineLimit(2)
                HStack {
                    // 나라
                    Text(sampleData.origin)
                        .font(.regular16)
                    // 도수
                    Text(Formatter.formattedABVCount(abv: sampleData.abv))
                        .font(.regular16)
                }
                // 가격
                Text(sampleData.price)
                    .font(.regular16)
                // 별점
                StarRating(rating: sampleData.rating, color: .mainAccent05,
                           starSize: .regular16, fontSize: .regular16, starRatingType: .withText)
                // 태그된 게시물
                // TODO: NavigationLink - value 로 수정
                NavigationLink {
					NavigationPostsView(postSearchText: sampleData.name)
                } label: {
                    Text("\(numberOfTagged)개의 태그된 게시물")
                        .font(.regular16)
                        .foregroundStyle(.gray01)
                        .underline()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview {
    DrinkDetails()
}