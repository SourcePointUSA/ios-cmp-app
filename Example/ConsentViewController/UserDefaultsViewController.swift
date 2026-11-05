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
        let copyButton = UIBarButtonItem(
            title: "Copy",
            style: .plain,
            target: self,
            action: #selector(copyButtonTapped)
        )
        let importButton = UIBarButtonItem(
            title: "Import",
            style: .plain,
            target: self,
            action: #selector(importButtonTapped)
        )
        navigationItem.rightBarButtonItems = [importButton, copyButton]
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
        let allData = UserDefaults.standard.dictionaryRepresentation()

        // Filter to only include keys containing Didomi_*, IAB*, or sp.state
        allUserDefaultsData = allData.filter { key, _ in
            key.starts(with: "Didomi_") ||
            key.starts(with: "IAB") ||
            key == "sp.state"
        }

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

    @objc private func copyButtonTapped() {
        // Convert UserDefaults to JSON
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: convertToJSONCompatible(allUserDefaultsData),
            options: [.prettyPrinted, .sortedKeys]
        ), let jsonString = String(data: jsonData, encoding: .utf8) else {
            showError("Failed to create JSON data")
            return
        }

        // Copy to clipboard
        UIPasteboard.general.string = jsonString

        // Show confirmation
        let alert = UIAlertController(
            title: "Copied",
            message: "UserDefaults JSON copied to clipboard",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func importButtonTapped() {
        let alert = UIAlertController(
            title: "Import UserDefaults",
            message: "Paste JSON data below:",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Paste JSON here"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Import", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let jsonString = alert?.textFields?.first?.text,
                  !jsonString.isEmpty else {
                self?.showError("No JSON data provided")
                return
            }

            self.importJSON(jsonString)
        })

        present(alert, animated: true)
    }

    private func importJSON(_ jsonString: String) {
        guard let data = jsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonDict = jsonObject as? [String: Any] else {
            showError("Invalid JSON format")
            return
        }

        // Store each key-value pair in UserDefaults
        for (key, value) in jsonDict {
            if let dict = value as? [String: Any] {
                // For sp.state and similar keys, store as Data (binary) not String
                // This is required for Didomi SDK to properly detect and migrate Sourcepoint data
                if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                    UserDefaults.standard.set(jsonData, forKey: key)
                }
            } else if let array = value as? [Any] {
                // Store arrays as Data too
                if let jsonData = try? JSONSerialization.data(withJSONObject: array, options: []) {
                    UserDefaults.standard.set(jsonData, forKey: key)
                }
            } else {
                // For primitives (strings, numbers, bools), store directly
                UserDefaults.standard.set(value, forKey: key)
            }
        }

        // Reload the data
        loadUserDefaults()

        // Post notification after a delay to ensure UserDefaults data is fully persisted
        // before any listeners (like Didomi SDK re-initialization) try to read it
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NotificationCenter.default.post(name: NSNotification.Name("UserDefaultsDataImported"), object: nil)
        }

        // Show success message
        let successAlert = UIAlertController(
            title: "Success",
            message: "Imported \(jsonDict.count) key(s) to UserDefaults",
            preferredStyle: .alert
        )
        successAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(successAlert, animated: true)
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
                // Try to parse string as JSON first
                if let data = string.data(using: .utf8),
                   let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    result[key] = jsonObject
                } else {
                    result[key] = string
                }
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
