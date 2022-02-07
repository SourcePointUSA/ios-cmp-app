//
//  SPPublisherData.swift
//  Pods
//
//  Created by Andre Herculano on 03.02.22.
//

import Foundation

/// A dictionary of `[String: String]` of arbitrary key/values used to send data from the publisher
/// app to our data pipeline so it can be later retrieved by the publisher via specific APIs.
///
/// Example: The publisher can send user identifiers that will be aggregated to our data. When the publisher
/// pull the data from our APIs they will be able to match our data against the data they have sent.
public typealias SPPublisherData = [String: String]
