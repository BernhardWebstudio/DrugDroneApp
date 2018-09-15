//
//  Style.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import UIKit

public struct Style<View: UIView> {
    
    public let style: (View) -> Void
    
    public init(_ style: @escaping (View) -> Void) {
        self.style = style
    }
    
    public func apply(to view: View) {
        style(view)
    }
}

extension UIView {
    
    public convenience init<T>(style: Style<T>) {
        self.init(frame: .zero)
        apply(style)
    }
    
    public func apply<T>(_ style: Style<T>) {
        guard let view = self as? T else {
            return
        }
        style.apply(to: view)
    }
}
