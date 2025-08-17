//
//  LeaveView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/05.
//

import Foundation
import UIKit

protocol LeaveDelegate: AnyObject  {
    func tapLeaveSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String)
    func tapLeaveCancelButton()
}

public class LeaveView: UIView {
    
    let scrollView = UIScrollView()
    
    let pickerBackgroundView = UIView()
    let errorMessageLabel = UILabel()
    
    let enterTimeTitleLabel = UILabel()
    let enterTimeTextField = UITextField()
    let enterTimePicker = UIDatePicker()
    let leftTimeTitleLabel = UILabel()
    let leftTimeTextField = UITextField()
    let leftTimePicker = UIDatePicker()
    let stayTimeTitleLabel = UILabel()
    let stayTimeLabel = UILabel()
    let discountAmountTitleLabel = UILabel()
    let discountAmountTextField = UITextField()
    let gachaAmountTitleLabel = UILabel()
    let gachaAmountTextField = UITextField()
    let salesAmountTitleLabel = UILabel()
    let salesAmountTextField = UITextField()
    let feeTitleLabel = UILabel()
    let feeLabel = UILabel()
    let feeCalcButton = UIButton()
    let memoTitleLabel = UILabel()
    let memoTextField = UITextField()
    
    let submitButton = UIButton()
    let cancelButton = UIButton()
    
    var id: Int = -1
    var repeatFlag: Bool = false
    var patternId: Int = 0
    var name: String = ""
    var date: String = ""
//    var checkDayFlag: Int = 0
    var holidayFlag: Bool = false
    var kidsDayFlag: Bool = false
    var enterTime: String = ""
    var stayTime: Int = 0
    var calcAmount: Int = 0
    var discountAmount: Int = 0
    var salesAmount: Int = 0
    var gachaAmount: Int = 0
    var totalAmount: Int = 0
    var adultCount: Int = 0
    var childCount: Int = 0
    var memo: String = ""
    
    weak var delegate: LeaveDelegate?
    
    public init() {
        super.init(frame: .zero)
        
        adultCount = 1
        
        setupViews()
        
//        enterTimePicker.date = Date()
        leftTimePicker.date = Date()
        
        // キーボードイベントの監視
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLeaveInfo(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, adultCount: Int, childCount: Int, memo: String) {
        self.id = id
        self.repeatFlag = repeatFlag
        self.patternId = patternId
        self.name = name ?? ""
        self.date = date
        self.holidayFlag = holidayFlag
        self.kidsDayFlag = kidsdayFlag
        self.enterTime = enterTime
        self.adultCount = adultCount
        self.childCount = childCount
        self.memo = memo
        
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        date = formatter.string(from: Date())
        formatter.dateFormat = "HH:mm"
        enterTimeTextField.text = enterTime
        leftTimeTextField.text = formatter.string(from: Date())
        stayTimeLabel.text = ""
        discountAmountTextField.text = "0"
        salesAmountTextField.text = "0"
        gachaAmountTextField.text = "0"
        feeLabel.text = ""
        memoTextField.text = memo
    }
    
    deinit {
        // キーボードイベントの監視を解除
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
}

private extension LeaveView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        
        setupTapGesture()
        
        scrollView.isScrollEnabled = true
        //        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        self.addSubview(scrollView)
        
        errorMessageLabel.text = " "
        errorMessageLabel.font = UIFont.systemFont(ofSize: 32)
        errorMessageLabel.textColor = UIColor.red
        scrollView.addSubview(errorMessageLabel)
        
        enterTimeTitleLabel.text = "入店時間："
        enterTimeTitleLabel.font = UIFont.systemFont(ofSize: 32)
        enterTimeTitleLabel.textColor = UIColor.black
        scrollView.addSubview(enterTimeTitleLabel)
        
        enterTimeTextField.backgroundColor = UIColor.lightGray
        enterTimeTextField.text = " "
        enterTimeTextField.font = UIFont.systemFont(ofSize: 32)
        enterTimeTextField.textColor = UIColor.black
        scrollView.addSubview(enterTimeTextField)
        
        enterTimeTextField.keyboardType = .default
        enterTimeTextField.returnKeyType = .next
        enterTimeTextField.textColor = UIColor.black
        enterTimeTextField.backgroundColor = UIColor.white
        enterTimeTextField.textAlignment = .center
        enterTimeTextField.borderStyle = .roundedRect
        enterTimeTextField.layer.borderColor = UIColor.black.cgColor
        enterTimeTextField.layer.borderWidth = 1.0
        enterTimeTextField.frame = self.frame
        enterTimeTextField.tag = 1
//        enterTimeTextField.isEnabled = false
        scrollView.addSubview(enterTimeTextField)
        
        setupEnterTimeTextField()
        
        leftTimeTitleLabel.text = "退店時間："
        leftTimeTitleLabel.font = UIFont.systemFont(ofSize: 32)
        leftTimeTitleLabel.textColor = UIColor.black
        scrollView.addSubview(leftTimeTitleLabel)
        
        leftTimeTextField.backgroundColor = UIColor.lightGray
        leftTimeTextField.text = " "
        leftTimeTextField.font = UIFont.systemFont(ofSize: 32)
        leftTimeTextField.textColor = UIColor.black
        scrollView.addSubview(leftTimeTextField)
        
        leftTimeTextField.keyboardType = .default
        leftTimeTextField.returnKeyType = .next
        leftTimeTextField.textColor = UIColor.black
        leftTimeTextField.backgroundColor = UIColor.white
        leftTimeTextField.textAlignment = .center
        leftTimeTextField.borderStyle = .roundedRect
        leftTimeTextField.layer.borderColor = UIColor.black.cgColor
        leftTimeTextField.layer.borderWidth = 1.0
        leftTimeTextField.frame = self.frame
        leftTimeTextField.tag = 1
//        leftTimeTextField.isEnabled = false
        scrollView.addSubview(leftTimeTextField)
        
        setupLeftTimeTextField()
        
        stayTimeTitleLabel.text = "滞在時間："
        stayTimeTitleLabel.font = UIFont.systemFont(ofSize: 32)
        stayTimeTitleLabel.textColor = UIColor.black
        scrollView.addSubview(stayTimeTitleLabel)
        
        stayTimeLabel.backgroundColor = UIColor.lightGray
        stayTimeLabel.text = " "
        stayTimeLabel.font = UIFont.systemFont(ofSize: 32)
        stayTimeLabel.textColor = UIColor.black
        stayTimeLabel.textAlignment = .center
        scrollView.addSubview(stayTimeLabel)
        
        discountAmountTitleLabel.text = "割引額："
        discountAmountTitleLabel.font = UIFont.systemFont(ofSize: 32)
        discountAmountTitleLabel.textColor = UIColor.black
        scrollView.addSubview(discountAmountTitleLabel)
        
        discountAmountTextField.text = "0"
        discountAmountTextField.keyboardType = .numberPad
        discountAmountTextField.returnKeyType = .done
        discountAmountTextField.font = discountAmountTextField.font?.withSize(32)
        discountAmountTextField.textColor = UIColor.red
        discountAmountTextField.backgroundColor = UIColor.white
        discountAmountTextField.textAlignment = .center
        discountAmountTextField.borderStyle = .roundedRect
        discountAmountTextField.layer.borderColor = UIColor.black.cgColor
        discountAmountTextField.layer.borderWidth = 1.0
        discountAmountTextField.frame = self.frame
        discountAmountTextField.tag = 1
        scrollView.addSubview(discountAmountTextField)
        
        setupDiscountAmountTextField()
        
        gachaAmountTitleLabel.text = "ガチャ額："
        gachaAmountTitleLabel.font = UIFont.systemFont(ofSize: 32)
        gachaAmountTitleLabel.textColor = UIColor.black
        scrollView.addSubview(gachaAmountTitleLabel)
        
        gachaAmountTextField.text = "0"
        gachaAmountTextField.keyboardType = .numberPad
        gachaAmountTextField.returnKeyType = .done
        gachaAmountTextField.font = gachaAmountTextField.font?.withSize(32)
        gachaAmountTextField.textColor = UIColor.black
        gachaAmountTextField.backgroundColor = UIColor.white
        gachaAmountTextField.textAlignment = .center
        gachaAmountTextField.borderStyle = .roundedRect
        gachaAmountTextField.layer.borderColor = UIColor.black.cgColor
        gachaAmountTextField.layer.borderWidth = 1.0
        gachaAmountTextField.frame = self.frame
        gachaAmountTextField.tag = 2
        scrollView.addSubview(gachaAmountTextField)
        
        setupGachaAmountTextField()

        salesAmountTitleLabel.text = "販売額："
        salesAmountTitleLabel.font = UIFont.systemFont(ofSize: 32)
        salesAmountTitleLabel.textColor = UIColor.black
        scrollView.addSubview(salesAmountTitleLabel)
        
        salesAmountTextField.text = "0"
        salesAmountTextField.keyboardType = .numberPad
        salesAmountTextField.returnKeyType = .next
        salesAmountTextField.font = salesAmountTextField.font?.withSize(32)
        salesAmountTextField.textColor = UIColor.black
        salesAmountTextField.backgroundColor = UIColor.white
        salesAmountTextField.textAlignment = .center
        salesAmountTextField.borderStyle = .roundedRect
        salesAmountTextField.layer.borderColor = UIColor.black.cgColor
        salesAmountTextField.layer.borderWidth = 1.0
        salesAmountTextField.frame = self.frame
        salesAmountTextField.tag = 3
        scrollView.addSubview(salesAmountTextField)
        
        setupSalesAmountTextField()
        
        feeTitleLabel.text = "レジ精算料金："
        feeTitleLabel.font = UIFont.systemFont(ofSize: 32)
        feeTitleLabel.textColor = UIColor.black
        scrollView.addSubview(feeTitleLabel)
        
        feeLabel.backgroundColor = UIColor.lightGray
        feeLabel.text = " "
        feeLabel.font = UIFont.systemFont(ofSize: 32)
        feeLabel.textColor = UIColor.black
        feeLabel.textAlignment = .center
        scrollView.addSubview(feeLabel)
        
        feeCalcButton.setTitle("料金計算", for: .normal)
        feeCalcButton.setTitleColor(UIColor.black, for: .normal)
        feeCalcButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        feeCalcButton.backgroundColor = UIColor.white
        feeCalcButton.layer.borderColor = UIColor.black.cgColor
        feeCalcButton.layer.borderWidth = 1.0
        feeCalcButton.layer.cornerRadius = 10
        feeCalcButton.addTarget(self, action: #selector(self.tapFeeCalcButton), for: .touchUpInside)
        self.addSubview(feeCalcButton)
        
        memoTitleLabel.text = "メモ："
        memoTitleLabel.font = UIFont.systemFont(ofSize: 32)
        memoTitleLabel.textColor = UIColor.black
        memoTitleLabel.textAlignment = .center
        scrollView.addSubview(memoTitleLabel)
        
        memoTextField.keyboardType = .default
        memoTextField.returnKeyType = .next
        memoTextField.textColor = UIColor.black
        memoTextField.font = UIFont.systemFont(ofSize: 32)
        memoTextField.backgroundColor = UIColor.white
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        paddingView.backgroundColor = UIColor.clear
        memoTextField.leftView = paddingView
        memoTextField.leftViewMode = .always
        memoTextField.borderStyle = .roundedRect
        memoTextField.layer.borderColor = UIColor.black.cgColor
        memoTextField.layer.borderWidth = 1.0
        memoTextField.frame = self.frame
        memoTextField.tag = 4
        scrollView.addSubview(memoTextField)
        
        submitButton.setTitle("退店登録", for: .normal)
        submitButton.setTitleColor(UIColor.black, for: .normal)
        submitButton.backgroundColor = UIColor.white
        submitButton.layer.borderColor = UIColor.black.cgColor
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(self.tapSubmitButton), for: .touchUpInside)
        self.addSubview(submitButton)
        
        cancelButton.setTitle("キャンセル", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.backgroundColor = UIColor.white
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(self.tapCancelButton), for: .touchUpInside)
        self.addSubview(cancelButton)
        
        enterTimeTextField.delegate = self
        leftTimeTextField.delegate = self
        discountAmountTextField.delegate = self
        gachaAmountTextField.delegate = self
        salesAmountTextField.delegate = self
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        enterTimeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        enterTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        leftTimeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        leftTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        stayTimeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        discountAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        discountAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        gachaAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        gachaAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        salesAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        salesAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        feeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        feeLabel.translatesAutoresizingMaskIntoConstraints = false
        feeCalcButton.translatesAutoresizingMaskIntoConstraints = false
        memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        memoTextField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            
        } else { // 通常の画面の場合
            
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            errorMessageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            errorMessageLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 64),
            enterTimeTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 32),
            enterTimeTitleLabel.rightAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 320),
            enterTimeTextField.topAnchor.constraint(equalTo: enterTimeTitleLabel.topAnchor),
            enterTimeTextField.bottomAnchor.constraint(equalTo: enterTimeTitleLabel.bottomAnchor),
            enterTimeTextField.leftAnchor.constraint(equalTo: enterTimeTitleLabel.rightAnchor, constant: 16),
            enterTimeTextField.widthAnchor.constraint(equalToConstant: 160),
            leftTimeTitleLabel.topAnchor.constraint(equalTo: enterTimeTitleLabel.bottomAnchor, constant: 32),
            leftTimeTitleLabel.rightAnchor.constraint(equalTo: enterTimeTitleLabel.rightAnchor),
            leftTimeTextField.topAnchor.constraint(equalTo: leftTimeTitleLabel.topAnchor),
            leftTimeTextField.bottomAnchor.constraint(equalTo: leftTimeTitleLabel.bottomAnchor),
            leftTimeTextField.leftAnchor.constraint(equalTo: leftTimeTitleLabel.rightAnchor, constant: 16),
            leftTimeTextField.widthAnchor.constraint(equalToConstant: 160),
            stayTimeTitleLabel.centerYAnchor.constraint(equalTo: enterTimeTitleLabel.bottomAnchor, constant: 16),
            stayTimeTitleLabel.leftAnchor.constraint(equalTo: enterTimeTextField.rightAnchor, constant: 64),
            stayTimeLabel.topAnchor.constraint(equalTo: stayTimeTitleLabel.topAnchor),
            stayTimeLabel.bottomAnchor.constraint(equalTo: stayTimeTitleLabel.bottomAnchor),
            stayTimeLabel.leftAnchor.constraint(equalTo: stayTimeTitleLabel.rightAnchor, constant: 16),
            stayTimeLabel.widthAnchor.constraint(equalToConstant: 160),
            discountAmountTitleLabel.topAnchor.constraint(equalTo: leftTimeTitleLabel.bottomAnchor, constant: 32),
            discountAmountTitleLabel.rightAnchor.constraint(equalTo: enterTimeTitleLabel.rightAnchor),
            discountAmountTextField.topAnchor.constraint(equalTo: discountAmountTitleLabel.topAnchor),
            discountAmountTextField.bottomAnchor.constraint(equalTo: discountAmountTitleLabel.bottomAnchor),
            discountAmountTextField.leftAnchor.constraint(equalTo: discountAmountTitleLabel.rightAnchor, constant: 16),
            discountAmountTextField.widthAnchor.constraint(equalToConstant: 240),

            salesAmountTitleLabel.topAnchor.constraint(equalTo: discountAmountTitleLabel.bottomAnchor, constant: 32),
            salesAmountTitleLabel.rightAnchor.constraint(equalTo: enterTimeTitleLabel.rightAnchor),
            salesAmountTextField.topAnchor.constraint(equalTo: salesAmountTitleLabel.topAnchor),
            salesAmountTextField.bottomAnchor.constraint(equalTo: salesAmountTitleLabel.bottomAnchor),
            salesAmountTextField.leftAnchor.constraint(equalTo: salesAmountTitleLabel.rightAnchor, constant: 16),
            salesAmountTextField.widthAnchor.constraint(equalToConstant: 240),
            feeTitleLabel.topAnchor.constraint(equalTo: salesAmountTitleLabel.bottomAnchor, constant: 32),
            feeTitleLabel.rightAnchor.constraint(equalTo: enterTimeTitleLabel.rightAnchor),
            feeLabel.topAnchor.constraint(equalTo: feeTitleLabel.topAnchor),
            feeLabel.bottomAnchor.constraint(equalTo: feeTitleLabel.bottomAnchor),
            feeLabel.leftAnchor.constraint(equalTo: feeTitleLabel.rightAnchor, constant: 16),
            feeLabel.widthAnchor.constraint(equalToConstant: 240),
            feeCalcButton.centerYAnchor.constraint(equalTo: feeTitleLabel.centerYAnchor),
            feeCalcButton.leftAnchor.constraint(equalTo: feeLabel.rightAnchor, constant: 50),
            feeCalcButton.heightAnchor.constraint(equalToConstant: 80),
            feeCalcButton.widthAnchor.constraint(equalToConstant: 160),
            gachaAmountTitleLabel.topAnchor.constraint(equalTo: feeTitleLabel.bottomAnchor, constant: 32),
            gachaAmountTitleLabel.rightAnchor.constraint(equalTo: enterTimeTitleLabel.rightAnchor),
            gachaAmountTextField.topAnchor.constraint(equalTo: gachaAmountTitleLabel.topAnchor),
            gachaAmountTextField.bottomAnchor.constraint(equalTo: gachaAmountTitleLabel.bottomAnchor),
            gachaAmountTextField.leftAnchor.constraint(equalTo: gachaAmountTitleLabel.rightAnchor, constant: 16),
            gachaAmountTextField.widthAnchor.constraint(equalToConstant: 240),
            memoTitleLabel.topAnchor.constraint(equalTo: gachaAmountTitleLabel.bottomAnchor, constant: 32),
            memoTitleLabel.rightAnchor.constraint(equalTo: enterTimeTitleLabel.rightAnchor),
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
        ])
    }
    
    private func setupEnterTimeTextField() {
        // UIDatePickerの設定
        enterTimePicker.datePickerMode = .time
        enterTimePicker.preferredDatePickerStyle = .wheels
        enterTimePicker.locale = Locale(identifier: "ja_JP") // 日本語ロケール
        enterTimeTextField.inputView = enterTimePicker

        // 初期値をテキストフィールドに設定
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 時刻フォーマット
        enterTimeTextField.text = formatter.string(from: enterTimePicker.date)
        
        // ツールバーを追加
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelEnterTimePicker))
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneEnterTimePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        enterTimeTextField.inputAccessoryView = toolbar
    }

    @objc private func doneEnterTimePicker() {
        // 選択された時刻をテキストフィールドに表示
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 時刻フォーマット
        enterTimeTextField.text = formatter.string(from: enterTimePicker.date)
        enterTimeTextField.resignFirstResponder() // ドラムロールを閉じる
    }

    @objc private func cancelEnterTimePicker() {
        enterTimeTextField.resignFirstResponder() // ドラムロールを閉じる
    }
    
    private func setupLeftTimeTextField() {
        // UIDatePickerの設定
        leftTimePicker.datePickerMode = .time
        leftTimePicker.preferredDatePickerStyle = .wheels
        leftTimePicker.locale = Locale(identifier: "ja_JP") // 日本語ロケール
        leftTimeTextField.inputView = leftTimePicker

        // 初期値をテキストフィールドに設定
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 時刻フォーマット
        leftTimeTextField.text = formatter.string(from: leftTimePicker.date)

        // ツールバーを追加
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelLeftTimePicker))
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneLeftTimePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        leftTimeTextField.inputAccessoryView = toolbar
    }
    
    @objc private func doneLeftTimePicker() {
        // 選択された時刻をテキストフィールドに表示
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 時刻フォーマット
        leftTimeTextField.text = formatter.string(from: leftTimePicker.date)
        leftTimeTextField.resignFirstResponder() // ドラムロールを閉じる
    }

    @objc private func cancelLeftTimePicker() {
        leftTimeTextField.resignFirstResponder() // ドラムロールを閉じる
    }
    
    private func setupDiscountAmountTextField() {
        // ツールバーを作成
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // 「完了」ボタンを作成
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneDiscountAmountKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        // ツールバーをテキストフィールドに設定
        discountAmountTextField.inputAccessoryView = toolbar
    }
    
    @objc private func doneDiscountAmountKeyboard() {
        discountAmountTextField.resignFirstResponder() // キーボードを閉じる
    }
    
    private func setupSalesAmountTextField() {
        // ツールバーを作成
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // 「完了」ボタンを作成
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneSalesAmountKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        // ツールバーをテキストフィールドに設定
        salesAmountTextField.inputAccessoryView = toolbar
    }
    
    @objc private func doneSalesAmountKeyboard() {
        salesAmountTextField.resignFirstResponder() // キーボードを閉じる
    }
    
    private func setupGachaAmountTextField() {
        // ツールバーを作成
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // 「完了」ボタンを作成
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneGachaAmountKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        // ツールバーをテキストフィールドに設定
        gachaAmountTextField.inputAccessoryView = toolbar
    }
    
    @objc private func doneGachaAmountKeyboard() {
        gachaAmountTextField.resignFirstResponder() // キーボードを閉じる
    }
    
    private func formatNumber(_ number: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "," // 3桁区切りの区切り文字
        formatter.maximumFractionDigits = 0 // 小数点以下を許可しない
        let numberValue = Int(number) ?? 0
        return formatter.string(from: NSNumber(value: numberValue)) ?? number
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 他のビューのタップイベントも処理する
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        self.endEditing(true) // 現在のファーストレスポンダーを閉じる
    }
    
    // 料金計算ボタンタップ時のイベント
    @objc func tapFeeCalcButton() {
        // 入力チェック
        let inputCheckResult = inputCheck()
        if inputCheckResult != "" {
            errorMessageLabel.text = inputCheckResult
            return
        }
        
        let totalFee = calcTotalFee()
        
        if !(totalFee < 0) {
            feeLabel.text = "¥" + formatNumber(String(totalFee))
        }
    }
    
    // 退店登録ボタンタップ時のイベント
    @objc func tapSubmitButton() {
        // 入力チェック
        let inputCheckResult = inputCheck()
        
        if inputCheckResult != "" {
            errorMessageLabel.text = inputCheckResult
            return
        } else if gachaAmountTextField.text == "" {
            errorMessageLabel.text = "ガチャ額を入力してください"
            return
        }

        // ガチャ額も含めたトータル金額を算出
        let gachaAmountText = gachaAmountTextField.text?.replacingOccurrences(of: ",", with: "") ?? "0"
        self.gachaAmount = Int(gachaAmountText) ?? 0
        self.totalAmount = calcTotalFee() + self.gachaAmount
        
        // 退店データをサーバに登録
        delegate?.tapLeaveSubmitButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTimeTextField.text!, leftTime: leftTimeTextField.text!, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: salesAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memoTextField.text!)
    }
    
    // キャンセルボタンタップ時のイベント
    @objc func tapCancelButton() {
        enterTimeTextField.text = ""
        leftTimeTextField.text = ""
        stayTimeLabel.text = ""
        discountAmountTextField.text = ""
        salesAmountTextField.text = ""
        feeLabel.text = ""
        gachaAmountTextField.text = ""
        delegate?.tapLeaveCancelButton()
    }
    
    func inputCheck() -> String {
        if enterTimeTextField.text == "" {
            return "入店時間を選択してください"
        }
        if leftTimeTextField.text == "" {
            return "退店時間を選択してください"
        }
        if discountAmountTextField.text == "" {
            return "割引額を入力してください"
        }
        if salesAmountTextField.text == "" {
            return "販売額を入力してください"
        }
        return ""
    }
    
    func calcTotalFee() -> Int {
        var totalMinutes: Int = 0
        var adultUnitPrice: Int = 0
        var childUnitPrice: Int = 0
        
        // DateFormatterを使用して時間を取得
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let enterTime = formatter.date(from: enterTimeTextField.text ?? ""),
              let leftTime = formatter.date(from: leftTimeTextField.text ?? "") else {
            stayTimeLabel.text = "エラー"
            return -1
        }
        
        // 時間差を計算
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: enterTime, to: leftTime)
        
        // 分単位で計算
        if let hours = components.hour, let minutes = components.minute {
            totalMinutes = (hours * 60) + minutes
            self.stayTime = totalMinutes
            stayTimeLabel.text = "\(totalMinutes)分"
        } else {
            stayTimeLabel.text = "エラー"
        }

        // 単価計算
        if totalMinutes <= 30 {
            if self.holidayFlag {
                adultUnitPrice = 1200
            } else {
                adultUnitPrice = 1000
            }
        } else if totalMinutes <= 60 {
            if self.holidayFlag {
                adultUnitPrice = 1800
            } else {
                adultUnitPrice = 1500
            }
        } else {
            if self.holidayFlag {
                adultUnitPrice = 1800 + (totalMinutes - 60) / 30 * 500
            } else {
                adultUnitPrice = 1500 + (totalMinutes - 60) / 30 * 500
            }
            if (totalMinutes - 60) % 30 != 0 {
                adultUnitPrice += 500
            }
        }
        
        if self.kidsDayFlag {
            childUnitPrice = adultUnitPrice / 2
        } else {
            childUnitPrice = adultUnitPrice
        }
        
        self.calcAmount = adultUnitPrice * adultCount + childUnitPrice * childCount
        let discountAmountText = discountAmountTextField.text?.replacingOccurrences(of: ",", with: "") ?? "0"
        self.discountAmount = Int(discountAmountText) ?? 0
        let salesAmountText = salesAmountTextField.text?.replacingOccurrences(of: ",", with: "") ?? "0"
        self.salesAmount = Int(salesAmountText) ?? 0
        
        return self.calcAmount - self.discountAmount + self.salesAmount
    }
}

extension LeaveView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // キーボードを閉じる
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 数字のみを許可
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }

        // 現在のテキストを取得
        let currentText = textField.text ?? ""
        // 入力後のテキストを計算
        if let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            // 数値を3桁区切りにフォーマット
            textField.text = formatNumber(updatedText.replacingOccurrences(of: ",", with: ""))
            return false
        }
        return true
    }
}

