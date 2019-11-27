//
//  SourcepointUITableView.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 3/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit

class SourcePointUITableView: UITableView {

    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        var cellFrame: CGRect = cell.frame
        
        cellFrame.size.width = frame.size.width
        cell.frame = cellFrame
        cell.layoutIfNeeded()
        return cell
    }

}

class SourcePointUItablewViewCell : UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}
