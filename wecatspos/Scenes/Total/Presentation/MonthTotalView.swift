//
//  MonthTotalView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/10.
//

import Foundation
import UIKit

protocol MonthTotalDelegate: AnyObject  {
    func changeMonth(month: String)
}

public class MonthTotalView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let prevButton = UIButton()
    let monthLabel = UILabel()
    let pickerBackgroundView = UIView()
    private let monthYearPicker = UIPickerView()
    private var years: [Int] = []
    private var months: [Int] = Array(1...12)
    let nextButton = UIButton()
    
    let tableView = UITableView()
    
    let monthTotalAmountTitleLabel = UILabel()
    let monthTotalAmountLabel = UILabel()
    
    var screenWidth: CGFloat = -1
    
    var totalAmountList: [TotalAmountListModel] = []
    
    weak var delegate: MonthTotalDelegate?
    
    public init() {
        super.init(frame: .zero)
        
        screenWidth = UIScreen.main.bounds.width
        
        setupViews()
        
        // タップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelDatePicker))
        tapGesture.cancelsTouchesInView = false // 他のビューのタップイベントも処理する
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calcMonthTotalFee() {
        var calcSales = 0
        for leave in totalAmountList {
            calcSales += leave.totalAmount
        }
        monthTotalAmountLabel.text = "¥" + self.commaSeparateThreeDigits(calcSales)
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalAmountList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 古いサブビューを削除
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        let totalAmount = totalAmountList[indexPath.row]
        let dateLabel = UILabel()
        dateLabel.text = totalAmount.date
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor.black
        
        let countLabel = UILabel()
        countLabel.text = String(totalAmount.totalVisitors) + "名"
        countLabel.textAlignment = .center
        countLabel.textColor = UIColor.black
        
        let totalAmountLabel = UILabel()
        totalAmountLabel.text = "¥" + self.commaSeparateThreeDigits(totalAmount.totalAmount)
        totalAmountLabel.textAlignment = .center
        totalAmountLabel.textColor = UIColor.black
        
        cell.contentView.addSubview(dateLabel)
        cell.contentView.addSubview(countLabel)
        cell.contentView.addSubview(totalAmountLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            dateLabel.font = UIFont.systemFont(ofSize: 12)
            countLabel.font = UIFont.systemFont(ofSize: 12)
            totalAmountLabel.font = UIFont.systemFont(ofSize: 12)
        } else { // 通常の画面の場合
            dateLabel.font = UIFont.systemFont(ofSize: 24)
            countLabel.font = UIFont.systemFont(ofSize: 24)
            totalAmountLabel.font = UIFont.systemFont(ofSize: 24)
        }
        
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 10),
            dateLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.33),
            countLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor),
            countLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            countLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.33),
            totalAmountLabel.leftAnchor.constraint(equalTo: countLabel.rightAnchor),
            totalAmountLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            totalAmountLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.3)
        ])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        headerView.backgroundColor = UIColor.white
        
        let dateLabel = UILabel()
        dateLabel.text = "日付"
        dateLabel.textColor = .black
        dateLabel.textAlignment = .center
        
        let countLabel = UILabel()
        countLabel.text = "来店人数"
        countLabel.textColor = .black
        countLabel.textAlignment = .center

        let totalAmountLabel = UILabel()
        totalAmountLabel.text = "売上金額"
        totalAmountLabel.textColor = .black
        totalAmountLabel.textAlignment = .center
        
        headerView.addSubview(dateLabel)
        headerView.addSubview(countLabel)
        headerView.addSubview(totalAmountLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            dateLabel.font = UIFont.boldSystemFont(ofSize: 12)
            countLabel.font = UIFont.boldSystemFont(ofSize: 12)
            totalAmountLabel.font = UIFont.boldSystemFont(ofSize: 12)
        } else { // 通常の画面の場合
            dateLabel.font = UIFont.boldSystemFont(ofSize: 24)
            countLabel.font = UIFont.boldSystemFont(ofSize: 24)
            totalAmountLabel.font = UIFont.boldSystemFont(ofSize: 24)
        }
        
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10),
            dateLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.33),
            countLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor),
            countLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            countLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.33),
            totalAmountLabel.leftAnchor.constraint(equalTo: countLabel.rightAnchor),
            totalAmountLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            totalAmountLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.3)
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
    }
}

private extension MonthTotalView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        
        prevButton.setTitle("<<前月", for: .normal)
        prevButton.setTitleColor(UIColor.black, for: .normal)
        prevButton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        prevButton.layer.borderColor = UIColor.black.cgColor
        prevButton.layer.borderWidth = 0
        prevButton.layer.cornerRadius = 10
        prevButton.addTarget(self, action: #selector(self.tapPrevButton), for: .touchUpInside)
        self.addSubview(prevButton)
        
        // 当日の日付をフォーマットしてdayLabelにセット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        let today = Date()
        monthLabel.text = formatter.string(from: today)
        monthLabel.textColor = UIColor.black
        monthLabel.isUserInteractionEnabled = true
        self.addSubview(monthLabel)
        
        // dayLabelにタップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(monthLabelTapped))
        monthLabel.addGestureRecognizer(tapGesture)
        
        nextButton.setTitle("翌月>>", for: .normal)
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
        
        pickerBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 半透明のグレー
        pickerBackgroundView.isHidden = true
        pickerBackgroundView.isUserInteractionEnabled = true
        self.addSubview(pickerBackgroundView)
        
        // 年の範囲を設定
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array(2024...currentYear) // 過去50年から未来50年

        // UIPickerViewの設定
        monthYearPicker.delegate = self
        monthYearPicker.dataSource = self

        // ツールバーを追加
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelDatePicker))
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneMonthYearPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)

        // ダミーのテキストフィールドを使用してUIPickerViewを関連付け
        let dummyTextField = UITextField(frame: .zero)
        dummyTextField.inputView = monthYearPicker
        dummyTextField.inputAccessoryView = toolbar
        self.addSubview(dummyTextField)
        dummyTextField.isHidden = true
        
        monthTotalAmountTitleLabel.text = "売上："
        monthTotalAmountTitleLabel.textColor = UIColor.black
        self.addSubview(monthTotalAmountTitleLabel)
        
        monthTotalAmountLabel.text = "0円"
        monthTotalAmountLabel.textColor = UIColor.black
        self.addSubview(monthTotalAmountLabel)
        
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        pickerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        monthTotalAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        monthTotalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            prevButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            monthLabel.font = UIFont.systemFont(ofSize: 16)
            nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            monthTotalAmountTitleLabel.font = UIFont.systemFont(ofSize: 16)
            monthTotalAmountLabel.font = UIFont.systemFont(ofSize: 16)
            
            NSLayoutConstraint.activate([
                prevButton.topAnchor.constraint(equalTo: monthLabel.topAnchor),
                prevButton.bottomAnchor.constraint(equalTo: monthLabel.bottomAnchor),
                prevButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64),
                monthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                monthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                nextButton.topAnchor.constraint(equalTo: monthLabel.topAnchor),
                nextButton.bottomAnchor.constraint(equalTo: monthLabel.bottomAnchor),
                nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -64),
                tableView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 8),
                tableView.bottomAnchor.constraint(equalTo: monthTotalAmountTitleLabel.topAnchor, constant: -8),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                monthTotalAmountTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
                monthTotalAmountLabel.leftAnchor.constraint(equalTo: monthTotalAmountTitleLabel.rightAnchor, constant: 10),
                monthTotalAmountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                monthTotalAmountLabel.bottomAnchor.constraint(equalTo: monthTotalAmountTitleLabel.bottomAnchor),
                pickerBackgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -80),
                pickerBackgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                pickerBackgroundView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                pickerBackgroundView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor)
            ])
        } else { // 通常の画面の場合
            prevButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            monthLabel.font = UIFont.systemFont(ofSize: 32)
            nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            monthTotalAmountTitleLabel.font = UIFont.systemFont(ofSize: 32)
            monthTotalAmountLabel.font = UIFont.systemFont(ofSize: 32)
            
            NSLayoutConstraint.activate([
                prevButton.topAnchor.constraint(equalTo: monthLabel.topAnchor),
                prevButton.bottomAnchor.constraint(equalTo: monthLabel.bottomAnchor),
                prevButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64),
                monthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
                monthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                nextButton.topAnchor.constraint(equalTo: monthLabel.topAnchor),
                nextButton.bottomAnchor.constraint(equalTo: monthLabel.bottomAnchor),
                nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -64),
                tableView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 32),
                tableView.bottomAnchor.constraint(equalTo: monthTotalAmountTitleLabel.topAnchor, constant: -32),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                monthTotalAmountTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
                monthTotalAmountLabel.leftAnchor.constraint(equalTo: monthTotalAmountTitleLabel.rightAnchor, constant: 10),
                monthTotalAmountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                monthTotalAmountLabel.bottomAnchor.constraint(equalTo: monthTotalAmountTitleLabel.bottomAnchor),
                pickerBackgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -80),
                pickerBackgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                pickerBackgroundView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                pickerBackgroundView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor)
            ])
        }
        self.bringSubviewToFront(pickerBackgroundView)
    }
    
    @objc func tapPrevButton() {
        // 現在のdayLabelの日付を取得
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        
        guard let currentDate = formatter.date(from: monthLabel.text ?? "") else {
            return // 日付が不正な場合は処理を終了
        }
        
        // 1月減算
        let prevDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        
        // 減算した日付をmonthLabelに反映
        if let prevDate = prevDate {
            monthLabel.text = formatter.string(from: prevDate)
            nextButton.isEnabled = true
            nextButton.setTitleColor(UIColor.black, for: .normal)
            
            let formatter_data = DateFormatter()
            formatter_data.dateFormat = "yyyy-MM"
            
            // Delegateを通じて変更を通知
            delegate?.changeMonth(month: formatter_data.string(from: prevDate))
        }
    }

    @objc func tapNextButton() {
        // 現在のdayLabelの日付を取得
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        
        guard let currentDate = formatter.date(from: monthLabel.text ?? "") else {
            return // 日付が不正な場合は処理を終了
        }
        
        // 1月加算
        let nextDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        
        // 加算した日付をmonthLabelに反映
        if let nextDate = nextDate {
            monthLabel.text = formatter.string(from: nextDate)
            if monthLabel.text == formatter.string(from: Date()) {
                nextButton.isEnabled = false
                nextButton.setTitleColor(UIColor.gray, for: .normal)
            }
            
            let formatter_data = DateFormatter()
            formatter_data.dateFormat = "yyyy-MM"
            
            // Delegateを通じて変更を通知
            delegate?.changeMonth(month: formatter_data.string(from: nextDate))
        }
    }
    
    @objc private func monthLabelTapped() {
        // monthLabel.textから年と月を取得
        guard let text = monthLabel.text else { return }
        let components = text.split(separator: "/")
        guard components.count == 2,
              let year = Int(components[0]),
              let month = Int(components[1]) else { return }

        // 年と月に対応する行を選択
        if let yearIndex = years.firstIndex(of: year),
           let monthIndex = months.firstIndex(of: month) {
            monthYearPicker.selectRow(yearIndex, inComponent: 0, animated: false)
            monthYearPicker.selectRow(monthIndex, inComponent: 1, animated: false)
            self.pickerView(monthYearPicker, didSelectRow: yearIndex, inComponent: 0)
        }

        pickerBackgroundView.isHidden = false
        // ダミーのテキストフィールドをフォーカスしてUIPickerViewを表示
        self.subviews.compactMap { $0 as? UITextField }.first?.becomeFirstResponder()
    }
    
    @objc private func doneMonthYearPicker() {
        let selectedYear = years[monthYearPicker.selectedRow(inComponent: 0)]
        let selectedMonth = months[monthYearPicker.selectedRow(inComponent: 1)]
        
        // 今日の年月を取得
        let now = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)

        // 未来（当月より後）なら何もしない
        if selectedYear > currentYear || (selectedYear == currentYear && selectedMonth > currentMonth) {
            // ピッカーを閉じるだけ
            self.endEditing(true)
            pickerBackgroundView.isHidden = true
            return
        }
        
        monthLabel.text = String(format: "%04d/%02d", selectedYear, selectedMonth)
        self.endEditing(true) // ピッカーを閉じる
        pickerBackgroundView.isHidden = true

        // Delegateを通じて変更を通知
        delegate?.changeMonth(month: monthLabel.text!.replacingOccurrences(of: "/", with: "-"))
    }
    
    @objc private func cancelDatePicker() {
        self.endEditing(true) // ピッカーを閉じる
        pickerBackgroundView.isHidden = true
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

extension MonthTotalView: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // 年と月の2列
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count // 年の数
        } else {
            // 選択中の年を取得
            let selectedYearIndex = pickerView.selectedRow(inComponent: 0)
            let selectedYear = years[selectedYearIndex]
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            if selectedYear == currentYear {
                return currentMonth // 当年なら当月まで
            } else {
                return 12 // それ以外は1〜12月
            }
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(years[row])年"
        } else {
            // 年の選択に応じて月の範囲を調整
            let selectedYearIndex = pickerView.selectedRow(inComponent: 0)
            let selectedYear = years[selectedYearIndex]
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            if selectedYear == currentYear {
                return "\(row + 1)月" // 1〜当月
            } else {
                return "\(row + 1)月" // 1〜12月
            }
        }
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            // 年を変更したら月の列をリロード
            pickerView.reloadComponent(1)
            // 現在の月の選択が範囲外なら当月に合わせる
            let selectedYear = years[row]
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            let selectedMonthIndex = pickerView.selectedRow(inComponent: 1)
            if selectedYear == currentYear && selectedMonthIndex >= currentMonth {
                pickerView.selectRow(currentMonth - 1, inComponent: 1, animated: true)
            }
        }
    }
    
    // 列の幅を指定
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let totalWidth = pickerView.bounds.width
        let columnWidth = totalWidth * 0.2 // 各列の幅を全体の40%に設定
        return columnWidth
    }
    
    // 列の中央寄せ
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44.0 // 行の高さを指定（デフォルトは44）
    }
}
