//
//  AccountViewController.swift
//  HseAlum
//
//  Created by Sergey on 9/29/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, PagesScrollViewDelegate{

    //MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!{
        didSet{
            avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
            avatarImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var pagesScrollView: PagesScrollView!{
        didSet{
            pagesScrollView.pageDelegate = self
            pagesScrollView.layer.zPosition = 10
        }
    }
    
    @IBOutlet weak var settingsButton: UIButton!{
        didSet{
            //Set white background image for button
            settingsButton.titleLabel?.text = ""
            let image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = .white
            settingsButton.setImage(imageView.image, for: .normal)
            
            //ios 11 uses autolayout for UIBarButtonItems
            let widthConstraint = settingsButton.widthAnchor.constraint(equalToConstant: 25)
            let heightConstraint = settingsButton.heightAnchor.constraint(equalToConstant: 25)
            heightConstraint.isActive = true
            widthConstraint.isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNavigationBarColor()
        
//        UIFont.familyNames.forEach({ familyName in
//            let fontNames = UIFont.fontNames(forFamilyName: familyName)
//            print(familyName, fontNames)
//        })
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "Show Settings View Controller", sender: self)
    }
    
    
    //MARK: PagesScrollViewDelegate
    func descriptorResourceName() -> String {
        return "accountTableViewCellsDescription"
    }
    
}


