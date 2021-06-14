//
//  TestViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/29.
//

import UIKit
import RxSwift
import RxCocoa

class TestViewController: UIViewController {
    
    deinit {
        print("testVC deinit")
    }
    
    public var fileName: String = ""
    private lazy var viewModel = VocaViewModel(fileName: fileName)
    private let disposeBag = DisposeBag()
    public var index = 0
    
    private var vocaIndices: [Int] = []         // 단어들 인덱스가 섞인 배열
    private var realAnswers: [String] = []   // 섞인 인덱스로 정리된 진짜답안배열
    private var prevQuestion: [Int] = []
    private var userAnswers: [String] = []
    
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
        view.backgroundColor = .systemBackground
        configView()
        rxConfigure()
        configLabelButtons()
        configStackView()
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
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"))
    }

    private func configLabelButtons() {
        let questionFontSize: CGFloat = 50
        let buttonFontSize: CGFloat = 30
        question.font = UIFont.systemFont(ofSize: questionFontSize, weight: .bold)
        stackView.addArrangedSubview(question)

        for button in buttons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .regular)
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
    
    private func rxConfigure() {
        viewModel.buttonCountSubject
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.testCellObservable
            .bind() { [weak self] in
                self?.question.text = $0.last
                for i in 0...4 {
                    self?.buttons[i].setTitle($0[i], for: .normal)
                }
            }.disposed(by: disposeBag)
        
        for button in buttons {
            button.rx.tap
                .bind() { [weak self] in
                    self?.index += 1
                    self?.viewModel.userAnswer.append(button.titleLabel?.text ?? "")
                    if self?.index ?? 0 >= VocaManager.shared.vocasCount {
                        self?.index -= 1
                        let alert = UIAlertController(title: "마지막 문제입니다.", message: "결과화면이 표시됩니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.viewModel.presentResultVC(view: strongSelf)
                        }))
                        self?.present(alert, animated: true, completion: nil)
                    }
                    self?.viewModel.buttonCountSubject.onNext(self?.index ?? 0)
                }.disposed(by: disposeBag)
        }
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind() { [weak self] in                
                self?.tabBarController?.tabBar.isHidden.toggle()
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
}
