//
//  CharactersTableViewController.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit
import SnapKit
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
        loadData()
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
    
    func setupView() {
        self.title = self.viewModel.viewTitle
        view.backgroundColor = self.viewModel.viewBackgroundColor
        
        setupTableView()
        
        view.setNeedsUpdateConstraints()
    }
    
    private func setupTableView() {
        tableView.register(CharacterCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CharacterCell.preferredHeight()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: Load Methods
    
    func loadData() {
        if viewModel.arrayCharacters.numberOfItems > 0 {
            self.dataSource.dataObject = self.viewModel.arrayCharacters
            self.searchController.isActive = false
            self.tableView.reloadData()
        } else {
            SVProgressHUD.show(withStatus: "Loading")
            viewModel.loadData(success: {
                SVProgressHUD.dismiss()
                self.dataSource.dataObject = self.viewModel.arrayCharacters
                self.setupSearchBar()
                self.tableView.reloadData()
            }) { (error) in
                SVProgressHUD.dismiss()
                if error.code == 5000 {
                    let messageError = (error.userInfo[NSLocalizedFailureReasonErrorKey]! as AnyObject).description
                    self.showAlertMessage(title:"Error", message:messageError!)
                }
            }
        }
    }
    
    // MARK : Selector Methods
    
    func emptyDataSetTapped() {
        loadData()
    }
    
    // MARK : Alert methods
    
    func showAlertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension CharactersTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterCell.preferredHeight();
    }
}

extension CharactersTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // Do nothing for the moment
    }
}

extension CharactersTableViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.viewModel.filterContentForSearchText(searchText: searchBar.text!, completion: { (resultArray) in
            self.dataSource.dataObject = resultArray
            self.tableView.reloadData()
        }) { (error, defaultResultArray) in
            switch (error.code){
            case CharactersErrorCode.SearchTextEmpty.rawValue:
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
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let textEmpty = "No results. Tap here to reload" as NSString
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
        self.emptyDataSetTapped()
    }
}
