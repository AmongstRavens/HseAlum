//
//  designExtensions.swift
//  HseAlum
//
//  Created by Sergey on 10/19/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func setCustomNavigationBarColor(){
        if self.navigationController != nil{
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 83/255, blue: 179/255, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : UIFont(name: "Lato-Bold", size: 16)!, NSAttributedStringKey.foregroundColor : UIColor.white]
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.barStyle = .black
        }
    }
    
}

extension UIView{
    func addBlur(){
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.layer.zPosition = -1
            self.addSubview(blurEffectView)
        }
    }
}
