//
//  UICollectionViewCenterLayout.swift
//  SalamBro
//
//  Created by Arystan on 4/22/21.
//

import UIKit

class UICollectionViewCenterLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var rows = [CollectionViewRow]()
        var currentRowY: CGFloat = -1

        for attribute in attributes {
            if currentRowY != attribute.frame.midY {
                currentRowY = attribute.frame.midY
                rows.append(CollectionViewRow(spacing: 8))
            }
            rows.last?.add(attribute: attribute)
        }

        rows.forEach { $0.centerLayout(collectionViewWidth: collectionView?.frame.width ?? 0) }
        return rows.flatMap { $0.attributes }
    }
}

class CollectionViewRow {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }

    var rowWidth: CGFloat {
        return attributes.reduce(0) { result, attribute -> CGFloat in
            result + attribute.frame.width
        } + CGFloat(attributes.count - 1) * spacing
    }

    func centerLayout(collectionViewWidth: CGFloat) {
        let padding = (collectionViewWidth - rowWidth) / 2
        var offset = padding
        for attribute in attributes {
            attribute.frame.origin.x = offset
            offset += attribute.frame.width + spacing
        }
    }
}
