//
//  NewsListViewController.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import UIKit
import SnapKit

protocol NewsListViewProtocol: UIViewController {
    var onViewDidLoad: (() -> Void)? { get set }
    var onViewDidAppear: (() -> Void)? { get set }
    var onViewDidDisappear: (() -> Void)? { get set }
    var onSegmentSelect: ((Int) -> Void)? { get set }
    var onPullToRefresh: (() -> Void)? { get set }
    var onDisplayOfLastCell: (() -> Void)? { get set }
    var onCellSelect: ((Int) -> Void)? { get set }
    
    func setupSegmentedControl(items: [String], selectedIndex: Int)
    func setupTableView()
    func setupPullToRefresh()
    func stopRefreshControl()
    func show(viewModels: [NewsListViewController.CellViewModel], animated: Bool)
}

class NewsListViewController: UIViewController, NewsListViewProtocol {
    lazy var dataSource = makeDataSource()
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var segmentedController: UISegmentedControl!
    private var viewModels = [CellViewModel]()
    
    var onViewDidLoad: (() -> Void)?
    var onViewDidAppear: (() -> Void)?
    var onViewDidDisappear: (() -> Void)?
    var onSegmentSelect: ((Int) -> Void)?
    var onPullToRefresh: (() -> Void)?
    var onDisplayOfLastCell: (() -> Void)?
    var onCellSelect: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onViewDidLoad?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        onViewDidAppear?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        onViewDidDisappear?()
    }
    
    func setupSegmentedControl(items: [String], selectedIndex: Int) {
        segmentedController = UISegmentedControl(items: items)
        segmentedController.selectedSegmentIndex = selectedIndex
        segmentedController.addTarget(self, action: #selector(segmentedControlClicked), for: .valueChanged)
        navigationItem.titleView = segmentedController
    }
    
    @objc private func segmentedControlClicked() {
        onSegmentSelect?(segmentedController.selectedSegmentIndex)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.typeName)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshControllTriggered), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshControllTriggered() {
        onPullToRefresh?()
    }
    
    func stopRefreshControl() {
        refreshControl.endRefreshing()
    }
}

extension NewsListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellSelect?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModels.count - 1 {
            onDisplayOfLastCell?()
        }
    }
}

extension NewsListViewController {
    struct CellViewModel: Hashable {
        let id = UUID()
        let title: String
        let description: String
        
        static func ==(lhs: CellViewModel, rhs: CellViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Int, CellViewModel>
    
    private func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, model in
            let cell: NewsCell = tableView.dequeueReusableCell(withIdentifier: NewsCell.typeName, for: indexPath) as! NewsCell
            cell.configure(with: model)
            
            return cell
        }
    }
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, CellViewModel>
    
    func show(viewModels: [CellViewModel], animated: Bool = false) {
        self.viewModels = viewModels
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModels, toSection: 0)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}
