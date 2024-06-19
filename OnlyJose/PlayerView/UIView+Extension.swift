//
//  UIView+Extension.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 10.06.2024.
//

import UIKit

extension UIView {
    func findAllChildsWithType(_ typeName: String) -> [UIView] {
        var list: [UIView] = []
        for subview in subviews {
            if String(describing: type(of: subview)) == typeName {
                list.append(subview)
            }
            list.append(contentsOf: subview.findAllChildsWithType(typeName))
        }
        return list
    }
    
    func getAllChilds() -> [UIView] {
        var childs: [UIView] = []
        for subview in subviews {
            childs.append(subview)
            childs.append(contentsOf: subview.getAllChilds())
        }
        return childs
    }
}
