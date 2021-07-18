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
    
    public func getVocaDocuments(orderBy: String, loadLimit: Int, completion: @escaping ([WebData]) -> Void ) {
        db.collection("VocaCollection")
            .order(by:orderBy, descending: true)            
            .limit(to: loadLimit)
            .getDocuments { querySnapShot, error in
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
                                               writer: "", like: 0,
                                               download: 0,
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
    
    public func getFilteredVoca() {
        
    }
    
    public func putVocaDocuments(fileName: String, title: String, description: String, vocas: [Voca],
                                 completion: @escaping ((Bool) -> Void)) {
        guard let writer = UserDefaults.standard.value(forKey: "nickname") as? String,
              let email = UserDefaults.standard.value(forKey: "email")  as? String else{
            return
        }
        
        var uploadName = email + " - " + title
        let webData = WebData(date: "\(Date())", title: title, description: description, writer: writer, like: 0, download: 0, vocas: vocas)
        getUserUpload(email: email) { [weak self] result in
            switch result {
            case .success(let uploads):
                let existNum = uploads.filter { $0.starts(with: uploadName)}.count
                if  existNum > 0 {
                    uploadName += "(" + "\(existNum)" + ")"
                }
                do {
                    try self?.db.collection("VocaCollection").document(uploadName).setData(from: webData, completion: { error in
                        if let error = error {
                            print(error)
                            completion(false)
                        }
                        else {
                            self?.db.collection("UserCollection").document(email).updateData(["upload" : FieldValue.arrayUnion([uploadName])], completion: { error in
                                if let error = error {
                                    print(error)
                                    completion(false)
                                }
                                else {
                                    completion(true)
                                }
                            })
                        }
                    })
                } catch {
                    print(error)
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    public func thumbsUp(webVocaName: String) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        db.collection("VocaCollection").document(webVocaName).updateData([
            "like" : FieldValue.increment(Int64(1))
        ])
        db.collection("UserCollection").document(email).updateData([
            "like" : FieldValue.arrayUnion([webVocaName])
        ])
    }
    
    public func deleteThumbsUp(webVocaName: String) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        db.collection("VocaCollection").document(webVocaName).updateData([
            "like" : FieldValue.increment(Int64(-1))
        ])
        db.collection("UserCollection").document(email).updateData([
            "like" : FieldValue.arrayRemove([webVocaName])
        ])
    }
    
    public func downloadNumberUp(webVocaName: String) {
        db.collection("VocaCollection").document(webVocaName).updateData([
            "download" : FieldValue.increment(Int64(1))
        ])
    }
    
    public func changeWebVocaWriter(prevNickname: String, newNickname: String, completion: @escaping ((Bool) -> Void)) {
        db.collection("VocaCollection")
            .whereField("writer", isEqualTo: prevNickname)
            .getDocuments { snapshot, error in
                if let error = error {
                    print(error)
                }
                else {
                    guard let snapshot = snapshot else {
                        return
                    }
                    for doc in snapshot.documents {
                        self.db.collection("VocaCollection").document(doc.documentID).updateData([ "writer" : newNickname])
                    }
                }
            }
    }
    
    public func getWebVocaByWriter(nickName: String, completion: @escaping (([WebData]) -> Void)) {
        db.collection("VocaCollection")
            .whereField("writer", isEqualTo: nickName)
            .getDocuments { snapshot, error in
                if let error = error {
                    print(error)
                }
                else {
                    guard let snapshot = snapshot else {
                        return
                    }
                    let webDatas: [WebData] =  snapshot.documents.map {
                        var returnedData = WebData(date: "",
                                                   title: "",
                                                   description: "",
                                                   writer: "", like: 0,
                                                   download: 0,
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
    
    // MARK: - UserCollection functions
    
    public func putUserDocuments(nickName: String, email: String, completion: ((Bool) -> Void)) {
        let newUser = UserData(nickname: nickName, upload: [], like: [])
        do {
            try db.collection("UserCollection").document(email).setData(from: newUser)
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
    public func getUserDocuments(email: String, completion: @escaping ((Result<[String : Any], Error>) -> Void)) {
        db.collection("UserCollection").document(email).getDocument { snapshot, error in
            if let error = error {
                print(error)
                completion(.failure(error))
            }
            else {
                guard let snapshot = snapshot,
                      let dictionary = snapshot.data() else {
                    return
                }
                completion(.success(dictionary))
            }
        }
    }
    
    public func getUserNickName(email: String, completion: @escaping ((Result<String, Error>) -> Void)) {
        db.collection("UserCollection").document(email).getDocument { snapshot, error in
            if let error = error {
                print(error)
                completion(.failure(error))
            }
            else {
                guard let snapshot = snapshot,
                      let dictionary = snapshot.data(),
                      let nickName = dictionary["nickname"] as? String else {
                    return
                }
                completion(.success(nickName))
            }
        }
    }
    
    public func getUserUpload(email: String, completion: @escaping ((Result<[String], Error>) -> Void)) {
        db.collection("UserCollection").document(email).getDocument { snapshot, error in
            if let error = error {
                print(error)
                completion(.failure(error))
            }
            else{
                guard let snapshot = snapshot,
                      let dictionary = snapshot.data(),
                      let uploads = dictionary["upload"] as? [String] else {
                    return
                }
                completion(.success(uploads))
            }
        }
    }
    
    public func getUserLike(email: String, completion: @escaping ((Result<[String], Error>) -> Void)) {
        db.collection("UserCollection").document(email).getDocument { snapshot, error in
            if let error = error {
                print(error)
                completion(.failure(error))
            }
            else{
                guard let snapshot = snapshot,
                      let dictionary = snapshot.data(),
                      let likes = dictionary["like"] as? [String] else {
                    return
                }
                completion(.success(likes))
            }
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
    
    public func changeUserNickname(newNickname: String, email: String, completion: @escaping ((Bool) -> Void)) {
        db.collection("UserCollection").document(email).updateData(["nickname" : newNickname]) { error in
            if let error = error {
                print(error)
                completion(false)
            }
            else {
                completion(true)
            }
        }
    }
}

