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

class CharactersTableViewController: UIViewController{
    
    var didSetupConstraints = false
    
    let tableView: UITableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "CharacterCell"
    let viewModel = CharactersTableViewModel()
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
        self.title = self.viewModel.viewTitle
        view.backgroundColor = self.viewModel.viewBackgroundColor

        setupTableView()
        
        view.setNeedsUpdateConstraints()
    }
    
    private func setupTableView() {
        tableView.registerClass(CharacterCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: Load Methods
    
    private func simulateLoadDataThatFails() {
        SVProgressHUD.showWithStatus("Loading")
        viewModel.simulateLoadDataThatFails { (completion) in
            if completion {
                self.dismissProgressHud()
            }
        }
    }
    
    private func loadData() {
        if viewModel.arrayCharacters.numberOfItems > 0 {
            self.dataSource.dataObject = self.viewModel.arrayCharacters
            self.searchController.active = false
            self.tableView.reloadData()
        } else {
            SVProgressHUD.showWithStatus("Loading")
            viewModel.loadData({ (result) in
                SVProgressHUD.dismiss()
                self.dataSource.dataObject = self.viewModel.arrayCharacters
                self.setupSearchBar()
                self.tableView.reloadData()
            }) { (error) in
                SVProgressHUD.dismiss()
            }
        }
    }
    
    // MARK : Selector Methods
    
    func emptyDataSetTapped() {
        loadData()
    }
    
    func dismissProgressHud() {
        SVProgressHUD.dismiss()
    }
    
}

extension CharactersTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CharacterCell.preferredHeight();
    }
}

extension CharactersTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // Do nothing for the moment
    }
}

extension CharactersTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.viewModel.filterContentForSearchText(searchBar.text!, completion: { (resultArray) in
            self.dataSource.dataObject = resultArray
            self.tableView.reloadData()
            }) { (error, defaultResultArray) in
                switch (error.code){
                case CharactersErrorCode.SearchTextEmpty.rawValue:
                    print("Text empty, reload defaultResult")
                    self.dataSource.dataObject = defaultResultArray
                    self.tableView.reloadData()
                    break;
                case CharactersErrorCode.SearchNoResultsFound.rawValue:
                    self.dataSource.dataObject = CharacterDataType()
                    self.tableView.reloadData()
                    break;
                default:
                    break;
                }
        }
    }
}

extension CharactersTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    //MARK : DZNEmptyDataSetSource
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let textEmpty = "No results. Tap here to reload" as NSString
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
        self.emptyDataSetTapped()
    }
}
