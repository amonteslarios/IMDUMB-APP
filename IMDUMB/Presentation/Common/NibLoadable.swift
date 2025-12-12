//
//  NibLoadable.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

protocol NibLoadable: AnyObject {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {

    static var nibName: String {
        String(describing: Self.self)
    }

    static func fromNib() -> Self {
        Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)!.first as! Self
    }
}
