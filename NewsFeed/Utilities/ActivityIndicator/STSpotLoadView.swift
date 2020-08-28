//
//  STSpotLoadView.swift
//  STSpotLoadView-BouncyPreloader
//
//  Created by TangJR on 1/4/16.
//  Copyright © 2016 tangjr. All rights reserved.
//

/*
    The MIT License (MIT)

    Copyright (c) 2016 saitjr

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
*/

import UIKit

class STSpotLoadView: UIView {
    
    fileprivate let spotLayer: CAShapeLayer = CAShapeLayer()
    fileprivate let spotReplicatorLayer: CAReplicatorLayer = CAReplicatorLayer()
    fileprivate var isAnimation: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateUI()
    }
}

extension STSpotLoadView {
    fileprivate func setupUI() {
        self.alpha = 0
        
        spotLayer.frame = CGRect(x: 0, y: 0, width: STConfiguration.LineWidth, height: STConfiguration.LineWidth)
        spotLayer.lineCap = CAShapeLayerLineCap(rawValue: "round")
        spotLayer.lineJoin = CAShapeLayerLineJoin(rawValue: "round")
        spotLayer.lineWidth = STConfiguration.LineWidth
        spotLayer.fillColor = STConfiguration.SpotColor.cgColor
        spotLayer.strokeColor = STConfiguration.SpotColor.cgColor
        spotLayer.path = UIBezierPath(ovalIn: spotLayer.bounds).cgPath
        spotReplicatorLayer.addSublayer(spotLayer)
        
        spotReplicatorLayer.instanceCount = STConfiguration.SpotCount
        spotReplicatorLayer.instanceDelay = STConfiguration.AnimationDuration / 5
        layer.addSublayer(spotReplicatorLayer)
    }
    
    fileprivate func updateUI() {
        spotLayer.frame = CGRect(x: STConfiguration.LineWidth / 2.0, y: (bounds.height - STConfiguration.LineWidth) / 2.0, width: STConfiguration.LineWidth, height: STConfiguration.LineWidth)
        spotReplicatorLayer.frame = bounds
        spotReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(bounds.width / CGFloat(STConfiguration.SpotCount), 0, 0)
    }
}

extension STSpotLoadView: STAnimationProtocol {
    internal func stopAnimation(_ finished: @escaping () -> Void) {
        guard isAnimation else {
            finished()
            return
        }
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 1
        }) { [weak self] (finish) -> Void in
            self?.isAnimation = false
            self?.spotLayer.removeAllAnimations()
            finished()
        }
    }

    func startAnimation() {
        guard !isAnimation else {
            return
        }
        isAnimation = true
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 1
        }) 
        
        let centerY = bounds.height / 2.0
        let downY = centerY + 15.0
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position.y")
        positionAnimation.beginTime = CACurrentMediaTime() + 0.5
        positionAnimation.values = [centerY, downY, centerY, centerY]
        positionAnimation.keyTimes = [0.0, 0.33, 0.63, 1.0]
        positionAnimation.repeatCount = Float.infinity
        positionAnimation.duration = STConfiguration.AnimationDuration + 0.4
        spotLayer.add(positionAnimation, forKey: "positionAnimation")
    }

}
