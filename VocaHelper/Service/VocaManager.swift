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
    static let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
    let disposableBag = DisposeBag()
    
    /// Get Name of files which is saved in phone storage
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
    
    /// Make voca from Filename
    func makeVoca(fileName: String) -> Observable<[Voca]> {
        return Observable<[Voca]>.create() {emitter in
            // 저장파일을 가져와야함
            let decoder = JSONDecoder()
            guard let directory = VocaManager.directoryURL else {
                return Disposables.create()
            }
            let path = directory.appendingPathComponent(fileName)
            do {
                let data = try Data(contentsOf: path)
                let vocaData  = try decoder.decode(VocaData.self, from: data)                
                emitter.onNext(vocaData.vocas)
            } catch {
                print(error)
            }
            return Disposables.create()
        }
    }

}
