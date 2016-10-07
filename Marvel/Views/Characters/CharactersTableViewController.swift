//
//  CharactersTableViewController.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit
import SnapKit
import Foundation
import SVProgressHUD
import DZNEmptyDataSet

class CharactersTableViewController: UIViewController, UITableViewDelegate{
    
    var didSetupConstraints = false
    
    let tableView: UITableView = UITableView()
    let cellIdentifier = "CharacterCell"
    var charactersData = CharacterDataType()
    var dataSource = CharacterDataSource()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        simulateLoadDataThatFails()
    }
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            tableView.snp.makeConstraints({ (make) in
                make.size.equalTo(view)
                make.centerX.equalTo(view.snp.centerX)
                make.centerY.equalTo(view.snp.centerY)
            })
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        tableView.emptyDataSetSource = nil
        tableView.emptyDataSetDelegate = nil
    }

    // MARK: Setup Methods
    
    fileprivate func setupView() {
        self.title = "Characters"
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.register(CharacterCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        view.setNeedsUpdateConstraints()
    }
    
    fileprivate func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.tableFooterView = nil
        tableView.reloadData()
    }
    
    // MARK: Load Methods
    
    fileprivate func simulateLoadDataThatFails() {
        SVProgressHUD.show(withStatus: "Loading")
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(CharactersTableViewController.dismissProgressHud), userInfo: nil, repeats: true)

    }
    
    fileprivate func loadData() {
        SVProgressHUD.show(withStatus: "Loading")
        ApiManager.sharedInstance.getCharacters(success: { (result) in
                SVProgressHUD.dismiss()
                if let listChar = result.value?.characters {
                    self.charactersData = CharacterDataType(characters:listChar)
                    self.dataSource.dataObject = self.charactersData
                    self.setupTableView()
                }
            }) { (error) in
                SVProgressHUD.dismiss()
                print("Error: ", error);
        }

    }
    
    // MARK : Selector Methods
    
    func dismissProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterCell.preferredHeight();
    }
    
}

extension CharactersTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    //MARK : DZNEmptyDataSetSource
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let textEmpty = "To show a list of characters, tap here" as NSString
        let textRange = NSMakeRange(0, textEmpty.length)
        let attributedTitle = NSMutableAttributedString(string: textEmpty as String)
        attributedTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: textRange)
        return attributedTitle
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.lightGray
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true;
    }
    
    func offset(forEmptyDataSet scrollView: UIScrollView!) -> CGPoint {
        return CGPoint.zero
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return nil
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        return nil
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetDidTap(_ scrollView: UIScrollView!) {
        self.loadData()
    }
}
