//
//  Theme.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 06.02.2022.
//

import Foundation
import UIKit.UIColor

extension UIColor{
    enum Theme{
        static let MainColor = UIColor(named: "MainColor")
        static let TableResultColor = UIColor(named: "TableResult")
    }
}

extension UIFont {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
        
    static func sumFont() -> UIFont{
        return customFont(name: "dewberry", size: 30)
    }
    
    static func descFont() -> UIFont{
        return UIFont.systemFont(ofSize: 14)
    }
    
    static func cellFont() -> UIFont{
        return customFont(name: "dewberry", size: 20)
    }
}

