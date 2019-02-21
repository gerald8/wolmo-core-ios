//
//  UIViewExtension.swift
//  AnimationTest
//
//  Created by Argentino Ducret on 24/01/2018.
//  Copyright © 2018 wolox. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
   public enum Position {
        case back
        case front
    }
    
    public func simpleAnimation() -> SimpleAnimation {
        return SimpleAnimation(view: self)
    }
    
    public func mixedAnimation(withDuration duration: TimeInterval) -> MixedAnimation {
        return MixedAnimation(view: self, duration: duration)
    }
    
    public func chainedAnimation(loop: Bool = false) -> ChainedAnimation {
        return ChainedAnimation(view: self, loop: loop)
    }
    
    public func shake(withDuration duration: TimeInterval = 0.05, repeatShake: Float = 3) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatShake
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: center.x - 4, y: center.y)
        animation.toValue = CGPoint(x: center.x + 4, y: center.y)
        
        layer.add(animation, forKey: "position")
    }
    
    public func isDrageable(returnToPosition: Bool = true, withDuration duration: TimeInterval = 0.5, action: (() -> Void)?) {
        let origin: CGPoint = self.frame.origin
        
        self.addPanGestureRecognizer(action: { [weak self] recognaizer in
            let translation = recognaizer.translation(in: self)
            
            switch recognaizer.state {
            case .began, .changed:
                self?.center = CGPoint(x: (self?.center.x)! + translation.x, y: (self?.center.y)! + translation.y)
                recognaizer.setTranslation(CGPoint.zero, in: self)
            case .ended:
                action?()
                UIView.animate(withDuration: duration, animations: {
                    if returnToPosition {
                        self?.frame.origin = origin
                    }
                })
            default:
                break
            }
        })
    }
    
}
