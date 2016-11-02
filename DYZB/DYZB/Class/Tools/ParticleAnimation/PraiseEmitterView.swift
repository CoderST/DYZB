//
//  PraiseEmitterView.swift
//  lizi
//
//  Created by xiudou on 16/11/2.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class PraiseEmitterView: UIView {

    private var timer: NSTimer?
    
    private let emitter: CAEmitterLayer! = {
        let emitter = CAEmitterLayer()
        return emitter
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        emit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        emitter.frame = bounds
        emitter.birthRate = 0
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterPosition = CGPointMake(0,CGRectGetHeight(bounds))
        emitter.emitterSize = bounds.size
        emitter.emitterCells = [getEmitterCell(UIImage(named: "good1_30x30")!.CGImage!), getEmitterCell(UIImage(named: "good2_30x30")!.CGImage!)]
        self.layer.addSublayer(emitter)
    }
    func timeoutSelector() {
        emitter.birthRate = 0
    }
    func emit() {
        emitter.birthRate = 2
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "timeoutSelector", userInfo: nil, repeats: false)
    }
    private func getEmitterCell(contentImage: CGImage) -> CAEmitterCell {
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = contentImage
        emitterCell.lifetime = 2
        emitterCell.birthRate = 2
        
        emitterCell.yAcceleration = -70.0
        emitterCell.xAcceleration = 0
        
        emitterCell.velocity = 20.0
        emitterCell.velocityRange = 200.0
        
        emitterCell.emissionLongitude = CGFloat(0)
        emitterCell.emissionRange = CGFloat(M_PI_4)
        
        emitterCell.scale = 0.8
        emitterCell.scaleRange = 0.8
        emitterCell.scaleSpeed = -0.15
        
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
        
        return emitterCell
    }
}
