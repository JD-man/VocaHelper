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
        db.collection("VocaCollection").order(by: "date", descending: true).getDocuments { querySnapShot, error in
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
    
    public func putVocaDocuments(fileName: String, title: String, description: String, vocas: [Voca]) {
//        guard let writer = UserDefaults.standard.value(forKey: "nickname") as? String else {
//            return
//        }
        let testWebData = WebData(date: "\(Date())", title: title, description: description, writer: "TesterA", like: "0", download: "0", vocas: vocas)
        do {
            try db.collection("VocaCollection").document(fileName).setData(from: testWebData)
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
