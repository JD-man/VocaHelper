//
//  BlindUIView.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/28.
//

import UIKit

class BlindUIView: UIView {
    
    private lazy var prevTouch: CGPoint = CGPoint(x: 0.0, y: 0.0)
    private lazy var currTouch: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    private lazy var viewOriginFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    private let gradient: CAGradientLayer  = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.cyan.cgColor, UIColor.magenta.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = 10
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradientLayer()
    }
    
    private func addGradientLayer() {
        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        prevTouch = touch.location(in: self)
        viewOriginFrame = self.frame
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        self.currTouch = touch.location(in: self)
        self.frame = CGRect(
            x: self.frame.origin.x + 0.7 * (self.currTouch.x - self.prevTouch.x),
            y: self.frame.origin.y + 0.7 * (self.currTouch.y - self.prevTouch.y),
            width: self.frame.width,
            height: self.frame.height
        )
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {        
        UIView.animate(withDuration: 0.2) {
            self.frame = self.viewOriginFrame
        }
    }
}
