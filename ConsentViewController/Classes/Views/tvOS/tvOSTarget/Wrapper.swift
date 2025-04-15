//
//  Wrapper.swift
//  Pods
//
//  Created by Andre Herculano on 14/4/25.
//

// This file exists to satisfy SwiftPM's requirement for a source file.
// The actual purpose of this target is to bundle tvOS-only resources (e.g., XIBs).

import Foundation
import UIKit

@_exported import ConsentViewController
import ConsentViewController

private class Wrapper {}

public enum ConsentViewControllerTvOSInitializer {
    public static let initialized: Void = {
        print("ConsentViewControllerTvOSInitializer =====================")
        let bundle = Bundle(for: Wrapper.self)
        ConsentViewController.SPPMHeader.nib = UINib(nibName: "SPPMHeader", bundle: bundle)
    }()
}

