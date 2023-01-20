//
//  LocalDataViewController.swift
//  ConsentViewController_Example
//
//  Created by Andre Herculano on 15.11.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import ConsentViewController

struct TableData {
    struct Section {
        let title: String
        let data: [[String]]
    }

    let sections: [Section]
}

//func anyToString(_ data: Any) -> String {
//    if let data = data as? Data,
//       let stringified = String(data: data, encoding: .utf8) {
//        return stringified
//    } else {
//        return String(describing: data)
//    }
//}

class LocalDataViewController: UITableViewController {
    let cellReuseIdentifier = "cell"

    var iabData: [[String]] = UserDefaults.standard.dictionaryRepresentation()
        .filter { $0.key.starts(with: "IAB") }
        .map {[ $0.key, String(describing: $0.value) ]}
        .sorted { $0[0] > $1[0] }

    var sdkData: [[String]] = UserDefaults.standard.dictionaryRepresentation()
        .filter { $0.key.starts(with: "sp_") }
        .map {[
            $0.key,
            String(describing: $0.value)
        ]}
        .sorted { $0[0] > $1[0] }

    var allData: TableData { .init(sections: [
        .init(title: "Internal", data: sdkData),
        .init(title: "External", data: iabData)
    ])}

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        allData.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allData.sections[section].data.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        allData.sections[section].title
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 36 : 18
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        let section = indexPath.section
        let row = indexPath.row
        cell.textLabel?.text = "\(allData.sections[section].data[row][0]): \(allData.sections[section].data[row][1])"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
}
