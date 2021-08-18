//
//  ExamViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/29.
//

import UIKit
import RxSwift
import RxCocoa

class ExamViewController: UIViewController {
    
    deinit {
        print("examVC deinit")
    }
    
    public var fileName: String = ""
    public lazy var viewModel = VocaViewModel(fileName: fileName)
    private let disposeBag = DisposeBag()
    public var index = 0
    
    public var vocaIndices: [Int] = []         // 단어들 인덱스가 섞인 배열
    public var realAnswers: [String] = []   // 섞인 인덱스로 정리된 진짜답안배열
    public var prevQuestion: [Int] = []
    public var userAnswers: [String] = []
    
    public var currVocaIndex: Int = 0
    public var stackViewHeightAnchor = NSLayoutConstraint()
    

    public let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    public let question: UILabel = {
        let label = UILabel()
        label.text = "Exam"
        label.textAlignment = .center
        label.backgroundColor = .systemIndigo
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemBackground
        return label
    }()

    public let buttons: [UIButton] = {
        var buttons = [UIButton]()
        for i in 0 ..< 5 {
            let button = UIButton(type: .system)
            button.setTitle("button\(i)", for: .normal)
            button.backgroundColor = .systemBackground
            button.setTitleColor(.label, for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            buttons.append(button)
        }
        return buttons
    }()
    
    public let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemTeal.cgColor, UIColor.systemGreen.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configView()
        configLabelButtons()
        configStackView()
        rxConfigure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
    }

    private func configView() {
        view.layer.addSublayer(gradient)
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
        stackView.spacing = 1        
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 30
        view.addSubview(stackView)
        
        let stackViewHeightMultiplier: CGFloat = view.bounds.width > view.bounds.height ? 0.85 : 0.65
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        stackViewHeightAnchor = stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: stackViewHeightMultiplier)
        stackViewHeightAnchor.isActive = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        stackViewHeightAnchor.isActive = false
        if size.width > size.height {
            stackViewHeightAnchor = stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.85)
            stackViewHeightAnchor.isActive = true
        }
        else {
            stackViewHeightAnchor = stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.65)
            stackViewHeightAnchor.isActive = true
        }
    }
    
    private func rxConfigure() {
        viewModel.buttonCountSubject
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.examCellObservable
            .bind() { [weak self] in
                self?.viewModel.setButtons(questions: $0, view: self!)
            }.disposed(by: disposeBag)
        
        for button in buttons {
            button.rx.tap.asDriver()
                .throttle(.milliseconds(1500), latest: false)
                .drive(onNext: { [weak self] in
                    self?.viewModel.setNextButtons(button: button, view: self!)                    
                }).disposed(by: disposeBag)
        }
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind() { [weak self] in                
                self?.tabBarController?.tabBar.isHidden.toggle()
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
}
