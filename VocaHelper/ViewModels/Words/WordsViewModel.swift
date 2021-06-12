//
//  WordsViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/11.
//

import Foundation
import RxSwift

class WordsViewModel {
    var fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func changeToRealName(fileName: String) -> String {
        return String(fileName[fileName.index(fileName.startIndex, offsetBy: 25) ..< fileName.endIndex])
    }
    
    // 단어장 터치시 동작
    func didTapWordButton(view: WordsViewController) {
        let popupVC = PopupViewController()
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.textField.text = changeToRealName(fileName: fileName)
        view.tabBarController?.tabBar.isHidden.toggle()
        
        // 팝업뷰 버튼 동작 설정
        popupVC.editClosure = { [weak self, weak view] in
            let editVC = EditViewController()
            editVC.navigationItem.title = self?.changeToRealName(fileName: self?.fileName ?? "")
            editVC.fileName = self?.fileName ?? ""
            view?.navigationController?.pushViewController(editVC, animated: true)
            view?.tabBarController?.tabBar.isHidden.toggle()
        }
        
        popupVC.exitClosure = { [weak popupVC, weak self, weak view] in
            guard let fileName = popupVC?.textField.text else {
                return
            }
            //change file name
            let realName = self?.fileName ?? ""
            let datePart = String(realName[realName.startIndex ..< realName.index(realName.startIndex, offsetBy: 25)])
            let currRealName = datePart + fileName
            
            
            guard let directory = VocaManager.directoryURL else {
                return
            }
            let prevName = directory.appendingPathComponent(self?.fileName ?? "").path
            let currName = directory.appendingPathComponent(currRealName).path

            do {
                try FileManager.default.moveItem(atPath: prevName, toPath: currName)
            } catch {
                print(error)
            }
            self?.fileName = currRealName
            view?.viewModels.makeViewModels()
            view?.tabBarController?.tabBar.isHidden.toggle()

            popupVC?.dismiss(animated: true, completion: nil)
        }
        // 팝업뷰 띄우기
        view.present(popupVC, animated: true, completion: nil)
    }
    
    // 추가버튼 터치시 동작
    func didTapAddButton() {        
    }
}


