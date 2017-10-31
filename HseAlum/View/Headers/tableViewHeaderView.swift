//
//  tableViewHeaderView.swift
//  HseAlum
//
//  Created by Sergey on 10/20/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class tableViewHeaderView: UIView {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var parent : DynamicTableView?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 30
    }
}
