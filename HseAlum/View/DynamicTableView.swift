//
//  DynamicTableView.swift
//  HseAlum
//
//  Created by Sergey on 10/10/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class DynamicTableView: UITableView {

//    override var intrinsicContentSize: CGSize {
//        self.layoutIfNeeded()
//        return CGSize(width: UIViewNoIntrinsicMetric, height: self.contentSize.height)
//    }
//
//    override func reloadData() {
//        print("in reload data")
//        super.reloadData()
//        self.invalidateIntrinsicContentSize()
//    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        backgroundColor = .white
        isScrollEnabled = false
        tableFooterView = UIView(frame: .zero)
    }
    
    func registerCells(){
        register(UINib(nibName: "dropdownButtonCell", bundle: nil), forCellReuseIdentifier: "Dropdown Cell")
        register(UINib(nibName: "basicCell", bundle: nil), forCellReuseIdentifier: "Basic Cell")
        register(UINib(nibName: "addItemCell", bundle: nil), forCellReuseIdentifier: "Add Item Cell")
        register(UINib(nibName: "switchCell", bundle: nil), forCellReuseIdentifier: "Switch Cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
