//
//  WordsViewModelList.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/12.
//

import Foundation
import RxSwift
import RxDataSources

struct WordsCell: Equatable, IdentifiableType {
    
    // ==일때 false로 해야 파일추가가 제대로 된다. addbutton의 identity가 바뀌어서 그런듯.
    // true로 설정하면 메모리누수가 일어나지 않는다. 추가버튼을 다른곳에 만들어야할듯.
    static func == (lhs: WordsCell, rhs: WordsCell) -> Bool {
        if lhs.identity == rhs.identity { return true }
        else {return true}
    }
    
    typealias Identity = String
    
    var identity: String
    var fileName: String
    
    init(identity: String, fileName: String) {
        self.identity = identity
        self.fileName = fileName
    }
    
    func changeToRealName(fileName: String) -> String {
        return String(fileName[fileName.index(fileName.startIndex, offsetBy: 25) ..< fileName.endIndex])
    }
    
    // 단어장 터치시 동작
    func didTapWordButton(view: WordsViewController) {
        VocaManager.shared.loadVocasLocal(fileName: fileName)
        let popupVC = PopupViewController()
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.textField.text = changeToRealName(fileName: fileName)
        view.tabBarController?.tabBar.isHidden.toggle()
        
        // 팝업뷰 버튼 동작 설정
        
        // Edit 버튼 터치
        popupVC.editClosure = { [weak view] in
            let editVC = EditViewController()
            editVC.navigationItem.title = changeToRealName(fileName: fileName)
            editVC.fileName = fileName
            view?.navigationController?.pushViewController(editVC, animated: true)
            view?.tabBarController?.tabBar.isHidden.toggle()
        }
        
        // Practice 버튼 터치
        popupVC.practiceClosure = { [weak view] in
            let practiceVC = PracticeViewController()
            practiceVC.navigationItem.title = changeToRealName(fileName: fileName)
            practiceVC.fileName = fileName
            view?.navigationController?.pushViewController(practiceVC, animated: true)
            view?.tabBarController?.tabBar.isHidden.toggle()
        }
        
        // Exam 버튼 터치
        
        popupVC.examClosure = { [weak view] in
            guard VocaManager.shared.vocas.count >= 5 else {
                let alert = UIAlertController(title: "단어가 5개 미만입니다.", message: "단어장에 5개 이상의 단어가 있어야합니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                view?.present(alert, animated: true, completion: nil)
                return
            }
            let examVC = ExamViewController()
            examVC.navigationItem.title = changeToRealName(fileName: fileName)
            examVC.fileName = fileName
            view?.navigationController?.pushViewController(examVC, animated: true)
            view?.tabBarController?.tabBar.isHidden.toggle()
        }
        
        // Delete 버튼 터치
        popupVC.deleteClosure = { [weak popupVC, weak view] in
            let deleteAlert = UIAlertController(title: "이 단어장을 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                VocaManager.shared.deleteFile(fileName: fileName)
                view?.viewModels.makeNewViewModels(isAddButton: false)
                view?.tabBarController?.tabBar.isHidden.toggle()
                popupVC?.dismiss(animated: true, completion: nil)
            }))
            deleteAlert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
            view?.present(deleteAlert, animated: true, completion: nil)
        }
        
        // Exit 버튼 터치
        popupVC.exitClosure = { [weak popupVC, weak view] in
            guard let fileNameFromText = popupVC?.textField.text else {
                return
            }
            //change file name
            let realName = fileName
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
            view?.viewModels.makeViewModels()
            
            view?.tabBarController?.tabBar.isHidden.toggle()
            popupVC?.dismiss(animated: true, completion: nil)
        }
        // 팝업뷰 띄우기
        view.present(popupVC, animated: true, completion: nil)
    }
}

struct SectionOfWordsCell {
    var idx: Int
    var items: [Item]
}

extension SectionOfWordsCell : AnimatableSectionModelType {
    typealias Item = WordsCell
    typealias Identity = Int
    
    var identity: Int {
        return idx
    }
    
    init(original: SectionOfWordsCell, items: [WordsCell]) {
        self = original
        self.items = items
    }
}
