//
//  FirestoreManager.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/04.
//

import Foundation
import FirebaseFirestore

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    let db = Firestore.firestore()
    
    public func getData() {
        db.collection("testCollection").order(by: "UploadTime", descending: true).getDocuments { querySnapShot, error in
            if let error = error {
                print(error)
            }
            else {
                guard let snapshot = querySnapShot else {
                    return
                }
                print(snapshot.documents.forEach {print($0.documentID)})
            }
        }
    }
    
    public func putDocuments() {
        let dict: [String : String] = [
            "일" : "1",
            "이" : "2",
            "삼" : "3",
            "사" : "4",
            "오" : "5",
            "육" : "6"
        ]
        let data: [String : Any] = [
            "UploadTime" : "\(Date())",
            "Data" : dict
        ]
        
        db.collection("testCollection").document("z").setData(data) { err in
            if let err = err {
                print(err)
            }
            else {
                print("upload!")
            }
        }
    }
}
