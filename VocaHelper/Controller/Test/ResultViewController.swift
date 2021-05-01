//
//  ResultViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/29.
//

import UIKit

class ResultViewController: UIViewController {
    
    public var userAnswers: [String] = []
    public var realAnswers: [String] = []
    
    public weak var presentingView: TestViewController?
    
    private var scoreArray: [String] = []
    
    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        view.backgroundColor = .systemTeal
        resultTableView.delegate = self
        resultTableView.dataSource = self
        view.addSubview(resultTableView)
        makeScore()
        addFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultTableView.frame = view.bounds
    }
    
    private func makeScore() {
        for (i, userAnswer) in userAnswers.enumerated() {
            if userAnswer == realAnswers[i] {
                scoreArray.append("정답")
            } else {
                scoreArray.append("오답")
            }
        }
    }
    
    private func addFooter() {
        let footer = ResultTableViewFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        let score: Int = scoreArray.filter { score in
            if score == "정답" {
                return true
            } else {
                return false
            }
        }.count
        footer.scoreLabel.text = "점수 : " + String(score) + " / " + String(userAnswers.count)
        footer.delegate = self
        resultTableView.tableFooterView = footer
    }
    
    private func toRoot() {
        presentingView?.navigationController?.popToRootViewController(animated: true)
        presentingView?.tabBarController?.tabBar.isHidden = false
    }
}


extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultTableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as? ResultTableViewCell else {
            return UITableViewCell()
        }
        let realAnswer = realAnswers[indexPath.row]
        let userAnswer = userAnswers[indexPath.row]
        let score = scoreArray[indexPath.row]
        cell.wordLabel.text = realAnswer
        cell.userAnswerLabel.text = userAnswer
        cell.resultLabel.text = score
        
        if score == "정답" {
            cell.resultLabel.textColor = .systemTeal
        } else {
            cell.resultLabel.textColor = .systemPink
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ResultViewController: ResultTableViewFooterDelegate {
    func didTapTest() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTapHome() {
        self.dismiss(animated: true,completion: toRoot)
    }
}
