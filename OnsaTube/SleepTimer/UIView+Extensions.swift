//
//  UIView+Extension.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 11.07.2024.
//

import UIKit

extension UIView {
    func anchorToAllSidesOf(view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
