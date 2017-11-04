//
//  DynamicTableView.swift
//  HseAlum
//
//  Created by Sergey on 10/10/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

enum PageState{
    case Closed
    case Opened
    case Scrollable
}

class DynamicTableView: UITableView {
    var state : PageState = .Scrollable
    //awdawd
    var container: UIView!{
        didSet{
            container.layer.shadowColor = UIColor.lightGray.cgColor
            container.layer.shadowOffset = CGSize.zero
            container.layer.shadowRadius = 3
            container.layer.shadowOpacity = 1
            container.layer.cornerRadius = 30
        }
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        backgroundColor = .white
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 20))
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 30
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.2
        clipsToBounds = true
    }
    
}
