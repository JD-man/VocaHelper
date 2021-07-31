//
//  ResultTableViewHeader.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/03.
//

import UIKit
import Charts

class ResultTableViewHeader: UIView {
    
    let pieChart: PieChartView = {
        let chart = PieChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.text = "오답정리"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constraintsConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func addSubviews() {
        self.addSubview(pieChart)
        self.addSubview(wordLabel)
    }
    
    private func constraintsConfigure() {
        pieChart.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        pieChart.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        pieChart.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        
        wordLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        wordLabel.topAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: 5).isActive = true
        wordLabel.heightAnchor.constraint(equalTo: pieChart.heightAnchor, multiplier: 0.25).isActive = true
        //wordLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
