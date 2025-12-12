//
//  ActorCollectionViewCell.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

final class ActorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    func configure(with actor: Actor) {
        nameLabel.text = actor.name
    }
}
