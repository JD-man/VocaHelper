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
    
    private lazy var shuffledVocas = VocaManager.shared.vocas.shuffled()
    
    //public lazy var realAnswer: [String] = []
    public lazy var userAnswer: [String] = []
    
    public lazy var testCellObservable: Observable<[String]> = buttonCountSubject.map { [weak self] in
        let word = self?.shuffledVocas[$0].word ?? "Not exist Word"
        let meaning = self?.shuffledVocas[$0].meaning ?? "Not exist Meaning"
        var wrongAnswers: [String] = []
        while wrongAnswers.count <= 3 {
            let wrongAnswer = self?.shuffledVocas.randomElement()?.meaning ?? "Not exist Meaning"
            if  wrongAnswer != meaning && !wrongAnswers.contains(wrongAnswer)  {
                wrongAnswers.append(wrongAnswer)
            }
        }
        
        //self?.realAnswer.append(meaning)
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
    public func didTapBackButton(fileName: String) {
//        if let row = row, let cell = cell {
//            VocaManager.shared.vocas[row].word = cell.wordTextField.text ?? ""
//            VocaManager.shared.vocas[row].meaning = cell.meaningTextField.text ?? ""
//            print(VocaManager.shared.vocas[row].word)
//        }
        VocaManager.shared.saveVocas(fileName: fileName)
    }
    
    /// Table Footer Button Function : Update Vocas, Add New Line, OnNext NewViewModel, Save Vocas
    public func didTapAddButton(fileName: String) {
//        if let row = row, let cell = cell {
//            VocaManager.shared.vocas[row].word = cell.wordTextField.text ?? ""
//            VocaManager.shared.vocas[row].meaning = cell.meaningTextField.text ?? ""
//        }
        VocaManager.shared.vocas.append(Voca(word: "", meaning: ""))
        VocaManager.shared.saveVocas(fileName: fileName)
        makeViewModelsFromVocas()
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
        let resultTable = zip(shuffledVocas, userAnswer).map {
            return ResultCell(realAnswer: $0.0.word, userAnswer: $0.1, score: $0.0.meaning == $0.1 ? "정답" : "오답")
        }
        resultCellSubject.onNext(resultTable)
        
        // 다시 시험보는것을 대비한 답안지우기, 단어들 섞기
        userAnswer = []
        shuffledVocas.shuffle()
    }
    
    public func presentResultVC(view: TestViewController) {
        let resultVC = ResultViewController()
        resultVC.modalPresentationStyle = .fullScreen
        resultVC.presentingView = view
        resultVC.viewModel = view.viewModel
        view.present(resultVC, animated: true, completion: nil)
    }
}
