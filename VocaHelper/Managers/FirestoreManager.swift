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
    
    public func getData(completion: @escaping ([WebData]) -> Void ) {
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
    
    public func putDocuments() {
        let testVocas = [Voca(idx: 1, word: "test", meaning: "test")]
        let testWebData = WebData(date: "2", title: "단어장2", description: "간단설명2", writer: "작성자2", like: "888", download: "777", vocas: testVocas)
        
        do {
            try db.collection("testCollection").document("NewData").setData(from: testWebData)
        } catch let error {
            print(error)
        }
    }
}
