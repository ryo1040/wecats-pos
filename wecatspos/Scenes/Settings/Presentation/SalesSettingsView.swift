//
//  SalesSettingsView.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import Foundation
import UIKit

protocol SalesSettingsViewDelegate: AnyObject {
    func tapNewButton()
    func tapEditTableViewRow(selectedSalesMaster: SalesMasterModel)
    func tapDeleteTableViewRow(selectedSalesMaster: SalesMasterModel)
}

public class SalesSettingsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let newButton = UIButton()
    
    var salesMasterList: [SalesMasterModel] = []
    var selectedSalesMaster: SalesMasterModel = SalesMasterModel()
    
    weak var delegate: SalesSettingsViewDelegate?

    var screenWidth: CGFloat = -1
    var selectRow = -1
    
    public init() {
        super.init(frame: .zero)
        
        screenWidth = UIScreen.main.bounds.width
        
        setupViews()
//        presenter.load()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItems(salesMasterModel: [SalesMasterModel]) {
        self.salesMasterList = salesMasterModel
        tableView.reloadData()
    }
        
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salesMasterList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        // 古いサブビューを削除
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        let salesMaster = salesMasterList[indexPath.row]
        let nameLabel = UILabel()
        nameLabel.text = salesMaster.name
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.black

        let priceLabel = UILabel()
        priceLabel.text = commaSeparateThreeDigits(salesMaster.price) + "円"
        priceLabel.textAlignment = .center
        priceLabel.textColor = UIColor.black

        let orderByLabel = UILabel()
        orderByLabel.text = String(salesMaster.order)
        orderByLabel.textAlignment = .center
        orderByLabel.textColor = UIColor.black
        
        let memoLabel = UILabel()
        memoLabel.text = salesMaster.memo
        memoLabel.textAlignment = .center
        memoLabel.numberOfLines = 0
        memoLabel.textColor = UIColor.black
        
        cell.contentView.addSubview(nameLabel)
        cell.contentView.addSubview(priceLabel)
        cell.contentView.addSubview(orderByLabel)
        cell.contentView.addSubview(memoLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        orderByLabel.translatesAutoresizingMaskIntoConstraints = false
        memoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            nameLabel.font = UIFont.systemFont(ofSize: 12)
            priceLabel.font = UIFont.systemFont(ofSize: 12)
            orderByLabel.font = UIFont.systemFont(ofSize: 12)
            memoLabel.font = UIFont.systemFont(ofSize: 12)
        } else { // 通常の画面の場合
            nameLabel.font = UIFont.systemFont(ofSize: 24)
            priceLabel.font = UIFont.systemFont(ofSize: 24)
            orderByLabel.font = UIFont.systemFont(ofSize: 24)
            memoLabel.font = UIFont.systemFont(ofSize: 24)
        }

        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.30),
            priceLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            priceLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            priceLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.20),
            orderByLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor),
            orderByLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            orderByLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.15),
            memoLabel.leftAnchor.constraint(equalTo: orderByLabel.rightAnchor),
            memoLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
            memoLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            memoLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.35)
        ])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        headerView.backgroundColor = UIColor.white
        
        let nameLabel = UILabel()
        nameLabel.text = "名前"
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        
        let priceLabel = UILabel()
        priceLabel.text = "値段"
        priceLabel.textAlignment = .center
        priceLabel.textColor = UIColor.black

        let orderByLabel = UILabel()
        orderByLabel.text = "並び順"
        orderByLabel.textAlignment = .center
        orderByLabel.textColor = UIColor.black

        let memoLabel = UILabel()
        memoLabel.text = "備考"
        memoLabel.textAlignment = .center
        memoLabel.textColor = UIColor.black
        
        headerView.addSubview(nameLabel)
        headerView.addSubview(priceLabel)
        headerView.addSubview(orderByLabel)
        headerView.addSubview(memoLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        orderByLabel.translatesAutoresizingMaskIntoConstraints = false
        memoLabel.translatesAutoresizingMaskIntoConstraints = false
                
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            nameLabel.font = UIFont.boldSystemFont(ofSize: 12)
            priceLabel.font = UIFont.boldSystemFont(ofSize: 12)
            orderByLabel.font = UIFont.boldSystemFont(ofSize: 12)
            memoLabel.font = UIFont.boldSystemFont(ofSize: 12)
            NSLayoutConstraint.activate([
                nameLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor),
                nameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                nameLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.30),
                priceLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
                priceLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                priceLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.20),
                orderByLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor),
                orderByLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                orderByLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.15),
                memoLabel.leftAnchor.constraint(equalTo: orderByLabel.rightAnchor),
                memoLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor),
                memoLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                memoLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.35)
            ])
        } else { // 通常の画面の場合
            nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
            priceLabel.font = UIFont.boldSystemFont(ofSize: 24)
            orderByLabel.font = UIFont.boldSystemFont(ofSize: 24)
            memoLabel.font = UIFont.boldSystemFont(ofSize: 24)
            NSLayoutConstraint.activate([
                nameLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor),
                nameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                nameLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.30),
                priceLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
                priceLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                priceLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.20),
                orderByLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor),
                orderByLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                orderByLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.15),
                memoLabel.leftAnchor.constraint(equalTo: orderByLabel.rightAnchor),
                memoLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor),
                memoLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                memoLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.35)
            ])
        }
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            return 20
        } else { // 通常の画面の場合
            return 40
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // レスポンシブデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            return 40
        } else { // 通常の画面の場合
            return 60
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow = indexPath.row
        selectedSalesMaster = salesMasterList[indexPath.row]
        
//        delegate?.tapTableViewRow(selectedDenomination: selectedDenomination)
    }

    // UITableViewの削除機能を有効にする
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // スワイプアクションの設定
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 削除アクション
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            
            // 削除データ退避
            let deleteSalesMaster = self.salesMasterList[indexPath.row]
            
            // データソースから該当のアイテムを削除
            self.salesMasterList.remove(at: indexPath.row)
            
            // テーブルビューから行を削除（アニメーション付き）
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // デリゲートに削除を通知
            self.delegate?.tapDeleteTableViewRow(selectedSalesMaster: deleteSalesMaster)
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        // 編集アクション
        let editAction = UIContextualAction(style: .normal, title: "編集") { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            
            let editSalesMaster = self.salesMasterList[indexPath.row]
            
            // デリゲートに編集を通知
            self.delegate?.tapEditTableViewRow(selectedSalesMaster: editSalesMaster)
            
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue

        // スワイプアクション設定を作成（右から左にスワイプ時）
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false // フルスワイプで自動実行を無効化
        
        return configuration
    }
}

private extension SalesSettingsView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        
        newButton.setTitle("新規登録", for: .normal)
        newButton.setTitleColor(UIColor.black, for: .normal)
        newButton.backgroundColor = UIColor.white
        newButton.layer.borderColor = UIColor.black.cgColor
        newButton.layer.borderWidth = 1.0
        newButton.layer.cornerRadius = 10
        newButton.addTarget(self, action: #selector(self.tapNewButton), for: .touchUpInside)
        self.addSubview(newButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        newButton.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            newButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                tableView.bottomAnchor.constraint(equalTo: newButton.topAnchor, constant: -16),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                newButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
                newButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
                newButton.widthAnchor.constraint(equalToConstant: 100),
                newButton.heightAnchor.constraint(equalToConstant: 24),
            ])
        } else { // 通常の画面の場合
            newButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
                tableView.bottomAnchor.constraint(equalTo: newButton.topAnchor, constant: -24),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                newButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
                newButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
                newButton.widthAnchor.constraint(equalToConstant: 160),
                newButton.heightAnchor.constraint(equalToConstant: 48),
            ])
        }
    }
    
    @objc func tapNewButton() {
        delegate?.tapNewButton()
    }
    
    func commaSeparateThreeDigits(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}
