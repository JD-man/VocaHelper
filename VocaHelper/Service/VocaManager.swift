//
//  VocaManager.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/11.
//

import Foundation
import RxSwift

final class VocaManager {
    static let shared = VocaManager()
    
    let disposableBag = DisposeBag()
    
//    var fileNames: [String] = []
//    var fileCount: Int = 0
    
    func fileLoad() -> Observable<[String]> {
        return Observable.create() { emitter in
            let fileManager = FileManager.default
            guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return Disposables.create()
            }
            do {
                var fileNames = try fileManager.contentsOfDirectory(atPath: directory.path)
                if fileNames.contains(".DS_Store") {
                    guard let dsStoreIdx =  fileNames.firstIndex(of: ".DS_Store") else {
                        return Disposables.create()
                    }
                    fileNames.remove(at: dsStoreIdx)
                }
                fileNames.sort()
                fileNames.append("ButtonCell")
                emitter.onNext(fileNames)
            }
            catch {
                print(error)
            }
            return Disposables.create()
        }
    }
}
