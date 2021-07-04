//
//  WebViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/04.
//

import UIKit

class WebViewController: UIViewController {
    
    let uploadDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("업로드", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(uploadDataButton)
        FirestoreManager.shared.getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        uploadDataButton.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        uploadDataButton.addTarget(self, action: #selector(uploadData), for: .touchUpInside)
    }
    
    @objc private func uploadData() {
        FirestoreManager.shared.putDocuments()
    }
}
