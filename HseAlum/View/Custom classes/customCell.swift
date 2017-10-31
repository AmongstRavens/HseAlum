//
//  customCell.swift
//  HseAlum
//
//  Created by Sergey on 9/29/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import Foundation
import UIKit

class CustomCell : UITableViewCell{
    
    //MARK: Xib outlets
    @IBOutlet weak var switchCellLabel: UILabel!
    @IBOutlet weak var switchCellSwitch: UISwitch!{
        didSet{
            if switchCellSwitch != nil{
                switchCellSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.85);
            }
        }
    }
    @IBOutlet weak var dropdownCellImageView: UIImageView!
    @IBOutlet weak var dropdownCellLabel: UILabel!
    @IBOutlet weak var addItemCellLabel: UILabel!
    @IBOutlet weak var addItemCellButton: UIButton!
    
    
    //MARK: Outlet actions
    @IBOutlet weak var dropdownButtonPressed: UIButton!
    
    
    private var dropdownState : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset.left = 20
        separatorInset.right = 20
    }
    
    func rotateButton(){
        if dropdownState == false{
            //Clockwise rotation
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                if self.dropdownCellImageView != nil{
                    self.dropdownCellImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
                }
            }, completion: { (flag) in
                self.dropdownState = true
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                if self.dropdownCellImageView != nil{
                    self.dropdownCellImageView.transform = CGAffineTransform(rotationAngle: 0)
                }
            }, completion: { (flag) in
                self.dropdownState = false
            })
        }
    }
}
