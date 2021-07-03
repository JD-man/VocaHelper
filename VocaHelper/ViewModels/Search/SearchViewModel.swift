//
//  SearchViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/14.
//

import Foundation
import RxSwift

struct ResultTableCell {
    let fileName: String
    let word: String
    let meaning: String
}

class SearchViewModel {
    public var searchResultSubject = BehaviorSubject<[ResultTableCell]>(value: [])
    
    public func makeSearchResultSubject(word: String, tableView: UITableView!, noResultView: UILabel!) {
        
        guard let allVocas = VocaManager.shared.allVocasForSearch else {
            return
        }
        
        // [VocaData] => [[FilteredVocas]] => [[ResultTableCell]] -> flat
        let filteredResults: [[ResultTableCell]] = allVocas.map {
            let fileName = $0.fileName
            let filteredVocas =  $0.vocas.filter { $0.word.lowercased().contains(word) }
            let cell = filteredVocas.map { ResultTableCell(fileName: fileName, word: $0.word, meaning: $0.meaning)}
            return cell
        }
        
        let flat = filteredResults.flatMap{$0}
        if flat.count == 0 {
            noResultView.isHidden = false
            tableView.isHidden = true
        }
        else {
            noResultView.isHidden.toggle()
            tableView.isHidden.toggle()
            searchResultSubject.onNext(flat)
        }
    }
    
    public func didTapResultCell(fileName: String, view: SearchViewController) {
        VocaManager.shared.loadVocasLocal(fileName: fileName)
        let editVC = EditViewController()
        editVC.fileName = fileName
        editVC.navigationItem.title = String(fileName[fileName.index(fileName.startIndex, offsetBy: 25) ..< fileName.endIndex])
        view.navigationController?.pushViewController(editVC, animated: true)
    }
}
