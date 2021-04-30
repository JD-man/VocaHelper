//
//  TestViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/29.
//

import UIKit

class TestViewController: UIViewController {
    
    public var voca = VocaData(vocas: [Int : [String : String]]())
    
    private var vocaCount: Int = 0
    
    private var vocaIndices: [Int] = []
    private var prevQuestion: [Int] = []
    private var userAnswers: [String] = []
    private var realAnswers: [String] = []
    private var currVocaIndex: Int = 0
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let question: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textAlignment = .center
        label.backgroundColor = .systemIndigo
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemBackground
        return label
    }()
    
    private let buttons: [UIButton] = {
        var buttons = [UIButton]()
        for i in 0 ..< 5 {
            let button = UIButton()
            button.setTitle("button\(i)", for: .normal)
            button.backgroundColor = .systemBackground
            button.setTitleColor(.label, for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            buttons.append(button)
        }
        return buttons
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemBackground
        configView()
        configLabelButtons()
        configStackView()
        vocaCount = voca.vocas.count
        vocaIndices = Array(0 ..< vocaCount).shuffled()
        for index in vocaIndices {
            guard let word = voca.vocas[index]?.values.first else {
                break
            }
            realAnswers.append(word)
        }
        settingQuestion(currVocaIndex)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let stackViewWidth: CGFloat = 300
        let stackViewHeight: CGFloat = 500
        stackView.frame = CGRect(x: view.bounds.width/2 - stackViewWidth/2, y: view.bounds.height/2 - stackViewHeight/2, width: stackViewWidth, height: stackViewHeight)
    }
    
    private func configView() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemTeal.cgColor, UIColor.systemGreen.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.addSublayer(gradient)
        gradient.frame = view.bounds
    }
    
    private func configLabelButtons() {
        let questionFontSize: CGFloat = 50
        let buttonFontSize: CGFloat = 30
        question.font = UIFont.systemFont(ofSize: questionFontSize, weight: .bold)
        stackView.addArrangedSubview(question)
        
        for button in buttons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .regular)
            button.addTarget(self, action: #selector(savingAnswer(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func configStackView() {
        stackView.backgroundColor = .label
        stackView.axis = .vertical
        stackView.clipsToBounds = true
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 30
        view.addSubview(stackView)
    }
    
    @objc private func savingAnswer (_ sender: UIButton) {
        guard let answer = sender.currentTitle else {
            return
        }
        userAnswers.append(answer)
        currVocaIndex += 1
        if currVocaIndex == vocaCount {
            
            let alert = UIAlertController(title: "마지막 문제입니다.", message: "결과화면이 표시됩니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                let resultVC = ResultViewController()
                resultVC.modalPresentationStyle = .fullScreen
                resultVC.userAnswers = self.userAnswers
                resultVC.realAnswers = self.realAnswers
                resultVC.presentingView = self
                self.present(resultVC, animated: true, completion: self.resultPresentComplete)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            settingQuestion(currVocaIndex)
        }        
    }
    
    private func resultPresentComplete() {
        currVocaIndex = 0
        userAnswers = []
        prevQuestion = []
        settingQuestion(currVocaIndex)
    }
    
    private func settingQuestion(_ currVocaIndex: Int) {
        let randomIdx = vocaIndices[currVocaIndex]
        guard let word = voca.vocas[randomIdx]?.keys.first,
              let meaning = voca.vocas[randomIdx]?.values.first,
              let answerButton = buttons.randomElement() else {
            return
        }
        question.text = word
        
        var wrongAnswers: [String] = []
        
        while wrongAnswers.count <= 4 {
            guard let wrongAnswer = realAnswers.randomElement() else {
                return
            }
            if  wrongAnswer != meaning && !wrongAnswers.contains(wrongAnswer)  {
                wrongAnswers.append(wrongAnswer)
            }
        }
        
        for (i,button) in buttons.enumerated() {
            if button == answerButton {
                answerButton.setTitle(meaning, for: .normal)
            } else {
                button.setTitle(wrongAnswers[i], for: .normal)
            }
        }
        prevQuestion.append(randomIdx)
    }
}
