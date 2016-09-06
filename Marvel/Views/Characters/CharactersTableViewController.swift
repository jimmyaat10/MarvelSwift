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
            
            tableView.snp_makeConstraints(closure: { (make) in
                make.size.equalTo(view)
                make.centerX.equalTo(view.snp_centerX)
                make.centerY.equalTo(view.snp_centerY)
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
    
    private func setupView() {
        self.title = "Characters"
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView)
        tableView.registerClass(CharacterCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        view.setNeedsUpdateConstraints()
    }
    
    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.tableFooterView = nil
        tableView.reloadData()
    }
    
    // MARK: Load Methods
    
    private func simulateLoadDataThatFails() {
        SVProgressHUD.showWithStatus("Loading")
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(CharactersTableViewController.dismissProgressHud), userInfo: nil, repeats: true)

    }
    
    private func loadData() {
        SVProgressHUD.showWithStatus("Loading")
        ApiManager.sharedInstance.getCharacters(
            {(result) in
                SVProgressHUD.dismiss()
                if let listChar = result.value?.characters {
                    self.charactersData = CharacterDataType(characters:listChar)
                    self.dataSource.dataObject = self.charactersData
                    self.setupTableView()
                }
            })
            {(error) in
                SVProgressHUD.dismiss()
                print("Error: ", error);
        }
    }
    
    // MARK : Selector Methods
    
    func dismissProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CharacterCell.preferredHeight();
    }
    
}

extension CharactersTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    //MARK : DZNEmptyDataSetSource
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let textEmpty = "To show a list of characters, tap here" as NSString
        let textRange = NSMakeRange(0, textEmpty.length)
        let attributedTitle = NSMutableAttributedString(string: textEmpty as String)
        attributedTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: textRange)
        return attributedTitle
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.lightGrayColor()
    }
    
    func spaceHeightForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return 0
    }
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return true;
    }
    
    func offsetForEmptyDataSet(scrollView: UIScrollView!) -> CGPoint {
        return CGPointZero
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return nil
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        return nil
    }
    
    func emptyDataSetShouldAllowTouch(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetDidTapView(scrollView: UIScrollView!) {
        self.loadData()
    }
}
