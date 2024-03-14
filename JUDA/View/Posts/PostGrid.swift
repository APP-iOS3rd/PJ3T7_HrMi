//
//  PostGrid.swift
//  JUDA
//
//  Created by Minjae Kim on 1/30/24.
//

import SwiftUI

// MARK: - 어느 뷰에서 PostGridContent 이 사용되는지 enum
enum WhereUsedPostGridContent {
    case post
    case postSearch
	case postFoodTag
    case drinkDetail
    case liked
    case myPage
    case main
}

// MARK: - 스크롤 뷰 or 뷰 로 보여질 post grid
struct PostGrid: View {
	@EnvironmentObject private var postViewModel: PostViewModel
    
    @State private var scrollAxis: Axis.Set = .vertical
    @State private var vHeight = 0.0
    
    let usedTo: WhereUsedPostGridContent
	let searchTagType: SearchTagType?
    
    init(usedTo: WhereUsedPostGridContent = .post, searchTagType: SearchTagType?) {
        self.usedTo = usedTo
		self.searchTagType = searchTagType
    }
	
    var body: some View {
        // MARK: iOS 16.4 이상
        if #available(iOS 16.4, *) {
            ScrollView() {
				PostGridContent(usedTo: usedTo, searchTagType: searchTagType)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .scrollDismissesKeyboard(.immediately)
            .refreshable {
                await postViewModel.fetchFirstPost()
            }
        // MARK: iOS 16.4 미만
        } else {
            ViewThatFits(in: .vertical) {
				PostGridContent(usedTo: usedTo, searchTagType: searchTagType)
                    .frame(maxHeight: .infinity, alignment: .top)
                ScrollView {
					PostGridContent(usedTo: usedTo, searchTagType: searchTagType)
                }
                .scrollDismissesKeyboard(.immediately)
                .refreshable {
                    await postViewModel.fetchFirstPost()
                }
            }
        }
    }
}

// MARK: - 스크롤 뷰 or 뷰 로 보여질 post grid 내용 부분
struct PostGridContent: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var postViewModel: PostViewModel
	@EnvironmentObject private var userViewModel: UserViewModel
    
    let usedTo: WhereUsedPostGridContent
	let searchTagType: SearchTagType?
    let userType: UserType
    
    init(usedTo: WhereUsedPostGridContent, searchTagType: SearchTagType?, userType: UserType = .user) {
        self.usedTo = usedTo
        self.searchTagType = searchTagType
        self.userType = userType
    }
	
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            if usedTo == .post {
				if !postViewModel.isLoading {
					ForEach(postViewModel.posts, id: \.postField.postID) { post in
                        NavigationLink(value: Route
                            .PostDetail(postUserType: authViewModel.currentUser?.userField.userID == post.postField.user.userID ? .writter : .reader,
                                        post: post,
                                        usedTo: usedTo,
                                        postPhotosURL: post.postField.imagesURL)) {
                            PostCell(usedTo: .post, post: post)
                                .task {
                                    if post == postViewModel.posts.last {
                                        await postViewModel.fetchNextPost()
                                    }
                                }
                        }
						.buttonStyle(EmptyActionStyle())
						// TODO: 비로그인 상태인 경우 눌렀을 때 로그인뷰로 이동
						.disabled(!authViewModel.signInStatus)
					}
				} else {
					ForEach(0..<10) { _ in
						ShimmerPostCell()
					}
				}
			} else if usedTo == .postSearch {
				if let searchTagType = searchTagType {
					switch searchTagType {
					case .userName:
                        ForEach(postViewModel.searchPostsByUserName, id: \.postField.postID) { post in
							NavigationLink(value: Route
                                .PostDetail(postUserType: authViewModel.currentUser?.userField.userID == post.postField.user.userID ? .writter : .reader,
                                            post: post,
                                            usedTo: usedTo,
                                            postPhotosURL: post.postField.imagesURL)) {
								PostCell(usedTo: .postSearch, post: post)
							}
							.buttonStyle(EmptyActionStyle())
							// TODO: 비로그인 상태인 경우 눌렀을 때 로그인뷰로 이동
							.disabled(!authViewModel.signInStatus)
						}
					case .drinkTag:
						ForEach(postViewModel.searchPostsByDrinkTag, id: \.postField.postID) { post in
							NavigationLink(value: Route
                                .PostDetail(postUserType: authViewModel.currentUser?.userField.userID == post.postField.user.userID ? .writter : .reader,
                                            post: post,
                                            usedTo: usedTo,
                                            postPhotosURL: post.postField.imagesURL)) {
								PostCell(usedTo: .postSearch, post: post)
							}
							.buttonStyle(EmptyActionStyle())
							// TODO: 비로그인 상태인 경우 눌렀을 때 로그인뷰로 이동
							.disabled(!authViewModel.signInStatus)
						}
					case .foodTag:
						ForEach(postViewModel.searchPostsByFoodTag, id: \.postField.postID) { post in
							NavigationLink(value: Route
                                .PostDetail(postUserType: authViewModel.currentUser?.userField.userID == post.postField.user.userID ? .writter : .reader,
                                            post: post,
                                            usedTo: usedTo,
                                            postPhotosURL: post.postField.imagesURL)) {
								PostCell(usedTo: .postSearch, post: post)
							}
							.buttonStyle(EmptyActionStyle())
							// TODO: 비로그인 상태인 경우 눌렀을 때 로그인뷰로 이동
							.disabled(!authViewModel.signInStatus)
						}
					}
				}
			} else if usedTo == .postFoodTag {
				ForEach(postViewModel.searchPostsByFoodTag, id: \.postField.postID) { post in
					NavigationLink(value: Route
                        .PostDetail(postUserType: authViewModel.currentUser?.userField.userID == post.postField.user.userID ? .writter : .reader,
                                    post: post,
                                    usedTo: usedTo,
                                    postPhotosURL: post.postField.imagesURL)) {
						PostCell(usedTo: .postSearch, post: post)
					}
					.buttonStyle(EmptyActionStyle())
					// TODO: 비로그인 상태인 경우 눌렀을 때 로그인뷰로 이동
					.disabled(!authViewModel.signInStatus)
				}
			} else if usedTo == .drinkDetail {
                if !postViewModel.isLoading {
                    ForEach(postViewModel.drinkTaggedPosts, id: \.postField.postID) { post in
                        NavigationLink(value: Route
                            .PostDetail(postUserType: authViewModel.currentUser?.userField.userID == post.postField.user.userID ? .writter : .reader,
                                        post: post,
                                        usedTo: usedTo,
                                        postPhotosURL: post.postField.imagesURL)) {
							PostCell(usedTo: usedTo, post: post)
                        }
                    }
                } else {
                    ForEach(0..<6) { _ in
                        ShimmerPostCell()
                    }
                }
            } else if usedTo == .myPage {
                if !userViewModel.isLoading {
                    if userType == .user {
                        ForEach(authViewModel.currentUser?.posts, id: \.postField.postID) { post in
                            NavigationLink(value: Route
                                .PostDetail(postUserType: .writter,
                                            post: post,
                                            usedTo: usedTo,
                                            postPhotosURL: post.postField.imagesURL)) {
                                PostCell(usedTo: usedTo, post: post)
                            }
                        }
                    } else {
                        ForEach(userViewModel.user?.posts, id: \.postField.postID) { post in
                            NavigationLink(value: Route
                                .PostDetail(postUserType: .reader,
                                            post: post,
                                            usedTo: usedTo,
                                            postPhotosURL: post.postField.imagesURL)) {
                                PostCell(usedTo: usedTo, post: post)
                            }
                        }
                    }
                } else {
                    ForEach(0..<4) { _ in
                        ShimmerPostCell()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
