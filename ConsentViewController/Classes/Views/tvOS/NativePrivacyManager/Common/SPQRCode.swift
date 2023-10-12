//
//  SPQRCode.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 27.07.21.
//

import UIKit

class QRCode: UIImage {
    convenience init?(from string: String, scale: Int = 1) {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))

            if let output = filter.outputImage?.transformed(by: transform) {
                self.init(ciImage: output)
                return
            }
        }
        return nil
    }
}
