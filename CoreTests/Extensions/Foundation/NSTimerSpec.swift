//
//  NSTimerSpec.swift
//  Core
//
//  Created by Francisco Depascuali on 7/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

import Quick
import Nimble
import Core

open class NSTimerSpec: QuickSpec {
    
    override open func spec() {
        
        var timer: Timer!
        
        afterEach {
            timer!.invalidate()
            timer = nil
        }
        
        describe("#schedule(delay:)") {
            
            
            it("should trigger handler after delay") { waitUntil(timeout: 2) { done in
                timer = Timer.schedule(1) { _ in
                    done()
                }
            }}
        }
        
        describe("#schedule(repeat:)") {
            
            it("should repeteadly trigger handler after delay") { waitUntil(timeout: 5) { done in
                var timesCalled = 0
                
                timer = Timer.schedule(repeatInterval: 1) { _ in
                    timesCalled += 1
                    if timesCalled == 2 {
                        done()
                    }
                }
            }}
        }
    }
}
