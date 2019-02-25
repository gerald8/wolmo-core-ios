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
    
    /**
     Adds a shake animation that executes the closure when long pressed
     
     - Parameter duration: Time in seconds the animation will be execute. Default is 0.05
     - Parameter repeatShake: Number of time that view change the position. Default is 3
     */
    
    public func shake(withDuration duration: TimeInterval = 0.05, repeatShake: Float = 3) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatShake
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: center.x - 4, y: center.y)
        animation.toValue = CGPoint(x: center.x + 4, y: center.y)
        
        layer.add(animation, forKey: "position")
    }
    
    /**
     Allow drag the view and can execute an action when hold and/or release the view
     
     - Parameter returnToPosition: The number of full taps required before the press for gesture to be recognized. Default is true
     - Parameter duration: Time in seconds that the view take to return to the original position. Default is 0.5
     - Parameter onDragStared: The closure that will execute when the view is hold
     - Parameter onDragFinished: The closure that will execute when the view is release
     */
    
    public func isDraggable(returnToPosition: Bool = true, withDuration duration: TimeInterval = 0.5, onDragStared: (() -> Void)?, onDragFinished: (() -> Void)?) {
        let origin: CGPoint = self.frame.origin
        
        self.addPanGestureRecognizer(action: { [weak self] recognizer in
            let translation = recognizer.translation(in: self)
            guard let guardSelf = self else { return }
            switch recognizer.state {
            case .began:
                onDragStared?()
            case .changed:
                guardSelf.center = CGPoint(x: guardSelf.center.x + translation.x, y: guardSelf.center.y + translation.y)
                recognizer.setTranslation(CGPoint.zero, in: self)
            case .ended:
                onDragFinished?()
                if returnToPosition {
                    UIView.animate(withDuration: duration, animations: {
                        self?.frame.origin = origin
                    })
                }
            default:
                break
            }
        })
    }
    
}
