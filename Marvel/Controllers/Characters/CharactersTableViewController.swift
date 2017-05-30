//
//  CharactersTableViewController.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import SnapKit
import SVProgressHUD
import DZNEmptyDataSet
import RxCocoa
import RxSwift

class CharactersTableViewController: UIViewController, UITableViewDelegate {
    
    fileprivate var didSetupConstraints = false
    fileprivate var hasSearched = false
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CharacterCell.preferredHeight()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var viewModel: CharactersViewModel!
    fileprivate var dataSource = CharacterDataSource()
    
    fileprivate let disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated (protect against retain cycle)
    
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewConfiguration()
        setupTableView()
        configureKeyboardDismissesOnScroll()
        configureKeyboardDismissesOnTouchCell()
        loadData()
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            tableView.snp.makeConstraints { make in
                make.centerX.centerY.size.equalTo(view)
            }
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
    
    fileprivate func setupTableView() {
        tableView.registerCustomCell(type: CharacterCell.self)
    }
    
    fileprivate func configureKeyboardDismissesOnScroll() {
        let searchBar = self.searchController.searchBar
        
        tableView.rx.contentOffset
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                if strongSelf.hasSearched && searchBar.isFirstResponder {
                    _ = searchBar.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func configureKeyboardDismissesOnTouchCell() {
        tableView
            .rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self else { return }
                if strongSelf.searchController.searchBar.isFirstResponder == true {
                    strongSelf.searchController.searchBar.endEditing(true)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func setupSearchBar() {
//        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar
            .rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                guard let strongSelf = self else { return }
                if query != "" {
                    strongSelf.hasSearched = true
                }
                strongSelf.viewModel.filterContentForSearchText(searchText: query,
                    completion: { resultArray in
                        strongSelf.dataSource.dataObject = resultArray
                        strongSelf.tableView.reloadData()
                    }, fail: { (error, defaultResultArray) in
                        switch error{
                        case CharactersError.searchTextEmpty( _):
                            strongSelf.dataSource.dataObject = defaultResultArray
                            strongSelf.hasSearched = false
                            strongSelf.tableView.reloadData()
                            break;
                        case CharactersError.searchNoResultsFound( _):
                            strongSelf.dataSource.dataObject = CharacterDataType()
                            strongSelf.tableView.reloadData()
                            break;
                        default:
                            break;
                        }
                    }
                )
            })
            .addDisposableTo(disposeBag)
    }
    
    // MARK: Load Methods
    
    func loadData() {
        //TODO AAT: Change to reactive approax
        if viewModel.arrayCharacters.numberOfItems > 0 {
            self.dataSource.dataObject = self.viewModel.arrayCharacters
            self.searchController.isActive = false
            self.tableView.reloadData()
        } else {
            SVProgressHUD.show(withStatus: "Loading")
            viewModel.loadData(
                success: { [weak self] _ in
                    SVProgressHUD.dismiss()
                    guard let strongSelf = self else { return }
                    strongSelf.dataSource.dataObject = strongSelf.viewModel.arrayCharacters
                    strongSelf.setupSearchBar()
                    strongSelf.tableView.reloadData()
                }, fail: { error in
                    SVProgressHUD.dismiss()
                    switch error {
                        case CharactersError.noInternet(let message):
                            self.showAlertMessage(title: "Error", message: message)
                        default:
                            break;
                    }
                }
            )
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

extension CharactersTableViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(tableView)
    }
    
    func makeConstraints() {
        view.setNeedsUpdateConstraints()
    }
    
    func setupViews() {
        self.title = self.viewModel.viewTitle
        view.backgroundColor = self.viewModel.viewBackgroundColor
    }
}

extension CharactersTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
