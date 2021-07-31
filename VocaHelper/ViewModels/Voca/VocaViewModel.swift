//
//  VocaViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/12.
//

import Foundation
import RxSwift
import Charts

class VocaViewModel {    
    public var editCellSubject = BehaviorSubject<[SectionOfEditCell]>(value: [])
    
    public lazy var buttonCountSubject = BehaviorSubject<Int>(value: 0)
    
    public lazy var practiceCellObservable = buttonCountSubject.map {
        return Voca(idx: VocaManager.shared.vocas[$0].idx, word: VocaManager.shared.vocas[$0].word, meaning: VocaManager.shared.vocas[$0].meaning)
    }
    
    private lazy var shuffledVocas = VocaManager.shared.vocas.shuffled()
    
    //public lazy var realAnswer: [String] = []
    public lazy var userAnswer: [String] = []
    
    public lazy var examCellObservable: Observable<[String]> = buttonCountSubject.map { [weak self] in        
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
                    EditCell(identity: $0.idx, word: $0.word, meaning: $0.meaning)
                }.map {
                    SectionOfEditCell(idx: $0.identity, items: [$0])
                }
            }.subscribe(onNext: { [weak self] in
                self?.editCellSubject.onNext($0)
            }).disposed(by: disposeBag)
    }
    
    public func didDeleteCell(section: Int) {
        VocaManager.shared.vocas.remove(at: section)
        makeViewModelsFromVocas()
    }
    
    /// Load ViewModel From VocaData Vocas
    public func makeViewModelsFromVocas() {
        let newViewModels: [SectionOfEditCell] = VocaManager.shared.vocas
            .map {
                return EditCell(identity: $0.idx, word: $0.word, meaning: $0.meaning)
            }.map {
                SectionOfEditCell(idx: $0.identity, items: [$0])
            }
        editCellSubject.onNext(newViewModels)
    }
    
    /// Navigation BackButton Function : Update Vocas, Save Vocas
    public func didTapBackButton(fileName: String) {
        VocaManager.shared.saveVocas(fileName: fileName)
    }
    
    /// Table Footer Button Function : Update Vocas, Add New Line, OnNext NewViewModel, Save Vocas
    public func didTapAddButton(fileName: String, view: EditViewController) {
        guard VocaManager.shared.vocas.count < 50 else {
            let countAlert = UIAlertController(title: "단어가 가득 찼습니다.", message: "단어는 최대 50개 만들 수 있습니다.", preferredStyle: .alert)
            countAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            view.present(countAlert, animated: true, completion: nil)
            return
        }
        let newIdx = (VocaManager.shared.vocas.last?.idx ?? -1) + 1
        VocaManager.shared.vocas.append(Voca(idx: newIdx, word: "", meaning: ""))
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
    
    public func cellDeselected(section: Int?, cell: EditTableViewCell?) {
        guard let section = section,
              let cell = cell else {
            return
        }
        VocaManager.shared.vocas[section].word = cell.wordTextField.text ?? ""
        VocaManager.shared.vocas[section].meaning = cell.meaningTextField.text ?? ""        
        makeViewModelsFromVocas()
    }
    
    // MARK: - For Exam
    
    public func makeResultCellSubject() {
        let resultTable = zip(shuffledVocas, userAnswer).map {
            return ResultCell(
                questionWord: $0.0.word,
                realAnswer: $0.0.meaning,
                userAnswer: $0.1,
                score: $0.0.meaning == $0.1 ? "정답" : "오답"
            )
        }
        resultCellSubject.onNext(resultTable)
        
        // 다시 시험보는것을 대비한 답안지우기, 단어들 섞기
        userAnswer = []
        shuffledVocas.shuffle()
    }
    
    public func setPieChart(datas: [Int], chart: PieChartView) {
        let pieEntry = [
            PieChartDataEntry(value: Double(datas[0]), label: "정답"),
            PieChartDataEntry(value: Double(datas[1]), label: "오답")
        ]
        let dataset = PieChartDataSet(entries: pieEntry, label: nil)
        dataset.colors = [.systemTeal, .systemPink]
        
        let data = PieChartData(dataSet: dataset)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        data.setValueFormatter(formatter)
        
        data.setDrawValues(true)
        data.setValueFont(NSUIFont.systemFont(ofSize: 20, weight: .semibold))
        data.setValueTextColor(.label)
        
        chart.legend.enabled = false
        chart.data = data
        
        chart.centerAttributedText = NSAttributedString(
            string: "\(datas[2])%",
            attributes: [.font : UIFont.systemFont(ofSize: 35, weight: .bold)])
        chart.drawEntryLabelsEnabled = false
        chart.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .linear)
    }
    
    public func setLineChart(lineChart: LineChartView) {
        let examResults = [
            [0,10],
            [1,30],
            [2,50],
            [3,70],
            [4,100]
        ]
        let lineEntry = examResults.map {
            ChartDataEntry(x: Double($0[0]), y: Double($0[1]))
        }
        
        let dataset = LineChartDataSet(entries: lineEntry, label: nil)
        dataset.drawCirclesEnabled = false
        dataset.drawCircleHoleEnabled = false        
        dataset.lineWidth = 3
        dataset.setColor(.systemGreen)
        dataset.fill = Fill(color: .systemGreen)
        dataset.fillAlpha = 0.2
        dataset.mode = .cubicBezier
        dataset.drawFilledEnabled = true        
        
        let data = LineChartData(dataSet: dataset)
        data.setValueFont(NSUIFont.systemFont(ofSize: 10, weight: .medium))
        let format = NumberFormatter()
        format.numberStyle = .none
        //format.maximumFractionDigits = 0
        let formatter = DefaultValueFormatter(formatter: format)
        data.setValueFormatter(formatter)
        lineChart.data = data
        lineChart.animate(yAxisDuration: 1, easingOption: .linear)
    }
    
    public func presentResultVC(view: ExamViewController) {
        let resultVC = ResultViewController()
        resultVC.modalPresentationStyle = .fullScreen
        resultVC.presentingView = view
        resultVC.viewModel = view.viewModel
        view.present(resultVC, animated: true, completion: nil)
    }
    
    
    // MARK: - For WebVocaViewController
    public func didTapWebVocaRightButton(webVocaName: String, isLiked: Bool, view: WebVocaViewController) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "저장하기", style: .default, handler: { [weak view] _ in
            view?.viewModel.saveWebVocaToLocal(isLiked: isLiked, view: view!)
        }))
        actionSheet.addAction(UIAlertAction(title: "시험보기", style: .default, handler: { [weak view] _ in
            view?.viewModel.pushWebVocaExamViewController(view: view!)
        }))
        if AuthManager.shared.checkUserLoggedIn() {
            switch isLiked {
            case true:
                actionSheet.addAction(UIAlertAction(title: "추천 취소", style: .default, handler: { _ in
                    FirestoreManager.shared.deleteThumbsUp(webVocaName: webVocaName)
                    view.isLiked = false
                }))
            case false:
                actionSheet.addAction(UIAlertAction(title: "추천", style: .default, handler: { _ in
                    FirestoreManager.shared.thumbsUp(webVocaName: webVocaName)
                    view.isLiked = true
                }))
            }
        }
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        view.present(actionSheet, animated: true, completion: nil)
    }
    
    
    public func saveWebVocaToLocal(isLiked: Bool, view: WebVocaViewController) {
        let alert = UIAlertController(title: "저장할 파일의 이름을 적어주세요.", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.placeholder = "저장할 파일의 이름..."
        }
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak view] _ in
            guard let textFields = alert.textFields else {
                return
            }
            let fileName = "\(Date())" + (textFields[0].text ?? "다운로드파일")
            DispatchQueue.global().sync {
                VocaManager.shared.makeFile(fileName: fileName)
            }
            DispatchQueue.global().sync {
                VocaManager.shared.saveVocas(fileName: fileName)
                FirestoreManager.shared.downloadNumberUp(webVocaName: view!.webVocaName)
            }
            DispatchQueue.global().sync {
                let isLoggedIn = AuthManager.shared.checkUserLoggedIn()
                let alert = UIAlertController(title: "단어장이 저장됐습니다.", message: nil, preferredStyle: .alert)
                if !isLiked && isLoggedIn {
                    alert.addAction(UIAlertAction(title: "추천", style: .default, handler: { _ in
                        FirestoreManager.shared.thumbsUp(webVocaName: view!.webVocaName)
                        view?.tabBarController?.tabBar.isHidden.toggle()
                        view?.navigationController?.popViewController(animated: true)
                    }))
                }
                alert.addAction(UIAlertAction(title: isLiked || !isLoggedIn ? "확인" : "나중에", style: .cancel, handler: { _ in
                    view?.tabBarController?.tabBar.isHidden.toggle()
                    view?.navigationController?.popViewController(animated: true)
                }))
                view?.present(alert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    public func pushWebVocaExamViewController(view: WebVocaViewController) {
        guard VocaManager.shared.vocas.count >= 5 else {
            let alert = UIAlertController(title: "단어가 5개 미만입니다.", message: "단어장에 5개 이상의 단어가 있어야합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            view.present(alert, animated: true, completion: nil)
            return
        }
        guard let navi = view.navigationController else {
            return
        }        
        navi.popViewController(animated: true)
        let examVC = ExamViewController()
        navi.pushViewController(examVC, animated: true)
    }
}
