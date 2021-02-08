//
//  BaseWindow.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 3/26/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit

class BaseWindow: UIWindow {

    // MARK: - Instance Properties

    /// It is indicator view, which will appears on top of window.
    let loaderView = LoaderView(frame: CGRect.zero)

    // MARK: - Instance Methods

    /// Show the indicator view, and make user unable to interact.
    func showIndicator() {

        guard loaderView.superview != nil else {
            if let keyView = rootViewController?.view {
                loaderView.show(inView: keyView)
                bringSubviewToFront(loaderView)
                return
            }
            return
        }
    }

    /// Hide the indicator view, and make user able to interact with the system.
    func hideIndicator() {

            loaderView.hide()
            sendSubviewToBack(loaderView)
    }
}
