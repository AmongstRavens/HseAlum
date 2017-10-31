//
//  VacancyTableViewCell.swift
//  HseAlum
//
//  Created by Sergey on 10/30/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class VacancyTableViewCell: UITableViewCell {

    @IBOutlet weak var vacancyImageView: UIImageView!
    @IBOutlet weak var vacancyTitleLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        vacancyImageView.layer.cornerRadius = vacancyImageView.frame.width / 2
        vacancyImageView.layer.borderColor = UIColor.lightGray.cgColor
        vacancyImageView.layer.borderWidth = 1
        vacancyImageView.clipsToBounds = true
    }
    
}
