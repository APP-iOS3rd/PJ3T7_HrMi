//
//  RecordViewModel.swift
//  JUDA
//
//  Created by 정인선 on 3/10/24.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class RecordViewModel: ObservableObject {
    // post 업로드용 Post 객체
    @Published var post: Post?
    // post 작성자 정보를 갖는 WrittenUser 객체
    @Published var writtenUser: WrittenUser?
    // post의 전체 술 평가 정보를 갖는 DrinkTag 배열
    @Published var drinkTags = [DrinkTag]()
    @Published var selectedDrinkTag: DrinkTag?
    // 라이브러리에서 선택된 모든 사진 Data
    @Published var selectedImages = [UIImage]()
    // 모든 imagesURL을 갖는 배열
    var imagesURL = [URL]()
    // 글 내용을 담는 프로퍼티
    @Published var content: String = ""
    // 음식 태그를 담는 배열
    @Published var foodTags = [String]()
    
    // 화면 너비 받아오기
    var windowWidth: CGFloat {
        TagHandler.getScreenWidthWithoutPadding(padding: 20)
    }
    
    // post 업로드, iamges 업로드를 위한 postID
    private var postID = ""

    // firebase Post Service
    private let firestorePostService = FirestorePostService()
    // Firebase Drink Service
    private let firestoreDrinkService = FirestoreDrinkService()
    // FireStorage Service
    private let fireStorageService = FireStorageService()
    
    // Firestore db 연결
    private let db = Firestore.firestore()
    
    // MARK: - FireStroage post 이미지 업로드 및 이미지 URL 받아오기
    func uploadMultipleImagesToFirebaseStorageAsync() async {
        guard let user = writtenUser else { return }
        do {
            // postID 생성
            postID = UUID().uuidString
            // 결과를 받을 배열 생성
            var downloadURLs: [(Int, URL)] = []
            
            // 이미지 업로드 병렬처리를 위한 taskGroup
            try await withThrowingTaskGroup(of: (Int, URL).self) { group in
                for (index, image) in selectedImages.enumerated() {
                    // 각 이미지 데이터에 대해 비동기 업로드 작업 실행 및 배열에 추가
                    group.addTask {
                        // storage 폴더링을 위한 userID
                        let userID = user.userID
                        // image fileName 생성
                        let imageID = UUID().uuidString
                        // storage에 이미지 업로드
                        try await self.fireStorageService.uploadImageToStorage(folder: .post, userID: userID , postID: self.postID, image: image, fileName: imageID)
                        // storage에서 이미지 URL 받아오기
                        let imageURL = try await self.fireStorageService.fetchImageURL(folder: .post, fileName: imageID)
                        // (이미지 순서, URL) 반환
                        return (index, imageURL)
                    }
                }
                
                // task 반환값을 결과 배열에 저장
                for try await downloadURL in group {
                    downloadURLs.append(downloadURL)
                }
                // post의 imagesURL에 index순으로 정렬된 URL 배열 저장
                imagesURL = downloadURLs.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
            }
        } catch FireStorageError.uploadImage {
            print("error :: uploadImageToStorage() -> upload Image data to FireStorage failure")
        } catch FireStorageError.fetchImageURL {
            print("error :: fetchImageURL() -> get Image URL from FireStorage failure")
        } catch {
            print("error :: uploadMultipleImagesToFirebaseStorageAsync() -> upload Multiple Images failure")
        }
    }
    
    // MARK: - Firestore post 업로드
    func uploadPost() async {
        guard let post = post else { return }
        do {
            try await firestorePostService.uploadPostDocument(post: post, postID: postID)
        } catch PostError.upload {
            print("error :: uploadPostDocument() -> upload post to Firestore failure")
        } catch {
            print("error :: uploadPost() -> upload post failure")
        }
    }
    
    // MARK: - Firestore drink 업로드
    func updateDrink() async {
        guard let post = post, let user = writtenUser else { return }
        do {
            let drinkRef = db.collection("drinks")
            for drinkTag in drinkTags {
                let drinkID = drinkTag.drinkID
                let drinkRoute = drinkRef.document(drinkID)
                // 해당 술 정보 가져오기
                let drinkData = try await firestoreDrinkService.fetchDrinkDocument(document: drinkRoute)
                
                // post 내 술 평가가 4점 이상일 때 agePreference, genderPreference update
                if drinkTag.drinkRating >= 4 {
                    let userID = user.userID
                    let userGender = user.userGender
                    var userAge: Age {
                        switch user.userAge {
                        case ...29:
                            return Age.twenty
                        case 30...39:
                            return Age.thirty
                        case 40...49:
                            return Age.fourty
                        default:
                            return Age.fifty
                        }
                    }

                    // Drink genderPreference/userGender 에 userID 추가
                    await firestoreDrinkService.updateDrinkGenderPreference(ref: drinkRef, drinkID: drinkID, gender: userGender, userID: userID)
                    // Drink agePreference/userAge 에 userID 추가
                    await firestoreDrinkService.updateDrinkAgePreference(ref: drinkRef, drinkID: drinkID, age: userAge, userID: userID)
                }
                // rating
                let prev = drinkData.drinkField.rating
                let new = drinkTag.drinkRating
                let count = drinkData.taggedPosts.count
                let rating = calcDrinkRating(prev: prev, new: new, count: count)
                
                // Drink rating update
                // TODO: return 값 처리
                let result = await firestoreDrinkService.updateDrinkField(ref: drinkRef, drinkID: drinkID, data: ["rating": rating])
            }
        } catch DrinkError.fetchDrinkDocument {
            print("error :: updateDrinkField() -> update drink data to Firestore failure")
        } catch {
            print("error :: updateDrink() -> update drink data failure")
        }
    }
    
    // 기존 rating을 받아서 새로 계산
    private func calcDrinkRating(prev: Double, new: Double, count: Int) -> Double {
        return (prev * Double(count) + new) / (Double(count) + 1)
    }
    
    // MARK: - post Data 초기화
    func recordPostDataClear() {
        post = nil
        drinkTags = []
        selectedImages = []
        content = ""
        foodTags = []
        postID = ""
    }
}
