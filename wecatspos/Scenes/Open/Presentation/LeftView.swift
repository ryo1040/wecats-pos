//
//  LeftView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/03.
//

import Foundation
import UIKit

protocol LeftDelegate: AnyObject  {
    func tapLeftTableViewRow(selectGuestInfo: GuestInfoModel)
//    func tapDeleteTableVieRow(selectGuestInfo: GuestInfoModel)
//    func tapEditTableViewRow(selectGuestInfo: GuestInfoModel)
}

public class LeftView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let dayTotalAmountTitleLabel = UILabel()
    let dayTotalAmountLabel = UILabel()
    
    var screenWidth: CGFloat = -1
    
    weak var delegate: LeftDelegate?

    var leftList: [GuestInfoModel] = []
    
    public init() {
        super.init(frame: .zero)
        
        screenWidth = UIScreen.main.bounds.width
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calcDayTotalFee() {
        var calcSales = 0
        for leave in leftList {
            calcSales += leave.totalAmount
        }
        dayTotalAmountLabel.text = "¥" + self.commaSeparateThreeDigits(calcSales)
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 古いサブビューを削除
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        let staying = leftList[indexPath.row]
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
        
        let countLabel = UILabel()
        countLabel.text = "大人：" + String(staying.adultCount) + "名、子供：" + String(staying.childCount) + "名"
        countLabel.textAlignment = .center
        countLabel.textColor = UIColor.black
        
        let enterTimeLabel = UILabel()
        enterTimeLabel.text = staying.enterTime
        enterTimeLabel.textAlignment = .center
        enterTimeLabel.textColor = UIColor.black
        
        let leftTimeLabel = UILabel()
        leftTimeLabel.text = staying.leftTime
        leftTimeLabel.textAlignment = .center
        leftTimeLabel.textColor = UIColor.black
        
        let priceLabel = UILabel()
        priceLabel.text = "¥" + self.commaSeparateThreeDigits(staying.totalAmount)
        priceLabel.textAlignment = .center
        priceLabel.textColor = UIColor.black
        
        cell.contentView.addSubview(nameLabel)
        cell.contentView.addSubview(countLabel)
        cell.contentView.addSubview(enterTimeLabel)
        cell.contentView.addSubview(leftTimeLabel)
        cell.contentView.addSubview(priceLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        enterTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        leftTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            nameLabel.font = UIFont.systemFont(ofSize: 12)
            countLabel.font = UIFont.systemFont(ofSize: 12)
            enterTimeLabel.font = UIFont.systemFont(ofSize: 12)
            leftTimeLabel.font = UIFont.systemFont(ofSize: 12)
            priceLabel.font = UIFont.systemFont(ofSize: 12)
        } else { // 通常の画面の場合
            nameLabel.font = UIFont.systemFont(ofSize: 24)
            countLabel.font = UIFont.systemFont(ofSize: 24)
            enterTimeLabel.font = UIFont.systemFont(ofSize: 24)
            leftTimeLabel.font = UIFont.systemFont(ofSize: 24)
            priceLabel.font = UIFont.systemFont(ofSize: 24)
        }
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.24),
            countLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            countLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            countLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.24),
            enterTimeLabel.leftAnchor.constraint(equalTo: countLabel.rightAnchor),
            enterTimeLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            enterTimeLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.15),
            leftTimeLabel.leftAnchor.constraint(equalTo: enterTimeLabel.rightAnchor),
            leftTimeLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            leftTimeLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.15),
            priceLabel.leftAnchor.constraint(equalTo: leftTimeLabel.rightAnchor),
            priceLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -10),
            priceLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            priceLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.2)
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
        
        let countLabel = UILabel()
        countLabel.text = "人数"
        countLabel.textColor = .black
        countLabel.textAlignment = .center

        let enterTimeLabel = UILabel()
        enterTimeLabel.text = "入店時間"
        enterTimeLabel.textColor = .black
        enterTimeLabel.textAlignment = .center
        
        let leftTimeLabel = UILabel()
        leftTimeLabel.text = "退店時間"
        leftTimeLabel.textColor = UIColor.black
        leftTimeLabel.textAlignment = .center
        
        let priceLabel = UILabel()
        priceLabel.text = "料金"
        priceLabel.textColor = UIColor.black
        priceLabel.textAlignment = .center

        headerView.addSubview(nameLabel)
        headerView.addSubview(countLabel)
        headerView.addSubview(enterTimeLabel)
        headerView.addSubview(leftTimeLabel)
        headerView.addSubview(priceLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        enterTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        leftTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            nameLabel.font = UIFont.boldSystemFont(ofSize: 12)
            countLabel.font = UIFont.boldSystemFont(ofSize: 12)
            enterTimeLabel.font = UIFont.boldSystemFont(ofSize: 12)
            leftTimeLabel.font = UIFont.boldSystemFont(ofSize: 12)
            priceLabel.font = UIFont.boldSystemFont(ofSize: 12)
        } else { // 通常の画面の場合
            nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
            countLabel.font = UIFont.boldSystemFont(ofSize: 24)
            enterTimeLabel.font = UIFont.boldSystemFont(ofSize: 24)
            leftTimeLabel.font = UIFont.boldSystemFont(ofSize: 24)
            priceLabel.font = UIFont.boldSystemFont(ofSize: 24)
        }
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.24),
            countLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            countLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            countLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.24),
            enterTimeLabel.leftAnchor.constraint(equalTo: countLabel.rightAnchor),
            enterTimeLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            enterTimeLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.15),
            leftTimeLabel.leftAnchor.constraint(equalTo: enterTimeLabel.rightAnchor),
            leftTimeLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            leftTimeLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.15),
            priceLabel.leftAnchor.constraint(equalTo: leftTimeLabel.rightAnchor),
            priceLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -10),
            priceLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            priceLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.2)
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
        delegate?.tapLeftTableViewRow(selectGuestInfo: leftList[indexPath.row])
    }
}

private extension LeftView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        
        dayTotalAmountTitleLabel.text = "売上："
        dayTotalAmountTitleLabel.textColor = UIColor.black
        self.addSubview(dayTotalAmountTitleLabel)
        
        dayTotalAmountLabel.text = "10,000円"
        dayTotalAmountLabel.textColor = UIColor.black
        self.addSubview(dayTotalAmountLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        dayTotalAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dayTotalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            dayTotalAmountTitleLabel.font = UIFont.systemFont(ofSize: 16)
            dayTotalAmountLabel.font = UIFont.systemFont(ofSize: 16)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
                tableView.bottomAnchor.constraint(equalTo: dayTotalAmountTitleLabel.topAnchor, constant: -16),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                dayTotalAmountTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
                dayTotalAmountLabel.leftAnchor.constraint(equalTo: dayTotalAmountTitleLabel.rightAnchor, constant: 10),
                dayTotalAmountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                dayTotalAmountLabel.bottomAnchor.constraint(equalTo: dayTotalAmountTitleLabel.bottomAnchor)
            ])
        } else { // 通常の画面の場合
            dayTotalAmountTitleLabel.font = UIFont.systemFont(ofSize: 32)
            dayTotalAmountLabel.font = UIFont.systemFont(ofSize: 32)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
                tableView.bottomAnchor.constraint(equalTo: dayTotalAmountTitleLabel.topAnchor, constant: -32),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                dayTotalAmountTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
                dayTotalAmountLabel.leftAnchor.constraint(equalTo: dayTotalAmountTitleLabel.rightAnchor, constant: 10),
                dayTotalAmountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                dayTotalAmountLabel.bottomAnchor.constraint(equalTo: dayTotalAmountTitleLabel.bottomAnchor)
            ])
        }
    }
    
    func commaSeparateThreeDigits(_ amount:Int) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.groupingSize = 3
        nf.groupingSeparator = ","
        let result = nf.string(from: NSNumber(integerLiteral: amount)) ?? "\(amount)"
        return result
    }
}
