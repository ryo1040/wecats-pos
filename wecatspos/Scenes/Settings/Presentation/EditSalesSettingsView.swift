//
//  EditSalesSettingsView.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import Foundation
import UIKit

protocol EditSalesSettingsViewDelegate: AnyObject  {
    func didTapEditSalesSettingsSubmitButton(salesMaster: SalesMasterModel)
    func didTapEditSalesSettingsCancelButton()
}

public class EditSalesSettingsView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // キーボード対応用のプロパティ
    var activeTextField: UITextField?
    var originalContentInset: UIEdgeInsets = .zero
    var originalScrollIndicatorInsets: UIEdgeInsets = .zero
    var originalContentOffset: CGPoint = .zero
    var keyboardIsVisible: Bool = false
    
    let errorMessageLabel = UILabel()
    let nameTitleLabel = UILabel()
    let nameTextField = UITextField()
    let priceTitleLabel = UILabel()
    let priceTextField = UITextField()
    let orderByTitleLabel = UILabel()
    let orderByTextField = UITextField()
    let memoTitleLabel = UILabel()
    let memoTextField = UITextField()
    let submitButton = UIButton()
    let cancelButton = UIButton()
    
    var salesMasterModel = SalesMasterModel(id: -1, branch: 1, name: "", price: 0, order: 0, memo: "")
    
    private var currentConstraints: [NSLayoutConstraint] = []
    var screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    // 画面向きを判定するプロパティ
    private var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
    var editId = -1
    
    weak var delegate: EditSalesSettingsViewDelegate?
    
    public init() {
        super.init(frame: .zero)
        
        setupViews()
        setupKeyboardObservers()
        setupOrientationObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeKeyboardObservers()
        removeOrientationObserver()
    }
    
    func setSalesSettings(salesMaster: SalesMasterModel) {
        self.salesMasterModel = salesMaster
        nameTextField.text = salesMaster.name
        priceTextField.text = "\(salesMaster.price)"
        orderByTextField.text = "\(salesMaster.order)"
        memoTextField.text = salesMaster.memo
    }
    
    func clear() {
        nameTextField.text = ""
        priceTextField.text = ""
        orderByTextField.text = ""
        memoTextField.text = ""
    }
    
    /// スクロール位置を初期化するメソッド
    public func resetScrollPosition() {
        scrollView.setContentOffset(CGPoint.zero, animated: false)
    }
}


private extension EditSalesSettingsView {
    func setupViews() {
        
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        
        // タップジェスチャーを追加してキーボードを閉じる
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
        
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = false
        scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        // コンテンツ用のコンテナビューを作成
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // ScrollView と ContentView の基本制約
        NSLayoutConstraint.activate([
            // ScrollViewの制約
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            
            // ContentViewの制約
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            // 画面高より小さくならないようにして、端末ごとに高さを自動調整する
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),
        ])
        
        // UI要素の設定（制約は後で動的に設定するため、ここでは基本設定のみ）
        setupUIElements()
        
        // 初回レイアウト設定
        updateLayoutForCurrentOrientation()
    }
    
    func setupUIElements() {
        // UI要素の基本設定のみ行う（制約は除く）
        
        func setupTextField(_ textField: UITextField, text: String = "") {
            textField.backgroundColor = UIColor.white
            textField.text = text
            textField.textColor = UIColor.black
            textField.keyboardType = .numberPad
            textField.returnKeyType = .next
            textField.textAlignment = .center
            textField.borderStyle = .roundedRect
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 1.0
            textField.delegate = self
            textField.translatesAutoresizingMaskIntoConstraints = false
        }
        
        func setupLabel(_ label: UILabel, text: String = "") {
            label.text = text
            label.textColor = UIColor.black
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        
        func setupButton(_ button: UIButton, text: String = "") {
            button.setTitle(text, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.white
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 10
            button.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupLabel(errorMessageLabel, text: " ")
        errorMessageLabel.textColor = UIColor.red
        contentView.addSubview(errorMessageLabel)
        
        setupLabel(nameTitleLabel, text: "名前：")
        contentView.addSubview(nameTitleLabel)
        
        setupTextField(nameTextField)
        nameTextField.keyboardType = .default
        nameTextField.autocorrectionType = .no
        nameTextField.spellCheckingType = .no
        contentView.addSubview(nameTextField)
        
        setupLabel(priceTitleLabel, text: "価格：")
        contentView.addSubview(priceTitleLabel)
        
        setupTextField(priceTextField)
        contentView.addSubview(priceTextField)
        
        setupLabel(orderByTitleLabel, text: "表示順：")
        contentView.addSubview(orderByTitleLabel)
        
        setupTextField(orderByTextField)
        contentView.addSubview(orderByTextField)
        
        setupLabel(memoTitleLabel, text: "メモ：")
        contentView.addSubview(memoTitleLabel)
        
        setupTextField(memoTextField)
        memoTextField.keyboardType = .default
        memoTextField.autocorrectionType = .no
        memoTextField.spellCheckingType = .no
        contentView.addSubview(memoTextField)
        
        setupButton(submitButton, text: "登録")
        submitButton.addTarget(self, action: #selector(self.tapSubmitButton), for: .touchUpInside)
        contentView.addSubview(submitButton)
        
        setupButton(cancelButton, text: "キャンセル")
        cancelButton.addTarget(self, action: #selector(self.tapCancelButton), for: .touchUpInside)
        contentView.addSubview(cancelButton)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        orderByTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        orderByTextField.translatesAutoresizingMaskIntoConstraints = false
        memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        memoTextField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // キーボードを閉じるメソッド
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    // 登録ボタンタップ時のイベント
    @objc func tapSubmitButton() {
        // 入力チェック
        if nameTextField.text?.isEmpty ?? true {
            errorMessageLabel.text = "名前を入力してください。"
            return
        }
        if priceTextField.text?.isEmpty ?? true {
            errorMessageLabel.text = "価格を入力してください。"
            return
        }
        if orderByTextField.text?.isEmpty ?? true {
            errorMessageLabel.text = "表示順を入力してください。"
            return
        }
        
        delegate?.didTapEditSalesSettingsSubmitButton(salesMaster: SalesMasterModel(id: salesMasterModel.id, branch: salesMasterModel.branch + 1, name: nameTextField.text ?? "", price: Int(priceTextField.text ?? "") ?? 0, order: Int(orderByTextField.text ?? "") ?? 0, memo: memoTextField.text ?? ""))
    }
    
    // キャンセルボタンタップ時のイベント
    @objc func tapCancelButton() {
        nameTextField.text = ""
        priceTextField.text = ""
        orderByTextField.text = ""
        memoTextField.text = ""
        delegate?.didTapEditSalesSettingsCancelButton()
    }
    
    func commaSeparateThreeDigits(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    // MARK: - Keyboard Handling
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let activeTextField = activeTextField else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        // 初回キーボード表示時のみオリジナル設定を保存
        if !keyboardIsVisible {
            originalContentInset = scrollView.contentInset
            originalScrollIndicatorInsets = scrollView.scrollIndicatorInsets
            originalContentOffset = scrollView.contentOffset
            keyboardIsVisible = true
        }
        
        // キーボードの高さ分だけinsetを調整
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets.bottom = keyboardHeight
        
        // アクティブなテキストフィールドがキーボードに隠れないようにスクロール
        let textFieldFrame = scrollView.convert(activeTextField.frame, from: activeTextField.superview)
        let visibleHeight = scrollView.frame.height - keyboardHeight
        
        if textFieldFrame.maxY > visibleHeight {
            let targetOffset = textFieldFrame.maxY - visibleHeight + 20 // 20ptのマージンを追加
            let newContentOffsetY = originalContentOffset.y + targetOffset
            scrollView.setContentOffset(CGPoint(x: 0, y: newContentOffsetY), animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // キーボードが非表示になる際に元の設定に戻す
        keyboardIsVisible = false
        scrollView.contentInset = originalContentInset
        scrollView.scrollIndicatorInsets = originalScrollIndicatorInsets
        scrollView.setContentOffset(originalContentOffset, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension EditSalesSettingsView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

// MARK: - Orientation Handling
private extension EditSalesSettingsView {
    
    func setupOrientationObserver() {
        // デバイスの向き変更通知を監視
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        
        // アプリがアクティブになった時の通知も監視（必要に応じて）
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    func removeOrientationObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func orientationDidChange() {
        // メインスレッドで実行
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // 画面幅を更新
            self.screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
            // レイアウトを更新
            self.updateLayoutForCurrentOrientation()
        }
    }
    
    @objc func applicationDidBecomeActive() {
        // アプリがアクティブになった時にもレイアウトをチェック
        DispatchQueue.main.async { [weak self] in
            self?.updateLayoutForCurrentOrientation()
        }
    }
}

// MARK: - Layout Update Methods
private extension EditSalesSettingsView {
    
    func updateLayoutForCurrentOrientation() {
        // 既存の制約を削除
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.removeAll()
        
        // 新しい制約を作成
        if LayoutBreakpoint.isCompact(sideLength: screenWidth) {
            setupSmallScreenConstraints()
        } else if isPortrait {
            setupPortraitConstraints()
        } else {
            setupLandscapeConstraints()
        }

        // フォントサイズとUI要素のサイズを更新
        updateUIElementsForOrientation()
        
        // ScrollViewのcontentSizeを再計算
        updateScrollViewContentSize()
        
        // アニメーション付きでレイアウトを更新
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func setupSmallScreenConstraints() {
        // 小さい画面用の制約
        if let contentView = scrollView.subviews.first {
            let constraints = [
                // エラーメッセージ
                errorMessageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                errorMessageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32),

                // 名前
                nameTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 36),
                nameTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32),
                nameTitleLabel.widthAnchor.constraint(equalToConstant: 100),
                nameTextField.centerYAnchor.constraint(equalTo: nameTitleLabel.centerYAnchor),
                nameTextField.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 16),
                nameTextField.widthAnchor.constraint(equalToConstant: 200),
                
                // 価格
                priceTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 36),
                priceTitleLabel.leftAnchor.constraint(equalTo: nameTitleLabel.leftAnchor),
                priceTitleLabel.widthAnchor.constraint(equalTo: nameTitleLabel.widthAnchor),
                priceTextField.centerYAnchor.constraint(equalTo: priceTitleLabel.centerYAnchor),
                priceTextField.leftAnchor.constraint(equalTo: priceTitleLabel.rightAnchor, constant: 16),
                priceTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                
                // 表示順
                orderByTitleLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 36),
                orderByTitleLabel.leftAnchor.constraint(equalTo: nameTitleLabel.leftAnchor),
                orderByTitleLabel.widthAnchor.constraint(equalTo: nameTitleLabel.widthAnchor),
                orderByTextField.centerYAnchor.constraint(equalTo: orderByTitleLabel.centerYAnchor),
                orderByTextField.leftAnchor.constraint(equalTo: orderByTitleLabel.rightAnchor, constant: 16),
                orderByTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                
                // メモ
                memoTitleLabel.topAnchor.constraint(equalTo: orderByTitleLabel.bottomAnchor, constant: 36),
                memoTitleLabel.leftAnchor.constraint(equalTo: nameTitleLabel.leftAnchor),
                memoTitleLabel.widthAnchor.constraint(equalTo: nameTitleLabel.widthAnchor),
                memoTextField.centerYAnchor.constraint(equalTo: memoTitleLabel.centerYAnchor),
                memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 16),
                memoTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                
                // 登録ボタン
                submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                submitButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
                submitButton.heightAnchor.constraint(equalToConstant: 36),
                submitButton.widthAnchor.constraint(equalToConstant: 100),
                // キャンセルボタン
                cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
                cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -16),
                cancelButton.heightAnchor.constraint(equalToConstant: 36),
                cancelButton.widthAnchor.constraint(equalToConstant: 100)
            ]
            
            currentConstraints.append(contentsOf: constraints)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func setupPortraitConstraints() {
        // 縦向き用の制約
        if let contentView = scrollView.subviews.first {
            let constraints = [
                // エラーメッセージ
                errorMessageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
                errorMessageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 64),

                // 名前
                nameTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 32),
                nameTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 64),
                nameTitleLabel.widthAnchor.constraint(equalToConstant: 200),
                nameTextField.centerYAnchor.constraint(equalTo: nameTitleLabel.centerYAnchor),
                nameTextField.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 32),
                nameTextField.widthAnchor.constraint(equalToConstant: 400),
                
                // 価格
                priceTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 48),
                priceTitleLabel.leftAnchor.constraint(equalTo: nameTitleLabel.leftAnchor),
                priceTitleLabel.widthAnchor.constraint(equalTo: nameTitleLabel.widthAnchor),
                priceTextField.centerYAnchor.constraint(equalTo: priceTitleLabel.centerYAnchor),
                priceTextField.leftAnchor.constraint(equalTo: priceTitleLabel.rightAnchor, constant: 32),
                priceTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                
                // 表示順
                orderByTitleLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 48),
                orderByTitleLabel.leftAnchor.constraint(equalTo: nameTitleLabel.leftAnchor),
                orderByTitleLabel.widthAnchor.constraint(equalTo: nameTitleLabel.widthAnchor),
                orderByTextField.centerYAnchor.constraint(equalTo: orderByTitleLabel.centerYAnchor),
                orderByTextField.leftAnchor.constraint(equalTo: orderByTitleLabel.rightAnchor, constant: 32),
                orderByTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                
                // メモ
                memoTitleLabel.topAnchor.constraint(equalTo: orderByTitleLabel.bottomAnchor, constant: 48),
                memoTitleLabel.leftAnchor.constraint(equalTo: nameTitleLabel.leftAnchor),
                memoTitleLabel.widthAnchor.constraint(equalTo: nameTitleLabel.widthAnchor),
                memoTextField.centerYAnchor.constraint(equalTo: memoTitleLabel.centerYAnchor),
                memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 32),
                memoTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                
                // 登録ボタン
                submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
                submitButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32),
                submitButton.heightAnchor.constraint(equalToConstant: 48),
                submitButton.widthAnchor.constraint(equalToConstant: 160),
                // キャンセルボタン
                cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
                cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -32),
                cancelButton.heightAnchor.constraint(equalToConstant: 48),
                cancelButton.widthAnchor.constraint(equalToConstant: 160)
            ]
            
            currentConstraints.append(contentsOf: constraints)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func setupLandscapeConstraints() {
        // 横向き用の制約
        if let contentView = scrollView.subviews.first {
            let constraints = [
                // エラーメッセージ
                errorMessageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
                errorMessageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 64),

                // 名前
                nameTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 32),
                nameTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 64),
                nameTitleLabel.widthAnchor.constraint(equalToConstant: 200),
                nameTextField.centerYAnchor.constraint(equalTo: nameTitleLabel.centerYAnchor),
                nameTextField.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 32),
                nameTextField.widthAnchor.constraint(equalToConstant: 400),
                
                // 価格
                priceTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 48),
                priceTitleLabel.leftAnchor.constraint(equalTo: nameTitleLabel.leftAnchor),
                priceTitleLabel.widthAnchor.constraint(equalTo: nameTitleLabel.widthAnchor),
                priceTextField.centerYAnchor.constraint(equalTo: priceTitleLabel.centerYAnchor),
                priceTextField.leftAnchor.constraint(equalTo: priceTitleLabel.rightAnchor, constant: 32),
                priceTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                
                // 表示順
                orderByTitleLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 48),
                orderByTitleLabel.leftAnchor.constraint(equalTo: nameTitleLabel.leftAnchor),
                orderByTitleLabel.widthAnchor.constraint(equalTo: nameTitleLabel.widthAnchor),
                orderByTextField.centerYAnchor.constraint(equalTo: orderByTitleLabel.centerYAnchor),
                orderByTextField.leftAnchor.constraint(equalTo: orderByTitleLabel.rightAnchor, constant: 32),
                orderByTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                
                // メモ
                memoTitleLabel.topAnchor.constraint(equalTo: orderByTitleLabel.bottomAnchor, constant: 48),
                memoTitleLabel.leftAnchor.constraint(equalTo: nameTitleLabel.leftAnchor),
                memoTitleLabel.widthAnchor.constraint(equalTo: nameTitleLabel.widthAnchor),
                memoTextField.centerYAnchor.constraint(equalTo: memoTitleLabel.centerYAnchor),
                memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 32),
                memoTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                
                // 登録ボタン
                submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
                submitButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32),
                submitButton.heightAnchor.constraint(equalToConstant: 48),
                submitButton.widthAnchor.constraint(equalToConstant: 160),
                // キャンセルボタン
                cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
                cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -32),
                cancelButton.heightAnchor.constraint(equalToConstant: 48),
                cancelButton.widthAnchor.constraint(equalToConstant: 160)
            ]
            
            currentConstraints.append(contentsOf: constraints)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func updateUIElementsForOrientation() {
        // フォントサイズの更新
        let fontSize: CGFloat = LayoutBreakpoint.isCompact(sideLength: screenWidth) ? 12 : 32
        let buttonFontSize: CGFloat = LayoutBreakpoint.isCompact(sideLength: screenWidth) ? 12 : 24
        
        // 全てのラベルのフォントサイズを更新
        [errorMessageLabel, nameTitleLabel, priceTitleLabel, orderByTitleLabel, memoTitleLabel
        ].forEach { label in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        // 全てのテキストフィールドのフォントサイズを更新
        [nameTextField, priceTextField, orderByTextField, memoTextField
        ].forEach { textField in
            textField.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        // ボタンのフォントサイズを更新
        [submitButton, cancelButton].forEach { button in
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        }
    }
    
    func updateScrollViewContentSize() {
        // ScrollViewのcontentSizeを再計算
        DispatchQueue.main.async {
            self.scrollView.layoutIfNeeded()
            
            if let contentView = self.scrollView.subviews.first {
                let contentHeight = contentView.frame.height
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: contentHeight)
                print("Updated contentSize for orientation: \(self.scrollView.contentSize)")
            }
        }
    }
}
