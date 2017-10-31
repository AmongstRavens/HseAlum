//
//  pagesScrollView.swift
//  HseAlum
//
//  Created by Sergey on 10/29/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import Foundation
import UIKit


protocol PagesScrollViewDelegate: class{
    func descriptorResourceName() -> String
}

class PagesScrollView : UIScrollView{
    
    //MARK: Fields
    private struct designConstants{
        static var cellHeight : CGFloat = 40
        static var headerHeight : CGFloat = 50
        static var headerStickout : CGFloat = 15
    }
    
    weak var pageDelegate : PagesScrollViewDelegate?{
        didSet{
            if pageDelegate != nil{
                descriptorResourceName = pageDelegate!.descriptorResourceName()
            }
        }
    }
    
    private var tapGesture: UITapGestureRecognizer!
    private var descriptorResourceName : String!
    private var customCellsViewModel = CustomCellViewModel()
    private var tableViews = [DynamicTableView]()

    //MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        //To make shadow visible
        self.contentInset.top = 2
        self.contentSize = CGSize(width: self.frame.width, height: self.frame.height + 50)
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        
        customCellsViewModel.loadCellDescriptor(for: descriptorResourceName)
        addTableViews(count: customCellsViewModel.numberOfTableViews)
        tableViewUIObserver()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentSize = CGSize(width: self.frame.width, height: self.frame.height + 50)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Set tableViews height to fill space
        for index in 0 ..< tableViews.count{
            if index == 0{
                tableViews[index].frame.size = CGSize(width: self.frame.width, height: self.frame.height - CGFloat(customCellsViewModel.numberOfTableViews - 1) * designConstants.headerStickout)
            } else{
                tableViews[index].frame.size = CGSize(width: self.frame.width, height: self.frame.height - CGFloat(customCellsViewModel.numberOfTableViews) * designConstants.headerStickout)
            }
        }
    }
    
    private func addTableViews(count: Int){
        for index in 0 ..< count{
            let shadowContainer = UIView(frame: CGRect(x: 0, y: CGFloat(index) * designConstants.headerHeight, width: 0, height: 0))
            let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            let tableView = DynamicTableView(frame: frame, style: .plain)
            tableView.registerCells()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.isScrollEnabled = false
            
            shadowContainer.addSubview(tableView)
            self.addSubview(shadowContainer)
            tableViews.append(tableView)
        }
    }
    
    //MARK: Animation section
    private var panGesture : UIPanGestureRecognizer!
    
    @objc private func handleTapGesture(_ gesture: UIGestureRecognizer){
        let page = gesture.view as! tableViewHeaderView
        if let pickedTableView = page.parent{
            animateTransition(pickedView: pickedTableView, withDuration: 0.6, header: page)
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer){
        let page = gesture.view as! tableViewHeaderView
        if let pickedTableView = page.parent{
            switch gesture.state{
            case .began, .changed:
                pickedTableView.frame.origin.y = gesture.translation(in: pickedTableView).y
            case .ended:
                print(gesture.translation(in: pickedTableView))
                if gesture.translation(in: pickedTableView).y / pickedTableView.frame.height < 0.5{
                    pickedTableView.state = .Opened
                    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        pickedTableView.frame.origin.y = 0
                        self.contentOffset.y = 0
                    }, completion: nil)
                } else{
                    for view in tableViews{
                        view.state = .Scrollable
                        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                            view.frame.origin.y = CGFloat(self.tableViews.index(of: view)!) * designConstants.headerHeight
                            self.contentOffset.y = 0
                        }, completion: { _ in
                            self.isScrollEnabled = true
                            page.removeGestureRecognizer(self.panGesture)
                        })
                    }
                }
            default:
                return
            }
        }
    }
    
    private func animateTransition(pickedView: DynamicTableView, withDuration duration: TimeInterval, header: tableViewHeaderView){
        switch pickedView.state {
        case .Scrollable:
            for view in tableViews{
                self.isScrollEnabled = false
                if view == pickedView{
                    if panGesture == nil{
                        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
                    }
                    header.addGestureRecognizer(panGesture)
                    view.state = .Opened
                    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        view.frame.origin.y = 0
                        self.contentOffset.y = 0
                    }, completion: nil)
                } else{
                    view.state = .Closed
                    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        view.frame.origin.y = self.frame.height - CGFloat(self.tableViews.count - self.tableViews.index(of: view)!) * designConstants.headerStickout
                    }, completion: nil)
                }
            }
        case .Opened, .Closed:
            self.isScrollEnabled = true
            for view in tableViews{
                view.state = .Scrollable
                header.removeGestureRecognizer(panGesture)
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    view.frame.origin.y = CGFloat(self.tableViews.index(of: view)!) * designConstants.headerHeight
                }, completion: nil)
            }
        }
        
        
    }

   
    
    
    //MARK: Notification center
    private func tableViewUIObserver(){
        NotificationCenter.default.addObserver(forName: Notification.Name("AccountUIObserver"), object: nil, queue: .main) { (notification) in
                if let index = notification.userInfo?["index"] as? Int{
                    //Update bottom tableView's origin
                    self.tableViews[index].reloadData()
                }
            }
    }

}


//MARK: UITableViewDelegate/DataSource, UIScrollViewDelegate
extension PagesScrollView : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    //MARK: TableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = tableViews.index(of: tableView as! DynamicTableView)!
        let cellDescriptor = customCellsViewModel.getCellDescriptior(for: indexPath, index: index)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptor["cellIdentifier"] as! String, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let index = tableViews.index(of: tableView as! DynamicTableView){
            return customCellsViewModel.numberOfRows(for: index)
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableViews.index(of: tableView as! DynamicTableView){
            let cellType = customCellsViewModel.handleTappingRow(at: indexPath, for: index)
            if cellType == "Dropdown Cell"{
                let cell = tableView.cellForRow(at: indexPath) as! CustomCell
                cell.rotateButton()
            }
        }
    }
    
    //MARK: TableView header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("tableViewHeader", owner: self, options: nil)?.first as! tableViewHeaderView
        headerView.headerLabel.text = "Header Label Text"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.parent = tableView as? DynamicTableView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return designConstants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return designConstants.headerHeight
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Should not work if we open any page
        if self.isScrollEnabled == true && scrollView.contentOffset.y < 0{
            for index in 0 ..< tableViews.count{
                //This provides scrolldown effect
                //Change 0.8 constant to increase velocity and 0.1 to provide more/less slide out effect
                tableViews[index].frame.origin.y = scrollView.contentOffset.y * (0.8 - CGFloat(Double(index) * 0.1)) + designConstants.headerHeight * CGFloat(index)
            }
        }
    }
}
