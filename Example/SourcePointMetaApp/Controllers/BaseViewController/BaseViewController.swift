//
//  BaseViewController.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 3/22/19.
//  Copyright © 2019 Cybage. All rights reserved.
////

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Instance Methods
    /// It shows indicator on top of UIWindow.
    func showIndicator() {
        //Showing indicator.
        if let baseWindow = UIApplication.shared.keyWindow as? BaseWindow {
            baseWindow.showIndicator()
        }
    }
    
    /// It hide indicator if existing on top of layout.
    func hideIndicator() {
        if let baseWindow = UIApplication.shared.keyWindow as? BaseWindow {
            baseWindow.hideIndicator()
        }
    }

}
