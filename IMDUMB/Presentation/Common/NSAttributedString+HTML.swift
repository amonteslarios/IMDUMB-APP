//
//  NSAttributedString+HTML.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

extension NSAttributedString {

    convenience init?(htmlString: String, font: UIFont) {
        let data = Data(htmlString.utf8)
        let options: [DocumentReadingOptionKey: Any] = [
            .documentType: DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let mutable = try? NSMutableAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else {
            return nil
        }

        mutable.addAttribute(.font, value: font, range: NSRange(location: 0, length: mutable.length))
        self.init(attributedString: mutable)
    }
}
