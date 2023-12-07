//
//  MyFrameClass.swift
//  testMyFramework
//
//  Created by Shujat Ali on 07/12/2023.
//

import Foundation
import UIKit


class MyFrameClass {
    weak var screen : UIView? = nil
    
    static let shared = MyFrameClass()

    class func disableScreenRecording() {
        NotificationCenter.default.addObserver(shared, selector: #selector(shared.preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
    }

    @objc 
    func preventScreenRecording() {
        let isCaptured = UIScreen.main.isCaptured
        print("isCaptured: \(isCaptured)")
        if isCaptured {
            blurScreen()
        } else {
            removeBlurScreen()
        }
    }

    func blurScreen(style: UIBlurEffect.Style = UIBlurEffect.Style.regular) {
        guard let vc = getTopViewController() else {
            return
        }
        screen = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        let label = UILabel()
        label.text = "Screen recording is detected and it not allowed"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.red
        screen?.addSubview(blurBackground)
        screen?.addSubview(label)
        blurBackground.frame = (screen?.frame)!
        vc.view.addSubview(screen!)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: vc.view.frame.width * 0.8).isActive = true
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        label.centerXAnchor.constraint(equalTo: blurBackground.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: blurBackground.centerYAnchor).isActive = true
        blurBackground.bringSubviewToFront(label)
        
    }

    func removeBlurScreen() {
        screen?.removeFromSuperview()
    }
    
    func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller
            return topController
        }
        return nil
    }
}
