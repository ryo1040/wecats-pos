//
//  ReservationNightView.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/11.
//

import Foundation
import UIKit

protocol ReservationNightViewDelegate: AnyObject  {
    func tapReservationNightSubmitButton(id: Int, branch: Int, date: String, name: String, tel: String, count: Int, price: Int, memo: String, visitorHistoryId: Int)
    func tapReservationNightCancelButton()
}

public class ReservationNightView: UIView {
    
    let scrollView = UIScrollView()
    let datePicker = UIDatePicker()
    
    let pickerBackgroundView = UIView()
    let errorMessageLabel = UILabel()
    let dateTitleLabel = UILabel()
    let dateTextField = UITextField()
    let nameTitleLabel = UILabel()
    let nameTextField = UITextField()
    let countTitleLabel = UILabel()
    let countTextField = UITextField()
    let telTitleLabel = UILabel()
    let telTextField = UITextField()
    let priceTitleLabel = UILabel()
    let priceTextField = UITextField()
    let memoTitleLabel = UILabel()
    let memoTextField = UITextField()
    let submitButton = UIButton()
    let cancelButton = UIButton()
    
    var selectedId: Int = -1
    var selectedBranch: Int = -1
    var selectedVisitorHistoryId: Int = -1
    
    var updateFlg: Bool = false
    
    // 制約管理用のプロパティを追加
    private var currentConstraints: [NSLayoutConstraint] = []
    
    // 画面向きを判定するプロパティ
    private var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
    
    // 動的に更新されるscreenWidthプロパティ
    private var dynamicScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    let screenWidth = UIScreen.main.bounds.width
    weak var delegate: ReservationNightViewDelegate?
    
    public init() {
        super.init(frame: .zero)
        
        setupViews()
        
        setupOrientationObserver()
        
        // キーボードイベントの監視
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // タップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 他のビューのタップイベントも処理する
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // NotificationCenterの監視を解除
        removeOrientationObserver()
        
        // キーボードイベントの監視を解除
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setReservationNightInfo(reservationNightViewModel: ReservationNightViewModel) {
        selectedId = reservationNightViewModel.id
        selectedBranch = reservationNightViewModel.branch
        if reservationNightViewModel.count > 0 {
            dateTextField.text = reservationNightViewModel.date
            nameTextField.text = reservationNightViewModel.name
            countTextField.text = String(reservationNightViewModel.count)
            telTextField.text = reservationNightViewModel.tel
            priceTextField.text = String(reservationNightViewModel.price)
            memoTextField.text = reservationNightViewModel.memo
        } else {
            dateTextField.text = ""
            nameTextField.text = ""
            countTextField.text = ""
            telTextField.text = ""
            priceTextField.text = ""
            memoTextField.text = ""
        }
        
        dateTextField.isEnabled = updateFlg
        nameTextField.isEnabled = updateFlg
        countTextField.isEnabled = updateFlg
        telTextField.isEnabled = updateFlg
        priceTextField.isEnabled = updateFlg
        memoTextField.isEnabled = updateFlg
        submitButton.isHidden = !updateFlg
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        // キーボードの高さを取得
        let keyboardHeight = keyboardFrame.height

        // スクロールビューのコンテンツインセットを調整
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset

        // 現在編集中のテキストフィールドを取得
        if let activeField = findActiveResponder() as? UITextField {
            // テキストフィールドのフレームをスクロールビューの座標系に変換
            let activeFieldFrame = activeField.convert(activeField.bounds, to: scrollView)

            // キーボードとツールバーの高さを考慮した可視領域を計算
            let visibleRect = scrollView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0))

            // テキストフィールドが可視領域に収まっていない場合にスクロール
            if !visibleRect.contains(activeFieldFrame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeFieldFrame.maxY - visibleRect.height + 10) // 10は余白
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        // スクロールビューのコンテンツインセットを元に戻す
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    @objc func findActiveResponder() -> UIView? {
        for subview in scrollView.subviews {
            if subview.isFirstResponder {
                return subview
            }
        }
        return nil
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true) // キーボードを閉じる
    }
}

private extension ReservationNightView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        
        // UI要素の基本設定のみ行う（制約は後で動的に設定）
        setupUIElements()
        
        // 初回レイアウト設定
        updateLayoutForCurrentOrientation()
    }
    /// UI要素の基本設定
    func setupUIElements() {
        func setupTextField(_ textField: UITextField, text: String = "") {
            textField.backgroundColor = UIColor.white
            textField.text = text
            textField.textColor = UIColor.black
            textField.keyboardType = .default
            textField.returnKeyType = .next
            textField.textAlignment = .center
            textField.borderStyle = .roundedRect
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 1.0
            textField.translatesAutoresizingMaskIntoConstraints = false
        }
        
        func setupLabel(_ label: UILabel, text: String = "") {
            label.text = text
            label.textColor = UIColor.black
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
        
        // ScrollView設定
        scrollView.isScrollEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        // PickerBackgroundView設定
        pickerBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        pickerBackgroundView.isHidden = true
        pickerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pickerBackgroundView)
        
        // 全てのUI要素を設定
        errorMessageLabel.text = " "
        errorMessageLabel.textColor = UIColor.red
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(errorMessageLabel)
        
        setupLabel(dateTitleLabel, text: "日付：")
        scrollView.addSubview(dateTitleLabel)
        
        setupTextField(dateTextField)
        scrollView.addSubview(dateTextField)
        setupDateTextFieldPicker()
        
        setupLabel(nameTitleLabel, text: "氏名：")
        scrollView.addSubview(nameTitleLabel)
        
        setupTextField(nameTextField)
        scrollView.addSubview(nameTextField)
        
        setupLabel(countTitleLabel, text: "人数：")
        scrollView.addSubview(countTitleLabel)
        
        setupTextField(countTextField)
        countTextField.keyboardType = .numberPad
        scrollView.addSubview(countTextField)
        
        setupLabel(telTitleLabel, text: "電話番号：")
        scrollView.addSubview(telTitleLabel)
        
        setupTextField(telTextField)
        countTextField.keyboardType = .phonePad
        scrollView.addSubview(telTextField)
        
        setupLabel(priceTitleLabel, text: "料金：")
        scrollView.addSubview(priceTitleLabel)
        
        setupTextField(priceTextField)
        priceTextField.keyboardType = .numberPad
        scrollView.addSubview(priceTextField)
        
        setupLabel(memoTitleLabel, text: "メモ：")
        scrollView.addSubview(memoTitleLabel)
        
        setupTextField(memoTextField)
        scrollView.addSubview(memoTextField)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        paddingView.backgroundColor = UIColor.clear
        memoTextField.leftView = paddingView
        memoTextField.leftViewMode = .always
        
        memoTextField.tag = 4
        scrollView.addSubview(memoTextField)
        
        // ボタン設定
        setupButton(submitButton, text: "予約")
        submitButton.addTarget(self, action: #selector(self.tapSubmitButton), for: .touchUpInside)
        self.addSubview(submitButton)
        
        setupButton(cancelButton, text: "キャンセル")
        cancelButton.addTarget(self, action: #selector(self.tapCancelButton), for: .touchUpInside)
        self.addSubview(cancelButton)
        
        // 基本的な制約（ScrollViewとPickerBackgroundView）
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            
            pickerBackgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            pickerBackgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            pickerBackgroundView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            pickerBackgroundView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
        ])
    }

    func setupDateTextFieldPicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        dateTextField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelDatePicker))
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneDatePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = formatter.string(from: sender.date)
    }

    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder()
    }

    @objc private func cancelDatePicker() {
        dateTextField.resignFirstResponder()
    }
    
    // 予約ボタンタップ時のイベント
    @objc func tapSubmitButton() {
        delegate?.tapReservationNightSubmitButton(id: selectedId, branch: selectedBranch, date: dateTextField.text!, name: nameTextField.text!, tel: telTextField.text!, count: Int(countTextField.text!)!, price: Int(priceTextField.text!)!, memo: memoTextField.text!, visitorHistoryId: selectedVisitorHistoryId)
    }
    
    // キャンセルボタンタップ時のイベント
    @objc func tapCancelButton() {

        memoTextField.text = ""
        delegate?.tapReservationNightCancelButton()
    }
}

// MARK: - 画面回転処理
private extension ReservationNightView {
    
    /// 画面回転の監視を開始
    func setupOrientationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    /// 画面回転の監視を解除
    func removeOrientationObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    /// 画面回転時の処理
    @objc func orientationDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // レイアウトを更新
            self.updateLayoutForCurrentOrientation()
        }
    }
    
    /// 現在の画面向きに応じてレイアウトを更新
    func updateLayoutForCurrentOrientation() {
        // 既存の制約を削除
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.removeAll()
        
        // フォントサイズを更新
        updateFontSizesForOrientation()
        
        // 新しい制約を設定
        setupConstraintsForCurrentOrientation()
        
        // アニメーション付きでレイアウトを更新
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    /// 画面向きに応じてフォントサイズを更新
    func updateFontSizesForOrientation() {
        let currentScreenWidth = dynamicScreenWidth
        let fontSize: CGFloat = currentScreenWidth < 668 ? 16 : 32
        let buttonFontSize: CGFloat = screenWidth < 668 ? 12 : 24
        
        // 全てのラベルのフォントサイズを更新
        [dateTitleLabel, nameTitleLabel, countTitleLabel, telTitleLabel, priceTitleLabel, memoTitleLabel
        ].forEach { label in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        // 全てのテキストフィールドのフォントサイズを更新
        [dateTextField, nameTextField, countTextField, telTextField, priceTextField, memoTextField
        ].forEach { textField in
            textField.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        // ボタンのフォントサイズを更新
        [submitButton, cancelButton].forEach { button in
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        }
    }
    
    /// 現在の画面向きに応じて制約を設定
    func setupConstraintsForCurrentOrientation() {
        let currentScreenWidth = dynamicScreenWidth
        
        if currentScreenWidth < 668 {
            if isPortrait {
                setupSmallScreenPortraitConstraints()
            } else {
                setupSmallScreenLandscapeConstraints()
            }
        } else if isPortrait {
            setupPortraitConstraints()
        } else {
            setupLandscapeConstraints()
        }
    }
    
    /// 縦向き（スマホ）用の制約
    func setupSmallScreenPortraitConstraints() {
        let constraints = [
            errorMessageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            errorMessageLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 32),
            
            dateTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 16),
            dateTitleLabel.rightAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 150),
            
            dateTextField.topAnchor.constraint(equalTo: dateTitleLabel.topAnchor),
            dateTextField.bottomAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor),
            dateTextField.leftAnchor.constraint(equalTo: dateTitleLabel.rightAnchor, constant: 8),
            dateTextField.widthAnchor.constraint(equalToConstant: 200),
            
            nameTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 16),
            nameTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.topAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 8),
            nameTextField.widthAnchor.constraint(equalToConstant: 200),
            
            countTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 16),
            countTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            countTextField.topAnchor.constraint(equalTo: countTitleLabel.topAnchor),
            countTextField.bottomAnchor.constraint(equalTo: countTitleLabel.bottomAnchor),
            countTextField.leftAnchor.constraint(equalTo: countTitleLabel.rightAnchor, constant: 8),
            countTextField.widthAnchor.constraint(equalToConstant: 200),
            
            telTitleLabel.topAnchor.constraint(equalTo: countTitleLabel.bottomAnchor, constant: 16),
            telTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            telTextField.topAnchor.constraint(equalTo: telTitleLabel.topAnchor),
            telTextField.bottomAnchor.constraint(equalTo: telTitleLabel.bottomAnchor),
            telTextField.leftAnchor.constraint(equalTo: telTitleLabel.rightAnchor, constant: 8),
            telTextField.widthAnchor.constraint(equalToConstant: 200),
            
            priceTitleLabel.topAnchor.constraint(equalTo: telTitleLabel.bottomAnchor, constant: 16),
            priceTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            priceTextField.topAnchor.constraint(equalTo: priceTitleLabel.topAnchor),
            priceTextField.bottomAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor),
            priceTextField.leftAnchor.constraint(equalTo: priceTitleLabel.rightAnchor, constant: 8),
            priceTextField.widthAnchor.constraint(equalToConstant: 200),
            
            memoTitleLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 16),
            memoTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            memoTextField.topAnchor.constraint(equalTo: memoTitleLabel.topAnchor),
            memoTextField.bottomAnchor.constraint(equalTo: memoTitleLabel.bottomAnchor),
            memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 8),
            memoTextField.widthAnchor.constraint(equalToConstant: 200),
            
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),
            submitButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 24),
            submitButton.widthAnchor.constraint(equalToConstant: 120),
            
            cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
            cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 24),
            cancelButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        currentConstraints.append(contentsOf: constraints)
        NSLayoutConstraint.activate(constraints)
    }

    /// 横向き（スマホ）用の制約
    func setupSmallScreenLandscapeConstraints() {
        let constraints = [
            errorMessageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            errorMessageLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 32),
            
            dateTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 8),
            dateTitleLabel.rightAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 200),
            
            dateTextField.topAnchor.constraint(equalTo: dateTitleLabel.topAnchor),
            dateTextField.bottomAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor),
            dateTextField.leftAnchor.constraint(equalTo: dateTitleLabel.rightAnchor, constant: 8),
            dateTextField.widthAnchor.constraint(equalToConstant: 200),
            
            nameTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 8),
            nameTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.topAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 8),
            nameTextField.widthAnchor.constraint(equalToConstant: 200),
            
            countTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            countTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            countTextField.topAnchor.constraint(equalTo: countTitleLabel.topAnchor),
            countTextField.bottomAnchor.constraint(equalTo: countTitleLabel.bottomAnchor),
            countTextField.leftAnchor.constraint(equalTo: countTitleLabel.rightAnchor, constant: 8),
            countTextField.widthAnchor.constraint(equalToConstant: 200),
            
            telTitleLabel.topAnchor.constraint(equalTo: countTitleLabel.bottomAnchor, constant: 8),
            telTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            telTextField.topAnchor.constraint(equalTo: telTitleLabel.topAnchor),
            telTextField.bottomAnchor.constraint(equalTo: telTitleLabel.bottomAnchor),
            telTextField.leftAnchor.constraint(equalTo: telTitleLabel.rightAnchor, constant: 8),
            telTextField.widthAnchor.constraint(equalToConstant: 200),
            
            priceTitleLabel.topAnchor.constraint(equalTo: telTitleLabel.bottomAnchor, constant: 8),
            priceTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            priceTextField.topAnchor.constraint(equalTo: priceTitleLabel.topAnchor),
            priceTextField.bottomAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor),
            priceTextField.leftAnchor.constraint(equalTo: priceTitleLabel.rightAnchor, constant: 8),
            priceTextField.widthAnchor.constraint(equalToConstant: 200),
            
            memoTitleLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 8),
            memoTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            memoTextField.topAnchor.constraint(equalTo: memoTitleLabel.topAnchor),
            memoTextField.bottomAnchor.constraint(equalTo: memoTitleLabel.bottomAnchor),
            memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 8),
            memoTextField.widthAnchor.constraint(equalToConstant: 200),
            
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),
            submitButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 24),
            submitButton.widthAnchor.constraint(equalToConstant: 120),
            
            cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
            cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 24),
            cancelButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        currentConstraints.append(contentsOf: constraints)
        NSLayoutConstraint.activate(constraints)
    }
    
    /// 縦向き（タブレット）用の制約
    func setupPortraitConstraints() {
        let constraints = [
            errorMessageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            errorMessageLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 64),
            
            dateTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 32),
            dateTitleLabel.rightAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 300),
            
            dateTextField.topAnchor.constraint(equalTo: dateTitleLabel.topAnchor),
            dateTextField.bottomAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor),
            dateTextField.leftAnchor.constraint(equalTo: dateTitleLabel.rightAnchor, constant: 16),
            dateTextField.widthAnchor.constraint(equalToConstant: 400),
            
            nameTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 32),
            nameTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.topAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 16),
            nameTextField.widthAnchor.constraint(equalToConstant: 400),
            
            countTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 32),
            countTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            countTextField.topAnchor.constraint(equalTo: countTitleLabel.topAnchor),
            countTextField.bottomAnchor.constraint(equalTo: countTitleLabel.bottomAnchor),
            countTextField.leftAnchor.constraint(equalTo: countTitleLabel.rightAnchor, constant: 16),
            countTextField.widthAnchor.constraint(equalToConstant: 400),
            
            telTitleLabel.topAnchor.constraint(equalTo: countTitleLabel.bottomAnchor, constant: 32),
            telTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            telTextField.topAnchor.constraint(equalTo: telTitleLabel.topAnchor),
            telTextField.bottomAnchor.constraint(equalTo: telTitleLabel.bottomAnchor),
            telTextField.leftAnchor.constraint(equalTo: telTitleLabel.rightAnchor, constant: 16),
            telTextField.widthAnchor.constraint(equalToConstant: 400),
            
            priceTitleLabel.topAnchor.constraint(equalTo: telTitleLabel.bottomAnchor, constant: 32),
            priceTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            priceTextField.topAnchor.constraint(equalTo: priceTitleLabel.topAnchor),
            priceTextField.bottomAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor),
            priceTextField.leftAnchor.constraint(equalTo: priceTitleLabel.rightAnchor, constant: 16),
            priceTextField.widthAnchor.constraint(equalToConstant: 400),

            memoTitleLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 32),
            memoTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            memoTextField.topAnchor.constraint(equalTo: memoTitleLabel.topAnchor),
            memoTextField.bottomAnchor.constraint(equalTo: memoTitleLabel.bottomAnchor),
            memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 16),
            memoTextField.widthAnchor.constraint(equalToConstant: 400),
            
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            submitButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -32),
            submitButton.heightAnchor.constraint(equalToConstant: 48),
            submitButton.widthAnchor.constraint(equalToConstant: 160),
            
            cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
            cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -32),
            cancelButton.heightAnchor.constraint(equalToConstant: 48),
            cancelButton.widthAnchor.constraint(equalToConstant: 160)
        ]
        
        currentConstraints.append(contentsOf: constraints)
        NSLayoutConstraint.activate(constraints)
    }
    
    /// 横向き（タブレット）用の制約
    func setupLandscapeConstraints() {
        let constraints = [
            errorMessageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            errorMessageLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 32),
            
            dateTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 32),
            dateTitleLabel.rightAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 400),
            
            dateTextField.topAnchor.constraint(equalTo: dateTitleLabel.topAnchor),
            dateTextField.bottomAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor),
            dateTextField.leftAnchor.constraint(equalTo: dateTitleLabel.rightAnchor, constant: 8),
            dateTextField.widthAnchor.constraint(equalToConstant: 300),
            
            nameTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 32),
            nameTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.topAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 8),
            nameTextField.widthAnchor.constraint(equalToConstant: 300),
            
            countTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 32),
            countTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            countTextField.topAnchor.constraint(equalTo: countTitleLabel.topAnchor),
            countTextField.bottomAnchor.constraint(equalTo: countTitleLabel.bottomAnchor),
            countTextField.leftAnchor.constraint(equalTo: countTitleLabel.rightAnchor, constant: 8),
            countTextField.widthAnchor.constraint(equalToConstant: 300),
            
            telTitleLabel.topAnchor.constraint(equalTo: countTitleLabel.bottomAnchor, constant: 32),
            telTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            telTextField.topAnchor.constraint(equalTo: telTitleLabel.topAnchor),
            telTextField.bottomAnchor.constraint(equalTo: telTitleLabel.bottomAnchor),
            telTextField.leftAnchor.constraint(equalTo: telTitleLabel.rightAnchor, constant: 8),
            telTextField.widthAnchor.constraint(equalToConstant: 300),
            
            priceTitleLabel.topAnchor.constraint(equalTo: telTitleLabel.bottomAnchor, constant: 32),
            priceTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            priceTextField.topAnchor.constraint(equalTo: priceTitleLabel.topAnchor),
            priceTextField.bottomAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor),
            priceTextField.leftAnchor.constraint(equalTo: priceTitleLabel.rightAnchor, constant: 8),
            priceTextField.widthAnchor.constraint(equalToConstant: 300),
            
            memoTitleLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 32),
            memoTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
            
            memoTextField.topAnchor.constraint(equalTo: memoTitleLabel.topAnchor),
            memoTextField.bottomAnchor.constraint(equalTo: memoTitleLabel.bottomAnchor),
            memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 8),
            memoTextField.widthAnchor.constraint(equalToConstant: 300),
            
            // ボタン
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            submitButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -32),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            submitButton.widthAnchor.constraint(equalToConstant: 160),
            
            cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
            cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.widthAnchor.constraint(equalToConstant: 160)
        ]
        
        currentConstraints.append(contentsOf: constraints)
        NSLayoutConstraint.activate(constraints)
    }
}

extension ReservationNightView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // キーボードを閉じる
        return true
    }
}
