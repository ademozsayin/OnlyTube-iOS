//
//  CustomNavigationHeaderView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 24.06.2024.
//

import SwiftUI

public extension View {
    @ViewBuilder func customHeaderView<Content: View>(@ViewBuilder _ headerView: @escaping () -> Content, height: CGFloat) -> some View {
        overlay(content: {
            CustomNavigationHeaderView(headerView: headerView, height: height)
                .frame(width: 0, height: 0)
        })
    }
}

public struct CustomNavigationHeaderView<HeaderView: View>: UIViewControllerRepresentable {
    @ViewBuilder public var headerView: () -> HeaderView
    let height: CGFloat
    
    public func makeUIViewController(context: Context) -> UIViewController {
        return ViewControllerWrapper(headerView: headerView, height: height)
    }
    
    class ViewControllerWrapper: UIViewController {
        let headerView: () -> HeaderView
        let height: CGFloat
        
        init(headerView: @escaping () -> HeaderView, height: CGFloat) {
            self.headerView = headerView
            self.height = height
            super.init(nibName: nil, bundle: nil)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            guard let navigationController = self.navigationController, let navigationItem = navigationController.visibleViewController?.navigationItem else { return }
            
            
            // a trick from https://x.com/sebjvidal/status/1748659522455937213
            
            let _UINavigationBarPalette = NSClassFromString("_UINavigationBarPalette") as! UIView.Type
            
            let castedHeaderView = UIHostingController(rootView: self.headerView()).view
            castedHeaderView?.frame.size.height = height
            castedHeaderView?.backgroundColor = .clear
            
            let palette = _UINavigationBarPalette.perform(NSSelectorFromString("alloc"))
                .takeUnretainedValue()
                .perform(NSSelectorFromString("initWithContentView:"), with: castedHeaderView)
                .takeUnretainedValue()
            
            navigationItem.perform(NSSelectorFromString("_setBottomPalette:"), with: palette)
            
            super.viewWillAppear(animated)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
