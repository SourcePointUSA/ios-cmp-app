//
//  ConsentAdapter.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Didomi
import Foundation

/// Protocol for adapting CurrentUserStatus to Sourcepoint consent types
protocol ConsentAdapter<Output> {
    associatedtype Output
    func adapt(from status: CurrentUserStatus) -> Output
}
