//
//  EditMedicalHistoryView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/30.
//

import Foundation
import UIKit

protocol EditMedicalHistoryDelegate: AnyObject  {
    func tapCancelButton()
    func tapSubmitButton(id: Int, date: String, overview: String, detail: String?)
}

public class EditMedicalHistoryView: UIView {
    
    let scrollView = UIScrollView()
    
    let errorMessageLabel = UILabel()
    let dateTitleLabel = UILabel()
    var dateTextField = UITextField()
    let overviewTitleLabel = UILabel()
    var overviewTextField = UITextField()
    let detailTitleLabel = UILabel()
    var detailTextView = UITextView()
    let submitButton = UIButton()
    let cancelButton = UIButton()
    
    var id = -1
    
    weak var delegate: EditMedicalHistoryDelegate?

    public init() {
        super.init(frame: .zero)
        
        setupView()
        setupDatePicker()
        
        // キーボードイベントの監視
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // キーボードイベントの監視を解除
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dateEditing(sender: textField)
    }
    
    // 日付を入力する
    func dateEditing(sender: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale? = NSLocale(localeIdentifier: "ja_JP") as Locale
        sender.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    // 日付を変更した際にUITextFieldに値を設定する
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter       = DateFormatter()
        dateFormatter.locale    = NSLocale(localeIdentifier: "ja_JP") as Locale
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        let toolbarHeight: CGFloat = 44

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + toolbarHeight, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset

        // 現在編集中のテキストフィールドまたはテキストビューを取得
        if let activeField = findActiveResponder() {
            let activeFieldFrame = activeField.convert(activeField.bounds, to: scrollView)
            let visibleRect = scrollView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + toolbarHeight, right: 0))

            // テキストフィールドまたはテキストビューが可視領域に収まっていない場合にスクロール
            if !visibleRect.contains(activeFieldFrame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeFieldFrame.maxY - visibleRect.height + 10)
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
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd" // 日付フォーマット
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func doneButtonTapped() {
        // UIDatePickerの現在の値を取得
        if let datePicker = dateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd" // 日付フォーマット
            dateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        
        // キーボード（UIDatePicker）を閉じる
        dateTextField.resignFirstResponder()
    }
    
    func clear() {
        errorMessageLabel.text = " "
        dateTextField.text = ""
        overviewTextField.text = ""
        detailTextView.text = ""
    }
}

private extension EditMedicalHistoryView {
    
    func setupView() {
        
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        
        scrollView.isScrollEnabled = true
        //        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        self.addSubview(scrollView)
        
        errorMessageLabel.text = " "
        errorMessageLabel.textColor = UIColor.red
        scrollView.addSubview(errorMessageLabel)
        
        dateTitleLabel.text = "日付："
        dateTitleLabel.textColor = UIColor.black
        scrollView.addSubview(dateTitleLabel)
        
        dateTextField.attributedPlaceholder = NSAttributedString(string: "日付を選択してください", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, .font : UIFont.systemFont(ofSize: 16)])
        dateTextField.keyboardType = .default
        dateTextField.returnKeyType = .next
        dateTextField.textColor = UIColor.black
        dateTextField.backgroundColor = UIColor.white
        let l_paddingView_1 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        l_paddingView_1.backgroundColor = UIColor.clear
        dateTextField.leftView = l_paddingView_1
        dateTextField.leftViewMode = .always
        dateTextField.borderStyle = .roundedRect
        dateTextField.layer.borderColor = UIColor.black.cgColor
        dateTextField.layer.borderWidth = 1.0
        dateTextField.layer.cornerRadius = 5
        dateTextField.frame = self.frame
        dateTextField.tag = 0
        //        dateTextField.delegate = self
        scrollView.addSubview(dateTextField)
        
        overviewTitleLabel.text = "概要："
        overviewTitleLabel.textColor = UIColor.black
        scrollView.addSubview(overviewTitleLabel)
        
        overviewTextField.attributedPlaceholder = NSAttributedString(string: "概要を入力してください", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, .font : UIFont.systemFont(ofSize: 16)])
        overviewTextField.keyboardType = .default
        overviewTextField.returnKeyType = .next
        overviewTextField.textColor = UIColor.black
        overviewTextField.backgroundColor = UIColor.white
        let l_paddingView_2 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        l_paddingView_2.backgroundColor = UIColor.clear
        overviewTextField.leftView = l_paddingView_2
        overviewTextField.leftViewMode = .always
        overviewTextField.borderStyle = .roundedRect
        overviewTextField.layer.borderColor = UIColor.black.cgColor
        overviewTextField.layer.borderWidth = 1.0
        overviewTextField.layer.cornerRadius = 5
        overviewTextField.frame = self.frame
        overviewTextField.tag = 1
        scrollView.addSubview(overviewTextField)
        
        detailTitleLabel.text = "詳細："
        detailTitleLabel.textColor = UIColor.black
        scrollView.addSubview(detailTitleLabel)
        
        detailTextView.isScrollEnabled = true
        detailTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        detailTextView.layer.borderColor = UIColor.black.cgColor
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.cornerRadius = 5
        detailTextView.textColor = UIColor.black
        detailTextView.backgroundColor = UIColor.white
        scrollView.addSubview(detailTextView)
        
        submitButton.backgroundColor = UIColor.white
        submitButton.layer.borderColor = UIColor.black.cgColor
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.cornerRadius = 10
        submitButton.setTitle("登録", for: .normal)
        submitButton.setTitleColor(UIColor.black, for: .normal)
        submitButton.addTarget(self, action: #selector(self.tapSubmitButton(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(submitButton)
        
        cancelButton.backgroundColor = UIColor.white
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.cornerRadius = 10
        cancelButton.setTitle("キャンセル", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.tapCancelButton(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(cancelButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        overviewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewTextField.translatesAutoresizingMaskIntoConstraints = false
        detailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            errorMessageLabel.font = UIFont.systemFont(ofSize: 16)
            dateTitleLabel.font = UIFont.systemFont(ofSize: 16)
            overviewTitleLabel.font = UIFont.systemFont(ofSize: 16)
            detailTitleLabel.font = UIFont.systemFont(ofSize: 16)
            detailTextView.font = UIFont.systemFont(ofSize: 16)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -50),
                scrollView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
                errorMessageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
                errorMessageLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 45),
                dateTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 16),
                dateTitleLabel.rightAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 120),
                dateTextField.topAnchor.constraint(equalTo: dateTitleLabel.topAnchor),
                dateTextField.bottomAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor),
                dateTextField.leftAnchor.constraint(equalTo: dateTitleLabel.rightAnchor, constant: 16),
                dateTextField.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -50),
                overviewTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 16),
                overviewTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
                overviewTextField.topAnchor.constraint(equalTo: overviewTitleLabel.topAnchor),
                overviewTextField.bottomAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor),
                overviewTextField.leftAnchor.constraint(equalTo: dateTextField.leftAnchor),
                overviewTextField.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -50),
                overviewTextField.widthAnchor.constraint(equalToConstant: 300),
                detailTitleLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: 16),
                detailTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
                detailTextView.topAnchor.constraint(equalTo: detailTitleLabel.topAnchor),
                detailTextView.leftAnchor.constraint(equalTo: dateTextField.leftAnchor),
                detailTextView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -50),
                detailTextView.heightAnchor.constraint(equalToConstant: 80),
                detailTextView.widthAnchor.constraint(equalToConstant: 300),
                submitButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
                submitButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                submitButton.heightAnchor.constraint(equalToConstant: 32),
                submitButton.widthAnchor.constraint(equalToConstant: 120),
                cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -16),
                cancelButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
                cancelButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor),
                cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor)
            ])
        } else { // 通常の画面の場合
            errorMessageLabel.font = UIFont.systemFont(ofSize: 32)
            dateTitleLabel.font = UIFont.systemFont(ofSize: 32)
            dateTextField.font = UIFont.systemFont(ofSize: 32)
            overviewTitleLabel.font = UIFont.systemFont(ofSize: 32)
            overviewTextField.font = UIFont.systemFont(ofSize: 32)
            detailTitleLabel.font = UIFont.systemFont(ofSize: 32)
            detailTextView.font = UIFont.systemFont(ofSize: 32)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
                scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -100),
                scrollView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
                errorMessageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
                errorMessageLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 90),
                dateTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 48),
                dateTitleLabel.rightAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 240),
                dateTextField.topAnchor.constraint(equalTo: dateTitleLabel.topAnchor),
                dateTextField.bottomAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor),
                dateTextField.leftAnchor.constraint(equalTo: dateTitleLabel.rightAnchor, constant: 32),
                overviewTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 64),
                overviewTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
                overviewTextField.topAnchor.constraint(equalTo: overviewTitleLabel.topAnchor),
                overviewTextField.bottomAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor),
                overviewTextField.leftAnchor.constraint(equalTo: dateTextField.leftAnchor),
                overviewTextField.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -100),
                overviewTextField.widthAnchor.constraint(equalToConstant: 600),
                detailTitleLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: 64),
                detailTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
                detailTextView.topAnchor.constraint(equalTo: detailTitleLabel.topAnchor),
                detailTextView.leftAnchor.constraint(equalTo: dateTextField.leftAnchor),
                detailTextView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -100),
                detailTextView.heightAnchor.constraint(equalToConstant: 200),
                detailTextView.widthAnchor.constraint(equalToConstant: 600),
                submitButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
                submitButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32),
                submitButton.heightAnchor.constraint(equalToConstant: 48),
                submitButton.widthAnchor.constraint(equalToConstant: 160),
                cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -32),
                cancelButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
                cancelButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor),
                cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor)
            ])
        }
    }
    
    @objc func tapCancelButton(_ sender: UIButton){
        self.clear()
        delegate?.tapCancelButton()
    }
    
    @objc func tapSubmitButton(_ sender: UIButton){
        if (dateTextField.text == "") {
            errorMessageLabel.text = "日付を入力してください"
            return
        } else {
            if !self.dateCheck(date: dateTextField.text!) {
                errorMessageLabel.text = "日付はyyyy/mm/dd形式で入力してください"
            }
        }
        
        if (overviewTextField.text == "") {
            errorMessageLabel.text = "概要を入力してください"
            return
        }

        let date = dateTextField.text!.replacingOccurrences(of: "/", with: "-")
        
        delegate?.tapSubmitButton(id: id, date: date, overview: overviewTextField.text!, detail: detailTextView.text)
    }
    
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ja_JP") // 日本語ロケール
        datePicker.date = Date() // 初期値を当日に設定
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        // `dateTextField`の`inputView`に`datePicker`を設定
        dateTextField.inputView = datePicker
        
        // 初期値を`dateTextField`に設定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        
        // ツールバーを追加（完了ボタンとキャンセルボタン付き）
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // キャンセルボタン
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelButtonTapped))
        // スペース
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // 完了ボタン
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
    }

    @objc private func cancelButtonTapped() {
        // キャンセルボタンが押されたときの処理
        dateTextField.resignFirstResponder() // キーボード（UIDatePicker）を閉じる
    }
    
    func dateCheck(date: String) -> Bool {
        return true
    }
    
}

extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}
