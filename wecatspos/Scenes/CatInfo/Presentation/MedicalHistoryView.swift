//
//  MedicalHistoryView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/29.
//

import Foundation
import UIKit

protocol MedicalHistoryDelegate: AnyObject  {
    func tapAddButton()
    func didSelectMedicalHistory(id: Int, date: String, overview: String, detail: String?)
}

public class MedicalHistoryView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let addButton = UIButton()
    
    var screenWidth: CGFloat = -1
    
    weak var delegate: MedicalHistoryDelegate?
    
    public init() {
        super.init(frame: .zero)
        
        screenWidth = UIScreen.main.bounds.width
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 医療履歴データ
    var medicalHistory: [MedicalHistoryModel] = []
    
        // MARK: - UITableViewDataSource
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return medicalHistory.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            // 既存のサブビューを削除
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            cell.backgroundColor = .white
            cell.contentView.backgroundColor = .white
            
            let history = medicalHistory[indexPath.row]
            let dateLabel = UILabel()
            dateLabel.text = history.date
            dateLabel.textAlignment = .center
            dateLabel.textColor = UIColor.black
            
            let summaryLabel = UILabel()
            summaryLabel.text = history.reason
            summaryLabel.textAlignment = .center
            summaryLabel.textColor = UIColor.black
            
            cell.contentView.addSubview(dateLabel)
            cell.contentView.addSubview(summaryLabel)
            
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            summaryLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // レスポンシブルデザイン対応
            if screenWidth < 668 { // 小さい画面の場合
                dateLabel.font = UIFont.systemFont(ofSize: 12)
                summaryLabel.font = UIFont.systemFont(ofSize: 12)
            } else { // 通常の画面の場合
                dateLabel.font = UIFont.systemFont(ofSize: 24)
                summaryLabel.font = UIFont.systemFont(ofSize: 24)
            }
            
            NSLayoutConstraint.activate([
                dateLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 16),
                dateLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                dateLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.2),
                
                summaryLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 16),
                summaryLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -10),
                summaryLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
            
            return cell
        }
        
        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.white
            
            let dateLabel = UILabel()
            dateLabel.text = "日付"
            dateLabel.textColor = .black
            dateLabel.textAlignment = .center
            
            let summaryLabel = UILabel()
            summaryLabel.text = "概要"
            summaryLabel.textColor = .black
            summaryLabel.textAlignment = .center
            
            headerView.addSubview(dateLabel)
            headerView.addSubview(summaryLabel)
            
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            summaryLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // レスポンシブルデザイン対応
            if screenWidth < 668 { // 小さい画面の場合
                dateLabel.font = UIFont.boldSystemFont(ofSize: 12)
                summaryLabel.font = UIFont.boldSystemFont(ofSize: 12)
            } else { // 通常の画面の場合
                dateLabel.font = UIFont.boldSystemFont(ofSize: 24)
                summaryLabel.font = UIFont.boldSystemFont(ofSize: 24)
            }
            
            NSLayoutConstraint.activate([
                dateLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                dateLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                dateLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.2),
                
                summaryLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
                summaryLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
                summaryLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
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
        let selectedHistory = medicalHistory[indexPath.row]
        let id = selectedHistory.id
        let date = selectedHistory.date
        let overview = selectedHistory.reason
        let detail = selectedHistory.treatment

        delegate?.didSelectMedicalHistory(id: id, date: date, overview: overview, detail: detail)
    }

    func setMedicalHistory(medicalHistory: [MedicalHistoryModel]) {
        self.medicalHistory.removeAll() // 既存のデータをクリア
        self.medicalHistory.append(contentsOf: medicalHistory) // 新しいデータを追加
        tableView.reloadData()
        
        if !self.medicalHistory.isEmpty {
            let lastIndex = IndexPath(row: self.medicalHistory.count - 1, section: 0)
            tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
        }
    }
    
    func changeAddButtonEnabled(selectCatId: Int) {
        if selectCatId != 0 {
            addButton.isEnabled = true
            addButton.backgroundColor = UIColor.white
        } else {
            addButton.isEnabled = false
            addButton.backgroundColor = UIColor.lightGray
        }
    }
}

private extension MedicalHistoryView {
    
    func setupView() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        addButton.setTitle("追加", for: .normal)
        addButton.setTitleColor(UIColor.black, for: .normal)
        addButton.backgroundColor = UIColor.white
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = 1.0
        addButton.layer.cornerRadius = 10
        addButton.addTarget(self, action: #selector(self.tapAddButton), for: .touchUpInside)
        
        self.addSubview(tableView)
        self.addSubview(addButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
                tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -160),
                addButton.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
                addButton.leftAnchor.constraint(equalTo: tableView.rightAnchor, constant: 32),
                addButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                addButton.heightAnchor.constraint(equalToConstant: 24)
            ])
        } else { // 通常の画面の場合
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
                tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
                tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -240),
                addButton.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
                addButton.leftAnchor.constraint(equalTo: tableView.rightAnchor, constant: 32),
                addButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
                addButton.heightAnchor.constraint(equalToConstant: 48)
            ])
        }
    }
    
    @objc func tapAddButton() {
        delegate?.tapAddButton()
    }
}
