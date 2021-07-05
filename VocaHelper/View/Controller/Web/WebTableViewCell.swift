//
//  WebTableViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/06.
//

import UIKit

class WebTableViewCell: UITableViewCell {

    static let identifier: String = "WebTableViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
