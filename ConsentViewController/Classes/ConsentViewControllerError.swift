//
//  ConsentError.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 12.03.19.
//

import Foundation

public enum ConsentViewControllerError: Error {
    case APIError(message: String)
    case BuildError(message: String)
}
