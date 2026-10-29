//
//  UserDefaultsViewController.swift
//  ConsentViewController_Example
//
//  Created by Andre Herculano
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsViewController: UIViewController {
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private var allUserDefaultsData: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "UserDefaults Data"
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupTextView()
        loadUserDefaults()
    }

    private func setupNavigationBar() {
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareButtonTapped)
        )
        navigationItem.rightBarButtonItem = shareButton
    }

    private func setupTextView() {
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func loadUserDefaults() {
        allUserDefaultsData = UserDefaults.standard.dictionaryRepresentation()
        displayData()
    }

    private func displayData() {
        let sortedKeys = allUserDefaultsData.keys.sorted()
        var displayText = ""

        for key in sortedKeys {
            let value = allUserDefaultsData[key]
            displayText += "\(key):\n"

            if let data = value as? Data {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    displayText += "\(prettyString)\n\n"
                } else {
                    displayText += "\(data.base64EncodedString())\n\n"
                }
            } else if let dict = value as? [String: Any],
                      let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted]),
                      let prettyString = String(data: jsonData, encoding: .utf8) {
                displayText += "\(prettyString)\n\n"
            } else if let array = value as? [Any],
                      let jsonData = try? JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted]),
                      let prettyString = String(data: jsonData, encoding: .utf8) {
                displayText += "\(prettyString)\n\n"
            } else if let stringValue = value as? String {
                // Try to parse as JSON and pretty-print
                if let data = stringValue.data(using: .utf8),
                   let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    displayText += "\(prettyString)\n\n"
                } else {
                    displayText += "\(stringValue)\n\n"
                }
            } else if let numberValue = value as? NSNumber {
                displayText += "\(numberValue)\n\n"
            } else if let dateValue = value as? Date {
                displayText += "\(ISO8601DateFormatter().string(from: dateValue))\n\n"
            } else if let urlValue = value as? URL {
                displayText += "\(urlValue.absoluteString)\n\n"
            } else if let boolValue = value as? Bool {
                displayText += "\(boolValue)\n\n"
            } else if let value = value {
                displayText += "\(value)\n\n"
            } else {
                displayText += "nil\n\n"
            }
        }

        textView.text = displayText
    }

    @objc private func shareButtonTapped() {
        // Convert UserDefaults to JSON
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: convertToJSONCompatible(allUserDefaultsData),
            options: [.prettyPrinted, .sortedKeys]
        ) else {
            showError("Failed to create JSON data")
            return
        }

        // Create temporary file
        let fileName = "UserDefaults_\(Date().timeIntervalSince1970).json"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try jsonData.write(to: tempURL)

            // Present share sheet
            let activityViewController = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )

            // For iPad support
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.barButtonItem = navigationItem.rightBarButtonItem
            }

            present(activityViewController, animated: true)

        } catch {
            showError("Failed to export data: \(error.localizedDescription)")
        }
    }

    private func convertToJSONCompatible(_ dict: [String: Any]) -> [String: Any] {
        var result: [String: Any] = [:]

        for (key, value) in dict {
            if let data = value as? Data {
                // Try to decode Data as JSON first
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    result[key] = jsonObject
                } else {
                    // Otherwise store as base64 string
                    result[key] = data.base64EncodedString()
                }
            } else if let dict = value as? [String: Any] {
                result[key] = convertToJSONCompatible(dict)
            } else if let array = value as? [Any] {
                result[key] = array
            } else if let string = value as? String {
                result[key] = string
            } else if let number = value as? NSNumber {
                result[key] = number
            } else if let date = value as? Date {
                result[key] = ISO8601DateFormatter().string(from: date)
            } else if let url = value as? URL {
                result[key] = url.absoluteString
            } else {
                result[key] = String(describing: value)
            }
        }

        return result
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
