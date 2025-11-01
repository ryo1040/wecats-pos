//
//  CareViewController.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

import Foundation
import UIKit
import RxSwift

protocol CareViewControllerProtocol {
    
}

final class CareViewController: UIViewController, CareViewControllerProtocol {
    
    var presenter: CarePresenterProtocol!
    
    // TitleView
    let titleView = TitleView()
    
    // main
    let mainLabel = UILabel()
    let earCleanButton = UIButton()
    let brushingButton = UIButton()
    let pillRemoveButton = UIButton()
    let nailClippersButton = UIButton()
    let teethBrushingButton = UIButton()
    var stackView = UIStackView()
    
    let tableView = UITableView()
    var careInfoList: [CareInfoModel] = []
    var selectedCareType = 1
    
    var activityIndicator: UIActivityIndicatorView!
    var overlayView: UIView!
    
    let screenWidth = UIScreen.main.bounds.width
    
    private let disposeBag = DisposeBag()
    
    public func inject(presenter: CarePresenterProtocol) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setSubscribe()
        
        setupActivityIndicator()

        startLoading()

        presenter.load(careType: selectedCareType)
    }
}

// MARK: - 外観の調整

private extension CareViewController {
    
    func setupViews() {
        
        func setupButton(_ button: UIButton, text: String = "") {
            button.setTitle(text, for: .normal)
            if screenWidth < 668 {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            }
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        }
        
        // TitleViewの追加
        titleView.delegate = self
        self.view.addSubview(titleView)
        
        mainLabel.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        mainLabel.isUserInteractionEnabled = true
        self.view.addSubview(mainLabel)
        
        setupButton(earCleanButton, text: "耳掃除")
        earCleanButton.backgroundColor = UIColor.lightGray
        earCleanButton.setTitleColor(UIColor.white, for: .normal)
        earCleanButton.addTarget(self, action: #selector(self.tapEarCleanButton(_:)), for: UIControl.Event.touchUpInside)
        setupButton(brushingButton, text: "ブラッシング")
        brushingButton.titleLabel?.numberOfLines = 0
        brushingButton.titleLabel?.textAlignment = .center
        brushingButton.addTarget(self, action: #selector(self.tapBrushingButton(_:)), for: UIControl.Event.touchUpInside)
        setupButton(pillRemoveButton, text: "毛玉取り")
        pillRemoveButton.addTarget(self, action: #selector(self.tapPillRemoveButton(_:)), for: UIControl.Event.touchUpInside)
        setupButton(nailClippersButton, text: "爪切り")
        nailClippersButton.addTarget(self, action: #selector(self.tapNailClippersButton(_:)), for: UIControl.Event.touchUpInside)
        setupButton(teethBrushingButton, text: "歯磨き")
        teethBrushingButton.addTarget(self, action: #selector(self.tapTeethBrushingButton(_:)), for: UIControl.Event.touchUpInside)

        stackView = UIStackView(arrangedSubviews: [self.earCleanButton, self.brushingButton, self.pillRemoveButton, self.nailClippersButton, self.teethBrushingButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        mainLabel.addSubview(stackView)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mainLabel.addSubview(tableView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                titleView.heightAnchor.constraint(equalToConstant: 50),
                mainLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                mainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                mainLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                mainLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                stackView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                stackView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                stackView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                stackView.heightAnchor.constraint(equalToConstant: 40),
                tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
                tableView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: -32),
                tableView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: -32),
            ])
        } else { // 通常の画面の場合
            
            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                titleView.heightAnchor.constraint(equalToConstant: 100),
                mainLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                mainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                mainLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                mainLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                stackView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                stackView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                stackView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                stackView.heightAnchor.constraint(equalToConstant: 80),
                tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
                tableView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: -32),
                tableView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor, constant: 32),
                tableView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: -32),
            ])
        }
    }
    
    func setSubscribe() {
        presenter.viewCareInfo
            .subscribe(onNext: { [unowned self] model in
                print("Received care info data: \(model)") // デバッグログ
                self.careInfoList = model
                self.tableView.reloadData()
                stopLoading()
            }).disposed(by: disposeBag)
    }
    
    func setupActivityIndicator() {
        // 半透明のビューを作成
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 半透明の黒
        overlayView.isHidden = true // 初期状態では非表示
        view.addSubview(overlayView)
        
        // アクティビティインジケーターを作成
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = overlayView.center
        activityIndicator.hidesWhenStopped = true // アニメーション停止時に非表示
        overlayView.addSubview(activityIndicator)
    }

    func startLoading() {
        overlayView.isHidden = false // 半透明ビューを表示
        activityIndicator.startAnimating() // クルクル開始
    }

    func stopLoading() {
        activityIndicator.stopAnimating() // クルクル終了
        overlayView.isHidden = true // 半透明ビューを非表示
    }
    
    @objc func tapEarCleanButton(_ sender: UIButton) {
        startLoading()
        selectedCareType = 1
        presenter.load(careType: selectedCareType)
        updateButtonSelection(selectedButton: earCleanButton)
    }
    
    @objc func tapBrushingButton(_ sender: UIButton) {
        startLoading()
        selectedCareType = 2
        startLoading()
        presenter.load(careType: selectedCareType)
        updateButtonSelection(selectedButton: brushingButton)
    }
    
    @objc func tapPillRemoveButton(_ sender: UIButton) {
        startLoading()
        selectedCareType = 3
        startLoading()
        presenter.load(careType: selectedCareType)
        updateButtonSelection(selectedButton: pillRemoveButton)
    }
    
    @objc func tapNailClippersButton(_ sender: UIButton) {
        startLoading()
        selectedCareType = 4
        startLoading()
        presenter.load(careType: selectedCareType)
        updateButtonSelection(selectedButton: nailClippersButton)
    }
    
    @objc func tapTeethBrushingButton(_ sender: UIButton) {
        startLoading()
        selectedCareType = 5
        startLoading()
        presenter.load(careType: selectedCareType)
        updateButtonSelection(selectedButton: teethBrushingButton)
    }
    
    private func updateButtonSelection(selectedButton: UIButton) {
        let buttons = [earCleanButton, brushingButton, pillRemoveButton, nailClippersButton, teethBrushingButton]
        
        for button in buttons {
            if button == selectedButton {
                button.backgroundColor = UIColor.lightGray
                button.setTitleColor(UIColor.white, for: .normal)
            } else {
                button.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
                button.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    
    func tapDeleteButton(selectedRow: CareInfoModel) {
        presenter.deleteCareInfo(selectedCareType: selectedCareType, selectedRow: selectedRow)
    }
    
    func tapRegisterButton(selectedRow: CareInfoModel) {
        // TODO: 前回お手入れ日＝当日の場合は更新しないようにする
        presenter.setCareInfo(selectedCareType: selectedCareType, selectedRow: selectedRow)
    }
}

extension CareViewController: TitleDelegate {
    func tapMenuButton() {
        presenter.didTapMenuButton()
    }
}

// MARK: - UITableViewDataSource
extension CareViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return careInfoList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        // 古いサブビューを削除
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        let care = careInfoList[indexPath.row]
        let nameLabel = UILabel()
        nameLabel.text = care.catName
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.black
        
        let dateLabel = UILabel()
        dateLabel.text = care.careDate
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor.black

        let memoLabel = UILabel()
        memoLabel.text = care.memo
        memoLabel.textAlignment = .center
        memoLabel.textColor = UIColor.black
        
        cell.contentView.addSubview(nameLabel)
        cell.contentView.addSubview(dateLabel)
        cell.contentView.addSubview(memoLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        memoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            nameLabel.font = UIFont.systemFont(ofSize: 12)
            dateLabel.font = UIFont.systemFont(ofSize: 12)
            memoLabel.font = UIFont.systemFont(ofSize: 12)
        } else { // 通常の画面の場合
            nameLabel.font = UIFont.systemFont(ofSize: 24)
            dateLabel.font = UIFont.systemFont(ofSize: 24)
            memoLabel.font = UIFont.systemFont(ofSize: 24)
        }

        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.3),
            dateLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.3),
            memoLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor),
            memoLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            memoLabel.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.4)
        ])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        headerView.backgroundColor = UIColor.white
        
        let catLabel = UILabel()
        catLabel.text = "名前"
        catLabel.textColor = .black
        catLabel.textAlignment = .center
        headerView.addSubview(catLabel)
        
        let dateLabel = UILabel()
        dateLabel.text = "前回お手入れ日"
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor.black
        headerView.addSubview(dateLabel)
        
        let memoLabel = UILabel()
        memoLabel.text = "メモ"
        memoLabel.textAlignment = .center
        memoLabel.textColor = UIColor.black
        headerView.addSubview(memoLabel)

        catLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        memoLabel.translatesAutoresizingMaskIntoConstraints = false

        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            catLabel.font = UIFont.boldSystemFont(ofSize: 12)
            dateLabel.font = UIFont.boldSystemFont(ofSize: 12)
            memoLabel.font = UIFont.boldSystemFont(ofSize: 12)
        } else { // 通常の画面の場合
            catLabel.font = UIFont.boldSystemFont(ofSize: 24)
            dateLabel.font = UIFont.boldSystemFont(ofSize: 24)
            memoLabel.font = UIFont.boldSystemFont(ofSize: 24)
        }

        NSLayoutConstraint.activate([
            catLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            catLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            catLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.3),
            dateLabel.leftAnchor.constraint(equalTo: catLabel.rightAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.3),
            memoLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor),
            memoLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            memoLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.4)
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
        // 行タップ時の処理は実装しない
    }
    
    // UITableViewの編集削除機能を有効にする
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
            
            startLoading()
            
            // 削除データ退避
            let deleteCareInfo = self.careInfoList[indexPath.row]
            
            // データソースから該当のアイテムを削除
//            self.careInfoList.remove(at: indexPath.row)
//            
//            // テーブルビューから行を削除（アニメーション付き）
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.tapDeleteButton(selectedRow: deleteCareInfo)
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        // 登録アクション
        let registerAction = UIContextualAction(style: .normal, title: "登録") { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            
            startLoading()
            
            let registerCareInfo = self.careInfoList[indexPath.row]
            
            self.tapRegisterButton(selectedRow: registerCareInfo)
            
            completionHandler(true)
        }
        registerAction.backgroundColor = .systemBlue
        
        // メモ編集アクション
        let memoAction = UIContextualAction(style: .normal, title: "メモ\n編集") { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            
            let careInfo = self.careInfoList[indexPath.row]
            self.showMemoEditDialog(for: careInfo, at: indexPath)
            
            completionHandler(true)
        }
        memoAction.backgroundColor = UIColor.systemOrange

        // スワイプアクション設定を作成（右から左にスワイプ時）
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, memoAction, registerAction])
        configuration.performsFirstActionWithFullSwipe = false // フルスワイプで自動実行を無効化
        
        return configuration
    }
}

// MARK: - メモ編集機能
private extension CareViewController {
    
    /// メモ編集ダイアログを表示
    func showMemoEditDialog(for careInfo: CareInfoModel, at indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "メモ編集",
            message: "\(careInfo.catName)のメモを編集してください",
            preferredStyle: .alert
        )
        
        // テキストフィールドを追加
        alertController.addTextField { textField in
            textField.text = careInfo.memo
            textField.placeholder = "メモを入力してください"
            textField.clearButtonMode = .whileEditing
            
            // レスポンシブルデザイン対応
            if self.screenWidth < 668 {
                textField.font = UIFont.systemFont(ofSize: 14)
            } else {
                textField.font = UIFont.systemFont(ofSize: 16)
            }
        }
        
        // 保存ボタン
        let saveAction = UIAlertAction(title: "保存", style: .default) { [weak self] _ in
            guard let self = self,
                  let textField = alertController.textFields?.first,
                  let newMemo = textField.text else { return }
            
            self.updateMemo(for: careInfo, newMemo: newMemo, at: indexPath)
        }
        
        // キャンセルボタン
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        // iPadでの表示対応
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alertController, animated: true)
    }
    
    /// メモを更新
    func updateMemo(for careInfo: CareInfoModel, newMemo: String, at indexPath: IndexPath) {
        startLoading()
        
        // メモを更新したCareInfoModelを作成
        let updatedCareInfo = CareInfoModel(
            catId: careInfo.catId,
            catName: careInfo.catName,
            careType: careInfo.careType,
            branch: careInfo.branch,
            careDate: careInfo.careDate,
            memo: newMemo
        )
        
        // プレゼンターにメモ更新を依頼
        presenter.editCareMemo(selectedCareType: careInfo.careType, selectedRow: updatedCareInfo)
    }
}
