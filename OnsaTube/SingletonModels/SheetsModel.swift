//
//  SheetsModel.swift
//  Atwy
//
//  Created by Antoine Bollengier on 22.10.2023.
//

import Foundation
import UIKit

@Observable
public class SheetsModel {
    public static let shared = SheetsModel()
    
    private(set) public var shownSheet: (type: SheetType, data: Any?)? = nil
    
    public var isSheetShown: Bool {
        return shownSheet != nil
    }
    
    public func showSheet(_ type: SheetType, data: Any? = nil) {
        self.shownSheet = (type, data)
    }
    
    public func hideSheet(_ type: SheetType) {
        self.shownSheet = nil
    }
    
    /// Displays a sheet that will be on top of everything, including potential other sheets.
    ///
    /// - Note: Make sure you call the method on a background thread to avoid any hang.
    public func showSuperSheet(withViewController vc: UIViewController) {
//        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene, let source =  scene.keyWindow?.rootViewController else { return }
        
        // https://forums.developer.apple.com/forums/thread/45898?answerId=134244022#134244022
        // find the controller that is already presenting a sheet and put a sheet onto its sheet
//        var parentController: UIViewController? = source
//        while((parentController?.presentedViewController != nil) &&
//              parentController != parentController?.presentedViewController){
//            parentController = parentController?.presentedViewController;
//        }
//        
//        let finalController: UIViewController
//        
//        if let parentController = parentController {
//            finalController = parentController
//        } else {
//            finalController = source
//        }
//        DispatchQueue.main.async {
//            vc.popoverPresentationController?.sourceView = finalController.view
////            vc.popoverPresentationController?.barButtonItem = finalController.navigationItem.rightBarButtonItem
//            finalController.present(vc, animated: true)
//        }
        
        // https://stackoverflow.com/questions/67078745/swiftui-share-sheet-crashes-ipad
        // Get a scene that's showing (iPad can have many instances of the same app, some in the background)
        let activeScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        
        let rootViewController = (activeScene?.windows ?? []).first(where: { $0.isKeyWindow })?.rootViewController
        
        // iPad stuff (fine to leave this in for all iOS devices, it will be effectively ignored when not needed)
        vc.popoverPresentationController?.sourceView = rootViewController?.view
        vc.popoverPresentationController?.sourceRect = .zero
        
        rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    public enum SheetType: Hashable {
        case addToPlaylist
        case settings
        case watchVideo
    }
}
