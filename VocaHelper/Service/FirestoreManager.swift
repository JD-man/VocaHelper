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
        db.collection("testCollection").getDocuments { querySnapShot, error in
            if let error = error {
                print(error)
            }
            else {
                guard let snapshot = querySnapShot else {
                    return
                }
                print(snapshot.documents[0].data())
            }
        }
    }
    
    public func putDocuments() {
        let data: [String : String] = [
            "일" : "1",
            "이" : "2",
            "삼" : "3",
            "사" : "4"
        ]
        
        db.collection("testCollection").addDocument(data: data)
    }
}
