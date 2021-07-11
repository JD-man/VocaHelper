//
//  FirestoreManager.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/04.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    let db = Firestore.firestore()
    
    // MARK: - VocaCollection functions
    
    public func getVocaDocuments(completion: @escaping ([WebData]) -> Void ) {
        db.collection("testCollection").order(by: "date", descending: true).getDocuments { querySnapShot, error in
            if let error = error {
                print(error)
            }
            else {
                guard let snapshot = querySnapShot else {
                    return
                }
                let webDatas: [WebData] =  snapshot.documents.map {
                    var returnedData = WebData(date: "",
                                               title: "",
                                               description: "",
                                               writer: "", like: "",
                                               download: "",
                                               vocas: [Voca(idx: 0, word: "", meaning: "")])
                    do {
                        if let data = try $0.data(as : WebData.self) { returnedData = data }
                    } catch {
                        print(error)
                    }
                    return returnedData
                }
                completion(webDatas)
            }
        }
    }
    
    public func putVocaDocuments() {
        let testVocas = [Voca(idx: 1, word: "test", meaning: "test")]
        let testWebData = WebData(date: "\(Date())", title: "단어장2", description: "간단설명2", writer: "작성자2", like: "888", download: "777", vocas: testVocas)
        
        do {
            try db.collection("testCollection").document("NewData").setData(from: testWebData)
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - UserCollection functions
    
    public func putUserDocuments(nickName: String, email: String, completion: (() -> Void)) {
        let newUser = UserData(nickname: nickName, upload: [])
        do {
            try db.collection("UserCollection").document(email).setData(from: newUser)
            completion()
        } catch {
            print(error)
        }
    }
    
    public func getUserNickName(email: String, completion: @escaping ((String) -> Void)) {
        db.collection("UserCollection").document(email).getDocument { snapshot, error in
            guard let snapshot = snapshot,
                  let dictionary = snapshot.data(),
                  let nickName = dictionary["nickname"] as? String else {
                return
            }
            completion(nickName)
        }
    }
    
    public func checkNickNameExist(nickName: String, completion: @escaping ((Bool) -> Void)) {
        db.collection("UserCollection").getDocuments { querySnapShot, error in
            if let error = error {
                print(error)
            }
            else {
                guard let snapShot = querySnapShot else {
                    return
                }
                var isChecked = false
                for doc in snapShot.documents {
                    if nickName == doc.data()["nickname"] as? String ?? "" {
                        isChecked = true
                        break
                    }
                }
                completion(isChecked)
            }
        }
    }
    
    public func checkEmailExist(email: String, completion: @escaping ((Bool) -> Void)) {
        db.collection("UserCollection").getDocuments { querySnapShot, error in
            if let error = error {
                print(error)
            }
            else {
                guard let snapShot = querySnapShot else {
                    return
                }
                var isChecked = false
                for doc in snapShot.documents {
                    if email == doc.documentID {
                        isChecked = true
                        break
                    }
                }
                completion(isChecked)
            }
        }
    }
}
