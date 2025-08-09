//
//  StayingView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/03.
//

import Foundation
import UIKit

protocol StayingDelegate: AnyObject  {
    func tapEnterStoreButton()
    func tapTableViewRow(selectGuestInfo: GuestInfoModel)
    func tapDeleteTableVieRow(selectGuestInfo: GuestInfoModel)
}

public class StayingView: UIView, UITableViewDelegate, UITableViewDataSource {

    let enterStoreButton = UIButton()
    let tableView = UITableView()
    
    var screenWidth: CGFloat = -1
    var selectRow = -1
//    var selectDate: String = ""
//    var selectRepeatFlag: Bool = false
//    var selectPatternId: Int = 0
//    var selectName: String = ""
//    var selectEnterTime: String = ""
//    var selectAdultCount: Int = 0
//    var selectChildCount: Int = 0
    
    weak var delegate: StayingDelegate?
    
    var selectedStaying: GuestInfoModel = GuestInfoModel(id: -1, repeatFlag: false, patternId: -1, name: "", adultCount: 0, childCount: 0, date: "", holidayFlag: false, kidsdayFlag: false, enterTime: "", leftTime: "", stayTime: 0, calcAmount: 0, discountAmount: 0, salesAmount: 0, gachaAmount: 0, totalAmount: 0, stayingFlag: false, memo: "")
    
    var stayingList: [GuestInfoModel] = []
    
    public init() {
        super.init(frame: .zero)
        
        screenWidth = UIScreen.main.bounds.width
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stayingList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        // 古いサブビューを削除
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        let staying = stayingList[indexPath.row]
        let nameLabel = UILabel()
        if staying.name != "" {
            nameLabel.text = staying.name
        } else {
            if staying.repeatFlag {
                nameLabel.text = "リピーター様"
            } else {
                nameLabel.text = "ご新規様"
            }
        }
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.black
        
        let patternLabel = UILabel()
        switch staying.patternId {
        case 1:
            patternLabel.text = "家族"
        case 2:
            patternLabel.text = "友人"
        case 3:
            patternLabel.text = "おひとり"
        default:
            patternLabel.text = "その他"
        }
        patternLabel.textAlignment = .center
        patternLabel.textColor = UIColor.black
        
        let countLabel = UILabel()
        countLabel.text = "大人：" + String(staying.adultCount) + "名、子供：" + String(staying.childCount) + "名"
        countLabel.textAlignment = .center
        countLabel.textColor = UIColor.black
        
        let enterTimeLabel = UILabel()
        enterTimeLabel.text = staying.enterTime
        enterTimeLabel.textAlignment = .center
        enterTimeLabel.textColor = UIColor.black
        
        cell.contentView.addSubview(nameLabel)
        cell.contentView.addSubview(patternLabel)
        cell.contentView.addSubview(countLabel)
        cell.contentView.addSubview(enterTimeLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        patternLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        enterTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            nameLabel.font = UIFont.systemFont(ofSize: 12)
            patternLabel.font = UIFont.systemFont(ofSize: 12)
            countLabel.font = UIFont.systemFont(ofSize: 12)
            enterTimeLabel.font = UIFont.systemFont(ofSize: 12)
        } else { // 通常の画面の場合
            nameLabel.font = UIFont.systemFont(ofSize: 24)
            patternLabel.font = UIFont.systemFont(ofSize: 24)
            countLabel.font = UIFont.systemFont(ofSize: 24)
            enterTimeLabel.font = UIFont.systemFont(ofSize: 24)
        }

        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 32),
            nameLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.25),
            patternLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            patternLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            patternLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.25),
            countLabel.leftAnchor.constraint(equalTo: patternLabel.rightAnchor),
            countLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            countLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.25),
            enterTimeLabel.leftAnchor.constraint(equalTo: countLabel.rightAnchor),
            enterTimeLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -32),
            enterTimeLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            enterTimeLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.2)
        ])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        headerView.backgroundColor = UIColor.white
        
        let nameLabel = UILabel()
        nameLabel.text = "氏名"
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        
        let patternLabel = UILabel()
        patternLabel.text = "パターン"
        patternLabel.textColor = .black
        patternLabel.textAlignment = .center
        
        let countLabel = UILabel()
        countLabel.text = "人数"
        countLabel.textColor = .black
        countLabel.textAlignment = .center

        let enterTimeLabel = UILabel()
        enterTimeLabel.text = "入店時間"
        enterTimeLabel.textColor = .black
        enterTimeLabel.textAlignment = .center
        
        headerView.addSubview(nameLabel)
        headerView.addSubview(patternLabel)
        headerView.addSubview(countLabel)
        headerView.addSubview(enterTimeLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        patternLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        enterTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            nameLabel.font = UIFont.boldSystemFont(ofSize: 12)
            patternLabel.font = UIFont.boldSystemFont(ofSize: 12)
            countLabel.font = UIFont.boldSystemFont(ofSize: 12)
            enterTimeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        } else { // 通常の画面の場合
            nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
            patternLabel.font = UIFont.boldSystemFont(ofSize: 24)
            countLabel.font = UIFont.boldSystemFont(ofSize: 24)
            enterTimeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        }

        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 32),
            nameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.25),
            patternLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            patternLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            patternLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.25),
            countLabel.leftAnchor.constraint(equalTo: patternLabel.rightAnchor),
            countLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            countLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.25),
            enterTimeLabel.leftAnchor.constraint(equalTo: countLabel.rightAnchor, constant: 32),
            enterTimeLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -32),
            enterTimeLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            enterTimeLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.2)
        ])
        
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
        selectedStaying = stayingList[indexPath.row]
//        self.selectDate = selectedStaying.date
//        self.selectRepeatFlag = selectedStaying.repeatFlag
//        self.selectPatternId = selectedStaying.patternId
//        self.selectName = selectedStaying.name
//        self.selectEnterTime = selectedStaying.enterTime
//        self.selectAdultCount = selectedStaying.adultCount
//        self.selectChildCount = selectedStaying.childCount
        
        delegate?.tapTableViewRow(selectGuestInfo: selectedStaying)
    }

    // UITableViewの削除機能を有効にする
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // スワイプ削除の実装
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 削除データ退避
            var deleteGuestInfo = stayingList[indexPath.row]
            
            // データソースから該当のアイテムを削除
            stayingList.remove(at: indexPath.row)
            
            // テーブルビューから行を削除（アニメーション付き）
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // 必要に応じてデリゲートに削除を通知
             delegate?.tapDeleteTableVieRow(selectGuestInfo: deleteGuestInfo)
        }
    }

    // カスタムの削除ボタンテキスト（オプション）
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
}

private extension StayingView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)

        enterStoreButton.setTitle("新規入店", for: .normal)
        enterStoreButton.setTitleColor(UIColor.black, for: .normal)
        enterStoreButton.backgroundColor = UIColor.white
        enterStoreButton.layer.borderColor = UIColor.black.cgColor
        enterStoreButton.layer.borderWidth = 1.0
        enterStoreButton.layer.cornerRadius = 10
        enterStoreButton.addTarget(self, action: #selector(self.tapEnterStoreButton), for: .touchUpInside)
        self.addSubview(enterStoreButton)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        
        enterStoreButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            // TODO: サーバに繋いだら、スマホで開いた場合は新規入店ボタンを非表示としてレイアウトを整える
            // TODO: tableViewの行をタップした場合にLeaveViewへ遷移しないようにもする
            enterStoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            NSLayoutConstraint.activate([
                enterStoreButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                enterStoreButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                enterStoreButton.widthAnchor.constraint(equalToConstant: 100),
                enterStoreButton.heightAnchor.constraint(equalToConstant: 32),
                tableView.topAnchor.constraint(equalTo: enterStoreButton.bottomAnchor, constant: 8),
                tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32)
            ])
        } else { // 通常の画面の場合
            enterStoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            NSLayoutConstraint.activate([
                enterStoreButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
                enterStoreButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                enterStoreButton.widthAnchor.constraint(equalToConstant: 200),
                enterStoreButton.heightAnchor.constraint(equalToConstant: 48),
                tableView.topAnchor.constraint(equalTo: enterStoreButton.bottomAnchor, constant: 32),
                tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32)
            ])
        }
    }
    
    @objc func tapEnterStoreButton() {
        delegate?.tapEnterStoreButton()
    }
}
