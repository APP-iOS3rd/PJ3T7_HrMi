//
//  NavigationRouter.swift
//  JUDA
//
//  Created by phang on 2/27/24.
//

import SwiftUI

enum Route: Hashable{
    case Login
    case AddTag
    case AlarmStore
    case Setting
    case Notice
    case ChangeUserName
    case Record(recordType: RecordType)
    case NavigationProfile(postUserName: String,
                           postUserID: String,
                           usedTo: WhereUsedPostGridContent)
    case NavigationPosts(usedTo: WhereUsedPostGridContent,
                         searchTagType: SearchTagType?,
                         taggedPostID: [String]?,
                         selectedDrinkName: String?,
                         selectedFoodTag: String?)
    case NavigationPostsTo(usedTo: WhereUsedPostGridContent,
                           searchTagType: SearchTagType)
    case DrinkDetail(drink: FBDrink)
    case DrinkDetailWithUsedTo(drink: FBDrink,
                     usedTo: WhereUsedDrinkDetails)
    case PostDetail(postUserType: PostUserType,
                    post: Post,
                    usedTo: WhereUsedPostGridContent,
                    postPhotosURL: [URL])
}

final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func clear() {
        path = .init()
    }
    
    func back() {
        path.removeLast()
    }
    
    func push(to screen: Route) {
//        path.append(screen)
    }
}
