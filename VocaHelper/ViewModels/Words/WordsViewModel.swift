//
//  WordsViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/11.
//

import Foundation
import RxSwift

class WordsViewModel {
    
    public var fileNameSubject = BehaviorSubject<[SectionOfWordsCell]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() {
        makeViewModels()
    }
    
    public func makeViewModels() {
        VocaManager().loadFile()
            .map {
                $0.map {
                    return WordsCell(identity: $0, fileName: $0)
                }
            }.subscribe(onNext: { [weak self] in
                self?.fileNameSubject.onNext([SectionOfWordsCell(idx: 0, items: $0)])
            }).disposed(by: disposeBag)
    }
    
    func changeToRealName(fileName: String) -> String {
        return String(fileName[fileName.index(fileName.startIndex, offsetBy: 25) ..< fileName.endIndex])
    }
    
    // 추가버튼 터치시 동작
    public func makeNewViewModels(isAddButton: Bool) {
        if isAddButton {
            VocaManager.shared.makeFile(fileName: "\(Date())Name")
        }
        let newWordCell = VocaManager.shared.fileNames
            .map {
                return WordsCell(identity: $0, fileName: $0)
            }
        fileNameSubject.onNext([SectionOfWordsCell.init(idx: 0, items: newWordCell)])
    }
    
    // MARK: - For PopUpViewContoller
    
    public func willExit(view: PopupViewController) {
        guard let fileNameFromText = view.textField.text,
              let presenting = view.presenting else {
            print("guard")
            return
        }
        //change file name
        let realName = view.fileName
        let datePart = String(realName[realName.startIndex ..< realName.index(realName.startIndex, offsetBy: 25)])
        let currRealName = datePart + fileNameFromText

        guard let directory = VocaManager.directoryURL else {
            return
        }
        let prevName = directory.appendingPathComponent(realName).path
        let currName = directory.appendingPathComponent(currRealName).path

        do {
            try FileManager.default.moveItem(atPath: prevName, toPath: currName)
        } catch {
            print(error)
        }
        VocaManager.shared.saveVocas(fileName: currRealName)
        view.fileName = currRealName
        makeViewModels()
        presenting.tabBarController?.tabBar.isHidden.toggle()
    }
    
    public func didTapEditButton(view: PopupViewController) {
        willExit(view: view)
        view.dismiss(animated: true) { [weak view, weak self] in
            let editVC = EditViewController()
            editVC.navigationItem.title = self?.changeToRealName(fileName: view!.fileName)
            editVC.fileName = view!.fileName
            view?.presenting?.navigationController?.pushViewController(editVC, animated: true)
            view?.presenting?.tabBarController?.tabBar.isHidden.toggle()
        }
    }
}






