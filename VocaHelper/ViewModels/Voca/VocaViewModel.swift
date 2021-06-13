//
//  VocaViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/12.
//

import Foundation
import RxSwift

class VocaViewModel {    
    public var editCellSubject = BehaviorSubject<[EditCell]>(value: [])
    
    public lazy var buttonCountSubject = BehaviorSubject<Int>(value: 0)
    public lazy var practiceCellSubject = BehaviorSubject<Voca>(value: Voca(word: "TestWord", meaning: "TestMeaning"))
        
    
    
    private let disposeBag = DisposeBag()
    
    init(fileName: String) {
        makeViewModels(fileName: fileName)
    }
    
    // MARK: - For EditViewController
    
    /// Initial Load Voca ViewModel
    public func makeViewModels(fileName: String) {
        VocaManager.shared.loadVocas(fileName: fileName)
            .map {
                $0.map {
                    return EditCell(word: $0.word, meaning: $0.meaning)
                }
            }.subscribe(onNext: { [weak self] in
                self?.editCellSubject.onNext($0)
            }).disposed(by: disposeBag)
    }
    
    /// Load ViewModel From VocaData Vocas
    public func makeViewModelsFromVocas() {
        let newViewModels: [EditCell] = VocaManager.shared.vocas
            .map {
                return EditCell(word: $0.word, meaning: $0.meaning)
            }
        editCellSubject.onNext(newViewModels)
    }
    
    /// Navigation BackButton Function : Update Vocas, Save Vocas
    public func didTapBackButton(row: Int?, cell: EditTableViewCell?, fileName: String) {
        if let row = row, let cell = cell {
            VocaManager.shared.vocas[row].word = cell.wordTextField.text ?? ""
            VocaManager.shared.vocas[row].meaning = cell.meaningTextField.text ?? ""
        }
        VocaManager.shared.saveVocas(fileName: fileName)
    }
    
    /// Table Footer Button Function : Update Vocas, Add New Line, OnNext NewViewModel, Save Vocas
    public func didTapAddButton(row: Int?, cell: EditTableViewCell?, fileName: String) {
        if let row = row, let cell = cell {
            VocaManager.shared.vocas[row].word = cell.wordTextField.text ?? ""
            VocaManager.shared.vocas[row].meaning = cell.meaningTextField.text ?? ""
        }
        VocaManager.shared.vocas.append(Voca(word: "", meaning: ""))
        makeViewModelsFromVocas()
        VocaManager.shared.saveVocas(fileName: fileName)
    }
    
    public func cellSelected(cell: EditTableViewCell?, width: CGFloat?, touchXPos: CGFloat?) {
        guard let cell = cell,
              let width = width,
              let touchXPos = touchXPos else {
            return
        }
        if touchXPos < width / 2{
            cell.wordTextField.becomeFirstResponder()            
        }
        else {
            cell.meaningTextField.becomeFirstResponder()
        }
    }
    
    public func cellDeselected(row: Int?, cell: EditTableViewCell?) {
        guard let row = row,
              let cell = cell else {
            return
        }
        VocaManager.shared.vocas[row].word = cell.wordTextField.text ?? ""
        VocaManager.shared.vocas[row].meaning = cell.meaningTextField.text ?? ""
        makeViewModelsFromVocas()
    }
    
    // MARK: - For SearchBar
    
    public func setupPracticeSubject() {
        buttonCountSubject
            .subscribe(onNext: { [weak self] in
                self?.practiceCellSubject.onNext(VocaManager.shared.vocas[$0])
            }).disposed(by: disposeBag)
    }
}
