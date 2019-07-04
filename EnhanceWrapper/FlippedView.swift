//
//  FlippedView.swift
//  EnhanceWrapper
//
//  Created by Kostiantyn Gorbunov on 04/07/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Foundation
import Cocoa

class FlippedView: NSView {
    
    override var isFlipped: Bool {
        get {
            return true
        }
    }
}
