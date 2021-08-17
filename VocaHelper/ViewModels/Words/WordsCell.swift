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
    // true로 설정하면 메모리누수가 일어나지 않는다. 추가버튼을 다른곳에 만들어야할듯.
    
    static func == (lhs: WordsCell, rhs: WordsCell) -> Bool {
        if lhs.identity == rhs.identity { return true }
        else { return false }
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
    
    func didTapWordButton(view: WordsViewController) {
        VocaManager.shared.loadVocasLocal(fileName: fileName)
        let popupVC = PopupViewController()
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.fileName = fileName
        popupVC.viewModel = view.viewModels
        popupVC.presenting = view
        popupVC.textField.text = changeToRealName(fileName: fileName)
        view.present(popupVC, animated: true, completion: nil)
        view.tabBarController?.tabBar.isHidden.toggle()
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
