//
//  DayTotalView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/09.
//

import Foundation
import UIKit

protocol DayTotalDelegate: AnyObject  {
    func changeDay(day: String)
    func tapDayTotalTableViewRow(selectGuestInfo: GuestInfoModel)
    func tapEditDayTotalTableViewRow(selectGuestInfo: GuestInfoModel)
    func tapDeleteDayTotalTableVieRow(selectGuestInfo: GuestInfoModel)
}

public class DayTotalView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let prevButton = UIButton()
    let dayLabel = UILabel()
    private let datePicker = UIDatePicker()
    let nextButton = UIButton()
    
    let tableView = UITableView()
    
    let dayTotalAmountTitleLabel = UILabel()
    let dayTotalAmountLabel = UILabel()
    
    var screenWidth: CGFloat = -1
    
    var guestList: [GuestInfoModel] = []
    
    weak var delegate: DayTotalDelegate?
    
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
        for leave in guestList {
            calcSales += leave.totalAmount
        }
        dayTotalAmountLabel.text = "¥" + self.commaSeparateThreeDigits(calcSales)
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 古いサブビューを削除
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        let guest = guestList[indexPath.row]
        let nameLabel = UILabel()
        if guest.name != "" {
            nameLabel.text = guest.name
        } else {
            if guest.repeatFlag {
                nameLabel.text = "リピーター様"
            } else {
                nameLabel.text = "ご新規様"
            }
        }
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.black
        
        let countLabel = UILabel()
        countLabel.text = "大人：" + String(guest.adultCount) + "名、子供：" + String(guest.childCount) + "名"
        countLabel.textAlignment = .center
        countLabel.textColor = UIColor.black
        
        let enterTimeLabel = UILabel()
        enterTimeLabel.text = guest.enterTime
        enterTimeLabel.textAlignment = .center
        enterTimeLabel.textColor = UIColor.black
        
        let leftTimeLabel = UILabel()
        leftTimeLabel.text = guest.leftTime
        leftTimeLabel.textAlignment = .center
        leftTimeLabel.textColor = UIColor.black
        
        let priceLabel = UILabel()
        priceLabel.text = "¥" + self.commaSeparateThreeDigits(guest.totalAmount)
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
        delegate?.tapDayTotalTableViewRow(selectGuestInfo: guestList[indexPath.row])
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
            let deleteGuestInfo = self.guestList[indexPath.row]
            
            // データソースから該当のアイテムを削除
            self.guestList.remove(at: indexPath.row)
            
            // テーブルビューから行を削除（アニメーション付き）
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // デリゲートに削除を通知
            self.delegate?.tapDeleteDayTotalTableVieRow(selectGuestInfo: deleteGuestInfo)
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        // 編集アクション
        let editAction = UIContextualAction(style: .normal, title: "編集") { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            
            let editGuestInfo = self.guestList[indexPath.row]
            
            // デリゲートに編集を通知
            self.delegate?.tapEditDayTotalTableViewRow(selectGuestInfo: editGuestInfo)
            
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue
        
        // スワイプアクション設定を作成（右から左にスワイプ時）
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false // フルスワイプで自動実行を無効化
        
        return configuration
    }
}

private extension DayTotalView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)

        prevButton.setTitle("<<前日", for: .normal)
        prevButton.setTitleColor(UIColor.black, for: .normal)
        prevButton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        prevButton.layer.borderColor = UIColor.black.cgColor
        prevButton.layer.borderWidth = 0
        prevButton.layer.cornerRadius = 10
        prevButton.addTarget(self, action: #selector(self.tapPrevButton), for: .touchUpInside)
        self.addSubview(prevButton)
        
        // 当日の日付をフォーマットしてdayLabelにセット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let today = Date()
        dayLabel.text = formatter.string(from: today)
        dayLabel.textColor = UIColor.black
        dayLabel.isUserInteractionEnabled = true
        self.addSubview(dayLabel)
        
        // dayLabelにタップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayLabelTapped))
        dayLabel.addGestureRecognizer(tapGesture)
        
        nextButton.setTitle("翌日>>", for: .normal)
        nextButton.setTitleColor(UIColor.black, for: .normal)
        nextButton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        nextButton.layer.borderColor = UIColor.black.cgColor
        nextButton.layer.borderWidth = 0
        nextButton.layer.cornerRadius = 10
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(self.tapNextButton), for: .touchUpInside)
        self.addSubview(nextButton)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        
        // UIDatePickerの設定
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ja_JP") // 日本語ロケール
        datePicker.maximumDate = Date()

        // ツールバーを追加
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelDatePicker))
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneDatePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)

        // dayLabelにUIDatePickerを関連付け
        let dummyTextField = UITextField(frame: .zero) // ダミーのテキストフィールドを使用
        dummyTextField.inputView = datePicker
        dummyTextField.inputAccessoryView = toolbar
        self.addSubview(dummyTextField)
        dummyTextField.isHidden = true
        dayLabel.addGestureRecognizer(UITapGestureRecognizer(target: dummyTextField, action: #selector(dummyTextField.becomeFirstResponder)))
        
        dayTotalAmountTitleLabel.text = "売上："
        dayTotalAmountTitleLabel.textColor = UIColor.black
        self.addSubview(dayTotalAmountTitleLabel)
        
        dayTotalAmountLabel.text = "0円"
        dayTotalAmountLabel.textColor = UIColor.black
        self.addSubview(dayTotalAmountLabel)
 
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        dayTotalAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dayTotalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            prevButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            dayLabel.font = UIFont.systemFont(ofSize: 16)
            nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            dayTotalAmountTitleLabel.font = UIFont.systemFont(ofSize: 16)
            dayTotalAmountLabel.font = UIFont.systemFont(ofSize: 16)
            
            NSLayoutConstraint.activate([
                prevButton.topAnchor.constraint(equalTo: dayLabel.topAnchor),
                prevButton.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor),
                prevButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64),
                dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                nextButton.topAnchor.constraint(equalTo: dayLabel.topAnchor),
                nextButton.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor),
                nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -64),
                tableView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 8),
                tableView.bottomAnchor.constraint(equalTo: dayTotalAmountTitleLabel.topAnchor, constant: -8),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                dayTotalAmountTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
                dayTotalAmountLabel.leftAnchor.constraint(equalTo: dayTotalAmountTitleLabel.rightAnchor, constant: 10),
                dayTotalAmountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                dayTotalAmountLabel.bottomAnchor.constraint(equalTo: dayTotalAmountTitleLabel.bottomAnchor)
            ])
        } else { // 通常の画面の場合
            prevButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            dayLabel.font = UIFont.systemFont(ofSize: 32)
            nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            dayTotalAmountTitleLabel.font = UIFont.systemFont(ofSize: 32)
            dayTotalAmountLabel.font = UIFont.systemFont(ofSize: 32)
            
            NSLayoutConstraint.activate([
                prevButton.topAnchor.constraint(equalTo: dayLabel.topAnchor),
                prevButton.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor),
                prevButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64),
                dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
                dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                nextButton.topAnchor.constraint(equalTo: dayLabel.topAnchor),
                nextButton.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor),
                nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -64),
                tableView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 32),
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
    
    @objc func tapPrevButton() {
        // 現在のdayLabelの日付を取得
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        guard let currentDate = formatter.date(from: dayLabel.text ?? "") else {
            return // 日付が不正な場合は処理を終了
        }
        
        // 1日減算
        let prevDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)
        
        // 減算した日付をdayLabelに反映
        if let prevDate = prevDate {
            dayLabel.text = formatter.string(from: prevDate)
            nextButton.isEnabled = true
            nextButton.setTitleColor(UIColor.black, for: .normal)
            
            let formatter_data = DateFormatter()
            formatter_data.dateFormat = "yyyy-MM-dd"
            
            // Delegateを通じて変更を通知
            delegate?.changeDay(day: formatter_data.string(from: prevDate))
        }
    }
    
    @objc func tapNextButton() {
        // 現在のdayLabelの日付を取得
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        guard let currentDate = formatter.date(from: dayLabel.text ?? "") else {
            return // 日付が不正な場合は処理を終了
        }
        
        // 1日加算
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
        
        // 加算した日付をdayLabelに反映
        if let nextDate = nextDate {
            dayLabel.text = formatter.string(from: nextDate)
            if dayLabel.text == formatter.string(from: Date()) {
                nextButton.isEnabled = false
                nextButton.setTitleColor(UIColor.gray, for: .normal)
            }
            
            let formatter_data = DateFormatter()
            formatter_data.dateFormat = "yyyy-MM-dd"
            
            // Delegateを通じて変更を通知
            delegate?.changeDay(day: formatter_data.string(from: nextDate))
        }
    }
    
    @objc private func dayLabelTapped() {
        // ダミーのテキストフィールドをフォーカスしてUIDatePickerを表示
        self.subviews.compactMap { $0 as? UITextField }.first?.becomeFirstResponder()
    }
    
    @objc private func doneDatePicker() {
        // 選択された日付をdayLabelに反映
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        dayLabel.text = formatter.string(from: datePicker.date)
        self.endEditing(true) // ドラムロールを閉じる
        
        // 当日かどうか判定してnextButtonの状態を切り替え
        let todayString = formatter.string(from: Date())
        if dayLabel.text == todayString {
            nextButton.isEnabled = false
            nextButton.setTitleColor(UIColor.gray, for: .normal)
        } else {
            nextButton.isEnabled = true
            nextButton.setTitleColor(UIColor.black, for: .normal)
        }

        let formatter_data = DateFormatter()
        formatter_data.dateFormat = "yyyy-MM-dd"
        
        delegate?.changeDay(day: formatter_data.string(from: datePicker.date))
    }

    @objc private func cancelDatePicker() {
        self.endEditing(true) // ドラムロールを閉じる
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
