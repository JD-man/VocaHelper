//
//  VocaViewModelList.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/12.
//

import Foundation
import RxSwift

class VocaViewModelList {
    var vocaSubject = BehaviorSubject<[VocaViewModel]>(value: [])
    let disposeBag = DisposeBag()
    
    init(fileName: String) {
        makeViewModels(fileName: fileName)
    }
    
    /// Load Voca ViewModel
    public func makeViewModels(fileName: String) {
        VocaManager.shared.makeVoca(fileName: fileName)
            .map {
                $0.map {
                    return VocaViewModel(id: $0.id, word: $0.word, meaning: $0.meaning)
                }
            }.subscribe(onNext: { [weak self] in
                self?.vocaSubject.onNext($0)
            }).disposed(by: disposeBag)
    }
    
    /// Make and Save VocaData
    public func makeVocas(tableView: UITableView, fileName: String, isNewLine: Bool) {
        var vocaData = VocaData(vocas: [])
        for i in 0 ..< tableView.numberOfRows(inSection: 0) {
            let indexPath = IndexPath(row: i, section: 0)
            // datasource로 모든셀에 접근할 수 있다.
            guard let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath) as? EditTableViewCell else {
                return
            }
            let voca = Voca(id: i, word: cell.wordTextField.text!, meaning: cell.meaningTextField.text!)
            vocaData.vocas.append(voca)
        }
        if isNewLine {
            vocaData.vocas.append(Voca(id: vocaData.vocas.count, word: "", meaning: ""))
        }        
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
    
    /// Add blank voca and Remake ViewModel
    public func addNewLine(tableView: UITableView, fileName: String, isNewLine: Bool) {
        // 추가할때 애니메이션하는법 생각해보기
        makeVocas(tableView: tableView, fileName: fileName, isNewLine: true)
        makeViewModels(fileName: fileName)
        let indexPath = IndexPath.init(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
