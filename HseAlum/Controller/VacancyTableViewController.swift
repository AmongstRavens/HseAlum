//
//  VacancyTableViewController.swift
//  HseAlum
//
//  Created by Sergey on 10/30/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class VacancyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNavigationBarColor()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        //Routing here
    }
    
    //MARK: UITableViewDelegate/DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Vacancy Table View Cell", for: indexPath) as! VacancyTableViewCell
        cell.vacancyImageView.image = #imageLiteral(resourceName: "avatar")
        cell.vacancyTitleLabel.text = "Full-stack web dev"
        cell.companyNameLabel.text = "Google"
        cell.dateTimeLabel.text = "21 september, 4:20"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
