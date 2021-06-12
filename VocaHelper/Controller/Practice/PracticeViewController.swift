//
//  PracticeViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/28.
//

import UIKit

class PracticeViewController: UIViewController {

//    public var voca = VocaData(vocas: [Int : [String : String]]())
//    
//    private var vocaCount: Int = 0
//    
//    private var prevTouch: CGFloat = 0
//    private var currTouch: CGFloat = 0
//    
//    
//    private let wordLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .label
//        label.textAlignment = .center
//        label.textColor = .systemBackground
//        label.text = "word"
//        label.font = UIFont.systemFont(ofSize: 25)
//        label.adjustsFontSizeToFitWidth = true
//        label.clipsToBounds = true
//        label.layer.cornerRadius = 10
//        return label
//    }()
//    
//    private let meaningLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .label
//        label.textAlignment = .center
//        label.textColor = .systemBackground
//        label.text = "meaning"
//        label.font = UIFont.systemFont(ofSize: 25)
//        label.adjustsFontSizeToFitWidth = true
//        label.clipsToBounds = true
//        label.layer.cornerRadius = 10
//        return label
//    }()
//    
//    private let prevButton: UIButton = {
//        let button = UIButton()
//        button.setBackgroundImage(UIImage(systemName: "backward"), for: .normal)
//        button.tintColor = .label
//        return button
//    }()
//    
//    private let nextButton: UIButton = {
//        let button = UIButton()
//        button.setBackgroundImage(UIImage(systemName: "forward"), for: .normal)
//        button.tintColor = .label
//        return button
//    }()
//    
//    private let blind: BlindUIView = {
//        let view = BlindUIView()
//        view.clipsToBounds = true
//        return view
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        addSubviews()
//        changeQuestion(0)
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"),
//                                                                                                style: .done,
//                                                                                                target: self,
//                                                                                                action: #selector(didTapLeftButton))
//        
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let labelWidth = view.bounds.width / 2 - 15
//        let labelHeight = labelWidth / 3
//        
//        let buttonSize: CGFloat = 25
//        let blindPadding: CGFloat = 10
//        
//        wordLabel.frame = CGRect(
//            x: view.bounds.origin.x + 10,
//            y: view.bounds.height/2 - labelHeight/2,
//            width: labelWidth,
//            height: labelHeight
//        )
//        meaningLabel.frame = CGRect(
//            x: view.bounds.width / 2 + 5,
//            y: view.bounds.height/2 - labelHeight/2,
//            width: labelWidth,
//            height: labelHeight
//        )
//        prevButton.frame = CGRect(
//            x: labelWidth / 2 + 10 - buttonSize/2,
//            y: wordLabel.frame.origin.y + labelHeight + buttonSize * 1.5,
//            width: buttonSize,
//            height: buttonSize
//        )
//        nextButton.frame = CGRect(
//            x: view.bounds.width - (labelWidth / 2 + 10) - buttonSize/2,
//            y: wordLabel.frame.origin.y + labelHeight + buttonSize * 1.5,
//            width: buttonSize,
//            height: buttonSize
//        )
//        blind.frame = CGRect(
//            x: view.bounds.width/2,
//            y: meaningLabel.frame.origin.y - blindPadding/2,
//            width: labelWidth + blindPadding,
//            height: labelHeight + blindPadding
//        )
//        
//        prevButton.addTarget(self, action: #selector(didTapPrevButton), for: .touchUpInside)
//        nextButton .addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
//    }
//    
//    private func addSubviews() {
//        view.addSubview(wordLabel)
//        view.addSubview(meaningLabel)
//        view.addSubview(blind)
//        view.addSubview(prevButton)
//        view.addSubview(nextButton)
//    }
//    
//    private func changeQuestion(_ index: Int) {
//        guard let wordMeaning = voca.vocas[index] else {
//            return
//        }
//        wordLabel.text = wordMeaning.keys.first
//        meaningLabel.text = wordMeaning.values.first
//    }
//    
//    @objc private func didTapNextButton() {
//        vocaCount += 1
//        if vocaCount >= voca.vocas.count {
//            vocaCount -= 1
//            let alert = UIAlertController(title: "마지막 단어입니다.", message: nil, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        let originLayerFrame = self.wordLabel.layer.frame.origin.x
//        self.wordLabel.layer.frame.origin.x = -wordLabel.bounds.width - 5
//        changeQuestion(vocaCount)
//        UIView.animate(withDuration: 0.7) {
//            self.wordLabel.frame.origin.x = originLayerFrame
//        }
//    }
//    
//    @objc private func didTapPrevButton() {
//        vocaCount -= 1
//        if vocaCount <= -1{
//            vocaCount += 1
//            let alert = UIAlertController(title: "첫번째 단어입니다.", message: nil, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        let originLayerFrame = self.wordLabel.layer.frame.origin.x
//        self.wordLabel.layer.frame.origin.x = meaningLabel.frame.origin.x
//        changeQuestion(vocaCount)
//        UIView.animate(withDuration: 0.7) {
//            self.wordLabel.frame.origin.x = originLayerFrame
//        }
//    }
//    
//    @objc private func didTapLeftButton() {
//        tabBarController?.tabBar.isHidden = false
//        navigationController?.popViewController(animated: true)
//    }
}
