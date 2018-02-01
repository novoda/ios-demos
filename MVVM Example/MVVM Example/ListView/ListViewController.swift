//
//  ListViewController.swift
//  MVVM Example
//
//  Created by Niamh Power on 30/01/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import UIKit
import SnapKit

class ListViewController: UIViewController {

    fileprivate let viewModel: ListViewModel
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate let dataSource = ListViewDataSource()

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupHierarchy()
        setupLayout()
        bindViewModel()
    }

    fileprivate func setupViews() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        setupDataSource()
    }

    fileprivate func setupDataSource() {
        tableView.registerCell(ofType: ListCellView.self)

        dataSource.cellFactory = { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(ofType: ListCellView.self, for: indexPath)
            cell.update(with: item)
            return cell
        }

        dataSource.actionDelegate = viewModel
    }

    fileprivate func setupHierarchy() {
        view.addSubview(tableView)
    }

    fileprivate func setupLayout() {
        //TODO: use our own constraint kit
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    fileprivate func bindViewModel() {
        viewModel.didChangeData = weakify(self, method: ListViewController.updateView)
        viewModel.ready()
    }

    fileprivate func updateView(with viewData: ListViewData) {
        self.navigationItem.title = viewData.title
        dataSource.updateItems(with: viewData.items)
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        dataSource.actionDelegate?.itemPressed()
    }
}
