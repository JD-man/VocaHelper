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
    
    var vocas: [Voca] = []
    lazy var vocasCount = vocas.count
    
    var fileNames: [String] = []
    lazy var fileCount = fileNames.count
    
    
    // 검색을 위한 모든 단어장 데이터, 메모리에 남아있지않게 검색이 끝나면 nil을 넣어 해제해줘야한다.
    var allVocasForSearch: [VocaData]?
        
    let disposableBag = DisposeBag()
    
    /// Get Name of files which is saved in phone storage
    func loadFile() -> Observable<[String]> {
        return Observable.create() { emitter in
            let fileManager = FileManager.default
            guard let directory = VocaManager.directoryURL else {
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
                VocaManager.shared.fileNames = fileNames
                
                emitter.onNext(fileNames)
            }
            catch {
                print(error)
            }
            return Disposables.create()
        }
    }
    
    /// Make file which is saved in phone storage
    func makeFile() {
        let newFileName = "\(Date())Name"
        
        _ = fileNames.popLast()
        fileNames.append(newFileName)
        fileNames.append("ButtonCell")
        
        // 빈 파일 하나 추가
        let newVocaData = VocaData(fileName: newFileName, vocas: [Voca(idx: vocas.count, word: "word", meaning: "meaning")])
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            //print(directory)
            guard let directory = VocaManager.directoryURL else {
                return
            }
            let path = directory.appendingPathComponent(newFileName)
            let data = try encoder.encode(newVocaData)
            try data.write(to: path)
        }
        catch {
            print(error)
        }
    }
    
    
    /// Delete VocaFile from Storage
    func deleteFile(fileName: String) {
        guard let index = VocaManager.shared.fileNames.firstIndex(of: fileName),
              let directory = VocaManager.directoryURL else{
            return
        }
        let path = directory.appendingPathComponent(fileName)
        fileNames.remove(at: index)
        if let error = try? FileManager.default.removeItem(atPath: path.path) {
            print(error)
        } else {
            return
        }
    }
    
    func makeAllVocasForSearch(title: String) {
        if title == "Search" {
            allVocasForSearch = fileNames.filter {$0 != "ButtonCell"}.map {
                let decoder = JSONDecoder()
                guard let directory = VocaManager.directoryURL else {
                    return VocaData(fileName: "", vocas: [])
                }
                let path = directory.appendingPathComponent($0)
                var vocaData: VocaData = VocaData(fileName: "", vocas: [])
                do {
                    let data = try Data(contentsOf: path)
                    vocaData  = try decoder.decode(VocaData.self, from: data)
                    return vocaData
                } catch {
                    print(error)
                }
                return vocaData
            }
        }
        else {
            allVocasForSearch = nil
        }
        //print(allVocasForSearch)
    }

    
    /// Make voca from Filename
    public func loadVocas(fileName: String) -> Observable<[Voca]> {
        return Observable<[Voca]>.create() { [weak self] emitter in
            // 저장파일을 가져와야함
            //self?.loadVocasLocal(fileName: fileName)
            emitter.onNext(self?.vocas ?? [Voca]())
            return Disposables.create()
        }
    }
    
    public func loadVocasLocal(fileName: String) {
        let decoder = JSONDecoder()
        guard let directory = VocaManager.directoryURL else {
            return
        }
        let path = directory.appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: path)
            let vocaData  = try decoder.decode(VocaData.self, from: data)
            vocas = vocaData.vocas
        } catch {
            print(error)
        }
    }
    
    /// Make and Save VocaData
    public func saveVocas(fileName: String) {
        let vocaData = VocaData(fileName: fileName, vocas: vocas)        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            guard let directory = VocaManager.directoryURL else {
                return
            }
            let path = directory.appendingPathComponent(fileName)
            let data = try encoder.encode(vocaData)
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
}
