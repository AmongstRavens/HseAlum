//
//  AccountViewController.swift
//  HseAlum
//
//  Created by Sergey on 9/29/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController{
    //MARK: Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!{
        didSet{
            avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
            avatarImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.backgroundColor = .lightGray
            scrollView.delegate = self
        }
    }
    
    var settingsBarButton : UIBarButtonItem{
        let imageView = UIImageView(image: #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        let button = UIBarButtonItem(customView: imageView)
        let widthConstraint = button.customView?.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = button.customView?.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint?.isActive = true
        widthConstraint?.isActive = true
        button.tintColor = .white
        return button
    }
    
    //MARK: Fields
    private var tableViews = [UITableView]()
    private var cellsViewModel = CustomCellViewModel()
    
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = settingsBarButton
        settingsBarButton.action = #selector(settingsButtonPressed(_:))
        settingsBarButton.target = self
        setCustomNavigationBarColor()
        setupTableViews()
        addNotificationObserver()
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var currentHeight : CGFloat = 0
        for index in 0 ..< tableViews.count{
            tableViews[index].frame = CGRect(x: 0, y: currentHeight, width: scrollView.frame.size.width, height: tableViews[index].contentSize.height)
            currentHeight += tableViews[index].frame.height
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: currentHeight + 30)
    }
    
    private func setupTableViews(){
        cellsViewModel.loadCellDescriptor(for: "smth")
        for _ in 0 ..< cellsViewModel.numberOfTableViews{
            let tableView = DynamicTableView(frame: .zero, style: .plain)
            tableView.registerCells()
            tableView.delegate = self
            tableView.dataSource = self
            scrollView.addSubview(tableView)
            tableViews.append(tableView)
            tableView.reloadData()
        }
    }
    
    @objc private func settingsButtonPressed(_ sender: UIBarButtonItem){
        //Perfrom segue
    }
    
    //MARK: Notification Center
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(forName: Notification.Name("AccountUIObserver"), object: nil, queue: .main) { (notification) in
            if let index = notification.userInfo?["index"] as? Int{
                //Update bottom tableView's origin
                let oldHeight = self.tableViews[index].frame.height
                self.tableViews[index].reloadData()
                self.tableViews[index].frame.size.height = self.tableViews[index].contentSize.height
                for viewIndex in index + 1 ..< self.tableViews.count{
                    self.tableViews[viewIndex].frame.origin.y += self.tableViews[index].frame.height - oldHeight
                }
                self.scrollView.contentSize.height += self.tableViews[index].frame.height - oldHeight
            }
        }
    }
    
}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    //MARK: UITableViewDelegate/DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = tableViews.index(of: tableView)
        if index == nil{
            return 0
        } else {
            return cellsViewModel.numberOfRows(for: index!)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = tableViews.index(of: tableView)!
        let cellDescriptor = cellsViewModel.getCellDescriptior(for: indexPath, index: index)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptor["cellIdentifier"] as! String, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Value"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableViews.index(of: tableView){
            let cellType = cellsViewModel.handleTappingRow(at: indexPath, for: index)
            if cellType == "Dropdown Cell"{
                let cell = tableView.cellForRow(at: indexPath) as! CustomCell
                cell.rotateButton()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //MARK: Page Scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y >= 0{
            //Anchor top view
            tableViews[0].frame.origin.y = y

            for index in 1 ..< tableViews.count{
                //Estimated offset if height when view should be anchored
                var estimatedOffset : CGFloat = 0
                for previousView in 0 ..< index{
                    estimatedOffset += tableViews[previousView].frame.height - 35
                }
                
                if y > estimatedOffset{
                    //Anchor other view's
                    tableViews[index].frame.origin.y = y + CGFloat(index * 35)
                } else {
                    //This fixes offset issue
                    if tableViews[index].frame.origin.y > tableViews[index - 1].frame.origin.y + tableViews[index - 1].frame.height{
                        tableViews[index].frame.origin.y = tableViews[index - 1].frame.origin.y + tableViews[index - 1].frame.height
                    }
                }
            }
        }
    }
    
}


