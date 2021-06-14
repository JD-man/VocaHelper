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
    
    public lazy var practiceCellObservable = buttonCountSubject.map {
        return Voca(word: VocaManager.shared.vocas[$0].word, meaning: VocaManager.shared.vocas[$0].meaning)
    }
    
    private lazy var suffledVocas = VocaManager.shared.vocas.shuffled()
    public lazy var realAnswer: [String] = []
    public lazy var userAnswer: [String] = []
    
    public lazy var testCellObservable: Observable<[String]> = buttonCountSubject.map { [weak self] in
        let word = self?.suffledVocas[$0].word ?? "Not exist Word"
        let meaning = self?.suffledVocas[$0].meaning ?? "Not exist Meaning"
        var wrongAnswers: [String] = []
        while wrongAnswers.count <= 3 {
            let wrongAnswer = self?.suffledVocas.randomElement()?.meaning ?? "Not exist Meaning"
            if  wrongAnswer != meaning && !wrongAnswers.contains(wrongAnswer)  {
                wrongAnswers.append(wrongAnswer)
            }
        }
        
        self?.realAnswer.append(word)
        wrongAnswers.append(meaning)
        var questionArr = wrongAnswers.shuffled()
        questionArr.append(word)
        return questionArr
    }
    
    public lazy var resultCellSubject = BehaviorSubject<[ResultCell]>(value: [])
    
    
    //public lazy var testCellSubject = BehaviorSubject<>()
    
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
    
    // MARK: - For Test
    
    public func makeResultCellSubject() {
//        zip(realAnswer, userAnswer).map { <#(String, String)#> in
//            <#code#>
//        }
    }
    
    public func presentResultVC(view: TestViewController) {
        let resultVC = ResultViewController()
        resultVC.modalPresentationStyle = .fullScreen
        resultVC.userAnswers = userAnswer
        resultVC.realAnswers = realAnswer
        resultVC.presentingView = view
        view.present(resultVC, animated: true, completion: nil)
    }
}
