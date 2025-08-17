//
//  EditVisitorInfoView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/11.
//

import Foundation
import UIKit

protocol EditVisitorInfoDelegate: AnyObject  {
    func tapEditVisitorInfoUpdateButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String)
    func tapEditVisitorInfoBackButton()
}

public class EditVisitorInfoView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let pickerBackgroundView = UIView()
    let errorMessageLabel = UILabel()
    let repeatTitleLabel = UILabel()
    let repeatTextField = UITextField()
    let repeatPickerView = UIPickerView()
    let patternTitleLabel = UILabel()
    let patternTextField = UITextField()
    let patternPickerView = UIPickerView()
    let nameTitleLabel = UILabel()
    let nameTextField = UITextField()
    let countTitleLabel = UILabel()
    let countAdultLabel = UILabel()
    let countAdultTextField = UITextField()
    let countAdultPickerView = UIPickerView()
    let countChildLabel = UILabel()
    let countChildTextField = UITextField()
    let countChildPickerView = UIPickerView()
    let countLastLabel = UILabel()
    
    let stayTimeTitleLabel = UILabel()
    let enterTimeTextField = UITextField()
    let enterTimePicker = UIDatePicker()
    let fullWidthTildeLabel = UILabel()
    let leftTimeTextField = UITextField()
    let leftTimePicker = UIDatePicker()
    let stayTimeTextField = UITextField()
    let stayTimeLastLabel = UILabel()
    
    let basicPriceTitleLabel = UILabel()
    let basicPriceTextField = UITextField()
    let basicPriceLastLabel = UILabel()
    let discountAmountTitleLabel = UILabel()
    let discountAmountTextField = UITextField()
    let discountAmountLastLabel = UILabel()
    let gachaAmountTitleLabel = UILabel()
    let gachaAmountTextField = UITextField()
    let gachaAmountLastLabel = UILabel()
    let salesAmountTitleLabel = UILabel()
    let salesAmountTextField = UITextField()
    let salesAmountLastLabel = UILabel()
    let feeTitleLabel = UILabel()
    let feeTextField = UITextField()
    let feeLastLabel = UILabel()
    let memoTitleLabel = UILabel()
    let memoTextField = UITextField()
    
    let updateButton = UIButton()
    let backButton = UIButton()
    
    weak var delegate: EditVisitorInfoDelegate?
    
    let repeatPickerData = [(id: 1, name: "新規"), (id: 2, name: "リピーター")]
    let patternPickerData = [(id: 1, name: "家族"), (id: 2, name: "友人"), (id: 3, name: "おひとり"), (id: 4, name: "その他")]
    let countAdultPickerData = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let countChildPickerData = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var selectedRepeatPickerId = 0
    var selectedPatternPickerId = 0
    var selectedCountAdultPickerId = 0
    var selectedCountChildPickerId = 0
    
    var visitorInfo: GuestInfoModel = GuestInfoModel()
    
    public init() {
        super.init(frame: .zero)
        
        setupViews()
        
        setupKeyboardObservers()
        
        // キーボード以外タップで閉じる
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVisitorInfo(selectGuestInfo: GuestInfoModel){
        self.visitorInfo = selectGuestInfo
        repeatTextField.text = selectGuestInfo.repeatFlag ? "リピーター" : "新規"
        if selectGuestInfo.patternId == 1 {
            patternTextField.text = "家族"
        } else if selectGuestInfo.patternId == 2 {
            patternTextField.text = "友人"
        } else if selectGuestInfo.patternId == 3 {
            patternTextField.text = "おひとり"
        } else {
            patternTextField.text = "その他"
        }
        nameTextField.text = selectGuestInfo.name ?? ""
        countAdultTextField.text = String(selectGuestInfo.adultCount)
        countChildTextField.text = String(selectGuestInfo.childCount)
        enterTimeTextField.text = selectGuestInfo.enterTime
        leftTimeTextField.text = selectGuestInfo.leftTime
        stayTimeTextField.text = String(selectGuestInfo.stayTime)
        basicPriceTextField.text = String(selectGuestInfo.calcAmount)
        discountAmountTextField.text = String(selectGuestInfo.discountAmount)
        gachaAmountTextField.text = String(selectGuestInfo.gachaAmount)
        salesAmountTextField.text = String(selectGuestInfo.salesAmount)
        feeTextField.text = String(selectGuestInfo.totalAmount)
        memoTextField.text = selectGuestInfo.memo ?? ""
    }
    
    private func setupKeyboardObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight

        // 現在編集中のTextFieldを見える位置にスクロール
        if let activeField = findActiveTextField(in: contentView) {
            let fieldFrame = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(fieldFrame, animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    private func findActiveTextField(in view: UIView) -> UITextField? {
        for subview in view.subviews {
            if let textField = subview as? UITextField, textField.isFirstResponder {
                return textField
            } else if let found = findActiveTextField(in: subview) {
                return found
            }
        }
        return nil
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
        hidePickerBackground()
    }
}

private extension EditVisitorInfoView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        
        scrollView.isScrollEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        self.addSubview(scrollView)
        
        contentView.isUserInteractionEnabled = true
        scrollView.addSubview(contentView)
        
        pickerBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 半透明のグレー
        pickerBackgroundView.isHidden = true
        self.addSubview(pickerBackgroundView)
        
        errorMessageLabel.text = " "
        errorMessageLabel.textColor = UIColor.red
        scrollView.addSubview(errorMessageLabel)
        
        // 共通設定用の関数
        func setupTextField(_ textField: UITextField, text: String = "") {
            textField.backgroundColor = UIColor.white
            textField.text = text
            textField.font = UIFont.systemFont(ofSize: 32)
            textField.textColor = UIColor.black
            textField.keyboardType = .default
            textField.returnKeyType = .next
            textField.textAlignment = .center
            textField.borderStyle = .roundedRect
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 1.0
        }
        
        func setupLabel(_ label: UILabel, text: String = "") {
            label.text = text
            label.font = UIFont.systemFont(ofSize: 32)
            label.textColor = UIColor.black
        }

        setupLabel(repeatTitleLabel, text: "新規/リピーター：")
        contentView.addSubview(repeatTitleLabel)
        
        setupTextField(repeatTextField)
        contentView.addSubview(repeatTextField)
        
        setupRepeatTextField()
        
        setupLabel(patternTitleLabel, text: "パターン：")
        contentView.addSubview(patternTitleLabel)
        
        setupTextField(patternTextField)
        contentView.addSubview(patternTextField)
        
        setupPatternTextField()
        
        setupLabel(nameTitleLabel, text: "氏名：")
        contentView.addSubview(nameTitleLabel)

        setupTextField(nameTextField)
        contentView.addSubview(nameTextField)
        
        setupLabel(countTitleLabel, text: "人数：")
        contentView.addSubview(countTitleLabel)
        
        setupLabel(countAdultLabel, text: "大人：")
        contentView.addSubview(countAdultLabel)
        
        setupTextField(countAdultTextField)
        contentView.addSubview(countAdultTextField)
        
        setupCountAdultTextField()

        setupLabel(countChildLabel, text: "人、子ども：")
        contentView.addSubview(countChildLabel)
        
        setupTextField(countChildTextField)
        contentView.addSubview(countChildTextField)
        
        setupCountChildTextField()
        
        setupLabel(countLastLabel, text: "人")
        contentView.addSubview(countLastLabel)
        
        setupLabel(stayTimeTitleLabel, text: "滞在時間：")
        contentView.addSubview(stayTimeTitleLabel)

        setupTextField(enterTimeTextField)
        enterTimeTextField.addTarget(self, action: #selector(setEnterTimePickerInitialValue), for: .editingDidBegin)
        contentView.addSubview(enterTimeTextField)
        
        setupEnterTimeTextField()
        
        setupLabel(fullWidthTildeLabel, text: "〜")
        contentView.addSubview(fullWidthTildeLabel)

        setupTextField(leftTimeTextField)
        leftTimeTextField.addTarget(self, action: #selector(setLeftTimePickerInitialValue), for: .editingDidBegin)
        contentView.addSubview(leftTimeTextField)
        
        setupLeftTimeTextField()
        
        setupTextField(stayTimeTextField, text: "0")
        stayTimeTextField.keyboardType = .numberPad
        contentView.addSubview(stayTimeTextField)
        
        setupLabel(stayTimeLastLabel, text: "分")
        contentView.addSubview(stayTimeLastLabel)
        
        setupLabel(basicPriceTitleLabel, text: "基本料金：")
        contentView.addSubview(basicPriceTitleLabel)
        
        setupTextField(basicPriceTextField)
        basicPriceTextField.keyboardType = .numberPad
        contentView.addSubview(basicPriceTextField)
        
        setupLabel(basicPriceLastLabel, text: "円")
        contentView.addSubview(basicPriceLastLabel)
        
        setupLabel(discountAmountTitleLabel, text: "割引額：")
        contentView.addSubview(discountAmountTitleLabel)
        
        setupTextField(discountAmountTextField)
        discountAmountTextField.keyboardType = .numberPad
        discountAmountTextField.textColor = UIColor.red
        contentView.addSubview(discountAmountTextField)
        
        setupLabel(discountAmountLastLabel, text: "円")
        contentView.addSubview(discountAmountLastLabel)
        
        setupLabel(gachaAmountTitleLabel, text: "ガチャ額：")
        contentView.addSubview(gachaAmountTitleLabel)
        
        setupTextField(gachaAmountTextField)
        gachaAmountTextField.keyboardType = .numberPad
        contentView.addSubview(gachaAmountTextField)
        
        setupLabel(gachaAmountLastLabel, text: "円")
        contentView.addSubview(gachaAmountLastLabel)

        setupLabel(salesAmountTitleLabel, text: "販売額：")
        contentView.addSubview(salesAmountTitleLabel)
        
        setupTextField(salesAmountTextField)
        salesAmountTextField.keyboardType = .numberPad
        contentView.addSubview(salesAmountTextField)
        
        setupLabel(salesAmountLastLabel, text: "円")
        contentView.addSubview(salesAmountLastLabel)
        
        setupLabel(feeTitleLabel, text: "料金：")
        contentView.addSubview(feeTitleLabel)
        
        setupTextField(feeTextField)
        feeTextField.keyboardType = .numberPad
        contentView.addSubview(feeTextField)
        
        setupLabel(feeLastLabel, text: "円")
        contentView.addSubview(feeLastLabel)
        
        setupLabel(memoTitleLabel, text: "メモ：")
        contentView.addSubview(memoTitleLabel)
        
        setupTextField(memoTextField, text: "メモ")
        contentView.addSubview(memoTextField)

        updateButton.setTitle("更新", for: .normal)
        updateButton.setTitleColor(UIColor.black, for: .normal)
        updateButton.backgroundColor = UIColor.white
        updateButton.layer.borderColor = UIColor.black.cgColor
        updateButton.layer.borderWidth = 1.0
        updateButton.layer.cornerRadius = 10
        updateButton.addTarget(self, action: #selector(self.tapEditVisitorInfoUpdateButton), for: .touchUpInside)
        self.addSubview(updateButton)

        backButton.setTitle("戻る", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.backgroundColor = UIColor.white
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderWidth = 1.0
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(self.tapEditVisitorInfoBackButton), for: .touchUpInside)
        self.addSubview(backButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        pickerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        repeatTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        repeatTextField.translatesAutoresizingMaskIntoConstraints = false
        patternTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        patternTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        countTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        countAdultLabel.translatesAutoresizingMaskIntoConstraints = false
        countAdultTextField.translatesAutoresizingMaskIntoConstraints = false
        countChildLabel.translatesAutoresizingMaskIntoConstraints = false
        countChildTextField.translatesAutoresizingMaskIntoConstraints = false
        countLastLabel.translatesAutoresizingMaskIntoConstraints = false
        stayTimeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        enterTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        fullWidthTildeLabel.translatesAutoresizingMaskIntoConstraints = false
        leftTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        stayTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        stayTimeLastLabel.translatesAutoresizingMaskIntoConstraints = false
        basicPriceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        basicPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        basicPriceLastLabel.translatesAutoresizingMaskIntoConstraints = false
        discountAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        discountAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        discountAmountLastLabel.translatesAutoresizingMaskIntoConstraints = false
        gachaAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        gachaAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        gachaAmountLastLabel.translatesAutoresizingMaskIntoConstraints = false
        salesAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        salesAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        salesAmountLastLabel.translatesAutoresizingMaskIntoConstraints = false
        feeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        feeTextField.translatesAutoresizingMaskIntoConstraints = false
        feeLastLabel.translatesAutoresizingMaskIntoConstraints = false
        memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        memoTextField.translatesAutoresizingMaskIntoConstraints = false
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            pickerBackgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            pickerBackgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            pickerBackgroundView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            pickerBackgroundView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            
            errorMessageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            errorMessageLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 32),
            
            repeatTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 8),
            repeatTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 64),
            repeatTextField.centerYAnchor.constraint(equalTo: repeatTitleLabel.centerYAnchor),
            repeatTextField.leftAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor, constant: 24),
            repeatTextField.widthAnchor.constraint(equalToConstant: 200),
            
            patternTitleLabel.centerYAnchor.constraint(equalTo: repeatTitleLabel.centerYAnchor),
            patternTitleLabel.leftAnchor.constraint(equalTo: contentView.centerXAnchor),
            patternTextField.centerYAnchor.constraint(equalTo: patternTitleLabel.centerYAnchor),
            patternTextField.leftAnchor.constraint(equalTo: patternTitleLabel.rightAnchor, constant: 24),
            patternTextField.widthAnchor.constraint(equalToConstant: 200),
            
            nameTitleLabel.topAnchor.constraint(equalTo: repeatTitleLabel.bottomAnchor, constant: 24),
            nameTitleLabel.rightAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: nameTitleLabel.centerYAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 24),
            nameTextField.widthAnchor.constraint(equalToConstant: 400),
            
            countTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 24),
            countTitleLabel.rightAnchor.constraint(equalTo: nameTitleLabel.rightAnchor),
            countAdultLabel.centerYAnchor.constraint(equalTo: countTitleLabel.centerYAnchor),
            countAdultLabel.leftAnchor.constraint(equalTo: countTitleLabel.rightAnchor, constant: 24),
            countAdultTextField.centerYAnchor.constraint(equalTo: countTitleLabel.centerYAnchor),
            countAdultTextField.leftAnchor.constraint(equalTo: countAdultLabel.rightAnchor),
            countAdultTextField.widthAnchor.constraint(equalToConstant: 80),
            countChildLabel.centerYAnchor.constraint(equalTo: countTitleLabel.centerYAnchor),
            countChildLabel.leftAnchor.constraint(equalTo: countAdultTextField.rightAnchor, constant: 8),
            countChildTextField.centerYAnchor.constraint(equalTo: countTitleLabel.centerYAnchor),
            countChildTextField.leftAnchor.constraint(equalTo: countChildLabel.rightAnchor),
            countChildTextField.widthAnchor.constraint(equalToConstant: 80),
            countLastLabel.centerYAnchor.constraint(equalTo: countTitleLabel.centerYAnchor),
            countLastLabel.leftAnchor.constraint(equalTo: countChildTextField.rightAnchor, constant: 8),
            
            stayTimeTitleLabel.topAnchor.constraint(equalTo: countTitleLabel.bottomAnchor, constant: 24),
            stayTimeTitleLabel.rightAnchor.constraint(equalTo: countTitleLabel.rightAnchor),
            enterTimeTextField.centerYAnchor.constraint(equalTo: stayTimeTitleLabel.centerYAnchor),
            enterTimeTextField.leftAnchor.constraint(equalTo: stayTimeTitleLabel.rightAnchor, constant: 24),
            enterTimeTextField.widthAnchor.constraint(equalToConstant: 150),
            fullWidthTildeLabel.centerYAnchor.constraint(equalTo: stayTimeTitleLabel.centerYAnchor),
            fullWidthTildeLabel.leftAnchor.constraint(equalTo: enterTimeTextField.rightAnchor, constant: 8),
            leftTimeTextField.centerYAnchor.constraint(equalTo: stayTimeTitleLabel.centerYAnchor),
            leftTimeTextField.leftAnchor.constraint(equalTo: fullWidthTildeLabel.rightAnchor, constant: 8),
            leftTimeTextField.widthAnchor.constraint(equalToConstant: 150),
            stayTimeTextField.centerYAnchor.constraint(equalTo: stayTimeTitleLabel.centerYAnchor),
            stayTimeTextField.leftAnchor.constraint(equalTo: leftTimeTextField.rightAnchor, constant: 24),
            stayTimeTextField.widthAnchor.constraint(equalToConstant: 120),
            stayTimeLastLabel.centerYAnchor.constraint(equalTo: stayTimeTitleLabel.centerYAnchor),
            stayTimeLastLabel.leftAnchor.constraint(equalTo: stayTimeTextField.rightAnchor, constant: 24),
            
            basicPriceTitleLabel.topAnchor.constraint(equalTo: enterTimeTextField.bottomAnchor, constant: 24),
            basicPriceTitleLabel.rightAnchor.constraint(equalTo: stayTimeTitleLabel.rightAnchor),
            basicPriceTextField.centerYAnchor.constraint(equalTo: basicPriceTitleLabel.centerYAnchor),
            basicPriceTextField.leftAnchor.constraint(equalTo: basicPriceTitleLabel.rightAnchor, constant: 24),
            basicPriceTextField.widthAnchor.constraint(equalToConstant: 150),
            basicPriceLastLabel.centerYAnchor.constraint(equalTo: basicPriceTitleLabel.centerYAnchor),
            basicPriceLastLabel.leftAnchor.constraint(equalTo: basicPriceTextField.rightAnchor, constant: 24),
            discountAmountTitleLabel.centerYAnchor.constraint(equalTo: basicPriceTitleLabel.centerYAnchor),
            discountAmountTitleLabel.leftAnchor.constraint(equalTo: contentView.centerXAnchor),
            discountAmountTextField.centerYAnchor.constraint(equalTo: discountAmountTitleLabel.centerYAnchor),
            discountAmountTextField.leftAnchor.constraint(equalTo: discountAmountTitleLabel.rightAnchor, constant: 24),
            discountAmountTextField.widthAnchor.constraint(equalToConstant: 150),
            discountAmountLastLabel.centerYAnchor.constraint(equalTo: discountAmountTitleLabel.centerYAnchor),
            discountAmountLastLabel.leftAnchor.constraint(equalTo: discountAmountTextField.rightAnchor, constant: 24),
            
            gachaAmountTitleLabel.topAnchor.constraint(equalTo: basicPriceTitleLabel.bottomAnchor, constant: 24),
            gachaAmountTitleLabel.rightAnchor.constraint(equalTo: basicPriceTitleLabel.rightAnchor),
            gachaAmountTextField.centerYAnchor.constraint(equalTo: gachaAmountTitleLabel.centerYAnchor),
            gachaAmountTextField.leftAnchor.constraint(equalTo: gachaAmountTitleLabel.rightAnchor, constant: 24),
            gachaAmountTextField.widthAnchor.constraint(equalToConstant: 150),
            gachaAmountLastLabel.centerYAnchor.constraint(equalTo: gachaAmountTitleLabel.centerYAnchor),
            gachaAmountLastLabel.leftAnchor.constraint(equalTo: gachaAmountTextField.rightAnchor, constant: 24),
            salesAmountTitleLabel.centerYAnchor.constraint(equalTo: gachaAmountTitleLabel.centerYAnchor),
            salesAmountTitleLabel.leftAnchor.constraint(equalTo: contentView.centerXAnchor),
            salesAmountTextField.centerYAnchor.constraint(equalTo: salesAmountTitleLabel.centerYAnchor),
            salesAmountTextField.leftAnchor.constraint(equalTo: salesAmountTitleLabel.rightAnchor, constant: 24),
            salesAmountTextField.widthAnchor.constraint(equalToConstant: 150),
            salesAmountLastLabel.centerYAnchor.constraint(equalTo: salesAmountTitleLabel.centerYAnchor),
            salesAmountLastLabel.leftAnchor.constraint(equalTo: salesAmountTextField.rightAnchor, constant: 24),
            
            feeTitleLabel.topAnchor.constraint(equalTo: gachaAmountTitleLabel.bottomAnchor, constant: 24),
            feeTitleLabel.rightAnchor.constraint(equalTo: gachaAmountTitleLabel.rightAnchor),
            feeTextField.centerYAnchor.constraint(equalTo: feeTitleLabel.centerYAnchor),
            feeTextField.leftAnchor.constraint(equalTo: feeTitleLabel.rightAnchor, constant: 24),
            feeTextField.widthAnchor.constraint(equalToConstant: 150),
            feeLastLabel.centerYAnchor.constraint(equalTo: feeTitleLabel.centerYAnchor),
            feeLastLabel.leftAnchor.constraint(equalTo: feeTextField.rightAnchor, constant: 24),
            
            memoTitleLabel.topAnchor.constraint(equalTo: feeTitleLabel.bottomAnchor, constant: 24),
            memoTitleLabel.rightAnchor.constraint(equalTo: feeTitleLabel.rightAnchor),
            memoTextField.centerYAnchor.constraint(equalTo: memoTitleLabel.centerYAnchor),
            memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 24),
            memoTextField.widthAnchor.constraint(equalToConstant: 600),
            memoTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

            updateButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            updateButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
            updateButton.heightAnchor.constraint(equalToConstant: 48),
            updateButton.widthAnchor.constraint(equalToConstant: 160),
            
            backButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            backButton.rightAnchor.constraint(equalTo: updateButton.leftAnchor, constant: -32),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func setupRepeatTextField() {
        // UIPickerViewの設定
        repeatPickerView.delegate = self
        repeatPickerView.dataSource = self
        repeatTextField.inputView = repeatPickerView
        
        // ツールバーを追加
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelPicker))
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneRepeatPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        repeatTextField.inputAccessoryView = toolbar
        
        // ドラムロールを開くときに背景を表示
        repeatTextField.addTarget(self, action: #selector(showPickerBackground), for: .editingDidBegin)
    }
    
    // ドラムロールの完了ボタン（新規/リピーター）
    @objc private func doneRepeatPicker() {
        // 選択された値を確定
        let selectedRow = repeatPickerView.selectedRow(inComponent: 0)
        selectedRepeatPickerId = repeatPickerData[selectedRow].id
        repeatTextField.text = repeatPickerData[selectedRow].name
        repeatTextField.resignFirstResponder() // ドラムロールを閉じる
        hidePickerBackground()
    }
    
    private func setupPatternTextField() {
        // UIPickerViewの設定
        patternPickerView.delegate = self
        patternPickerView.dataSource = self
        patternTextField.inputView = patternPickerView
        
        // ツールバーを追加
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelPicker))
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(donePatternPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        patternTextField.inputAccessoryView = toolbar
        
        // ドラムロールを開くときに背景を表示
        patternTextField.addTarget(self, action: #selector(showPickerBackground), for: .editingDidBegin)
    }
    
    // ドラムロールの完了ボタン（パターン）
    @objc private func donePatternPicker() {
        // 選択された値を確定
        let selectedRow = patternPickerView.selectedRow(inComponent: 0)
        selectedPatternPickerId = patternPickerData[selectedRow].id
        patternTextField.text = patternPickerData[selectedRow].name
        patternTextField.resignFirstResponder() // ドラムロールを閉じる
        hidePickerBackground()
    }
    
    private func setupCountAdultTextField() {
        // UIPickerViewの設定
        countAdultPickerView.delegate = self
        countAdultPickerView.dataSource = self
        countAdultTextField.inputView = countAdultPickerView
        
        // ツールバーを追加
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelPicker))
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneCountAdultPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        countAdultTextField.inputAccessoryView = toolbar
        
        // ドラムロールを開くときに背景を表示
        countAdultTextField.addTarget(self, action: #selector(showCountAdultPickerWithInitialValue), for: .editingDidBegin)
    }
    
    @objc private func showCountAdultPickerWithInitialValue() {
        // textFieldの値に一致する行を選択
        if let text = countAdultTextField.text,
           let index = countAdultPickerData.firstIndex(of: text) {
            countAdultPickerView.selectRow(index, inComponent: 0, animated: false)
        }
        showPickerBackground()
    }

    // ドラムロールの完了ボタン（人数：大人）
    @objc private func doneCountAdultPicker() {
        // 選択された値を確定
        let selectedRow = countAdultPickerView.selectedRow(inComponent: 0)
        countAdultTextField.text = countAdultPickerData[selectedRow]
        countAdultTextField.resignFirstResponder() // ドラムロールを閉じる
        hidePickerBackground()
    }
    
    private func setupCountChildTextField() {
        // UIPickerViewの設定
        countChildPickerView.delegate = self
        countChildPickerView.dataSource = self
        countChildTextField.inputView = countChildPickerView
        
        // ツールバーを追加
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelPicker))
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneCountChildPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        countChildTextField.inputAccessoryView = toolbar
        
        // ドラムロールを開くときに背景を表示
        countChildTextField.addTarget(self, action: #selector(showCountChildPickerWithInitialValue), for: .editingDidBegin)
    }
    
    @objc private func showCountChildPickerWithInitialValue() {
        // textFieldの値に一致する行を選択
        if let text = countChildTextField.text,
           let index = countChildPickerData.firstIndex(of: text) {
            countChildPickerView.selectRow(index, inComponent: 0, animated: false)
        }
        showPickerBackground()
    }

    // ドラムロールの完了ボタン（人数：子供）
    @objc private func doneCountChildPicker() {
        // 選択された値を確定
        let selectedRow = countChildPickerView.selectedRow(inComponent: 0)
        countChildTextField.text = countChildPickerData[selectedRow]
        countChildTextField.resignFirstResponder() // ドラムロールを閉じる
        hidePickerBackground()
    }
    
    // ドラムロールのキャンセルボタン（共通）
    @objc private func cancelPicker() {
        self.endEditing(true) // 現在のファーストレスポンダーを閉じる
        hidePickerBackground()
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

    @objc private func setEnterTimePickerInitialValue() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let text = enterTimeTextField.text,
        let date = formatter.date(from: text) {
            enterTimePicker.setDate(date, animated: false)
        }
        showPickerBackground()
    }

    @objc private func doneEnterTimePicker() {
        // 選択された時刻をテキストフィールドに表示
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 時刻フォーマット
        enterTimeTextField.text = formatter.string(from: enterTimePicker.date)
        enterTimeTextField.resignFirstResponder() // ドラムロールを閉じる
        hidePickerBackground()
    }

    @objc private func cancelEnterTimePicker() {
        enterTimeTextField.resignFirstResponder() // ドラムロールを閉じる
        hidePickerBackground()
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

    @objc private func setLeftTimePickerInitialValue() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let text = leftTimeTextField.text,
        let date = formatter.date(from: text) {
            leftTimePicker.setDate(date, animated: false)
        }
        showPickerBackground()
    }

    @objc private func doneLeftTimePicker() {
        // 選択された時刻をテキストフィールドに表示
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 時刻フォーマット
        leftTimeTextField.text = formatter.string(from: leftTimePicker.date)
        leftTimeTextField.resignFirstResponder() // ドラムロールを閉じる
        hidePickerBackground()
    }

    @objc private func cancelLeftTimePicker() {
        leftTimeTextField.resignFirstResponder() // ドラムロールを閉じる
        hidePickerBackground()
    }

    // ドラムロールの背景ビューの操作
    @objc private func showPickerBackground() {
        pickerBackgroundView.isHidden = false // 背景を表示
    }
    private func hidePickerBackground() {
        pickerBackgroundView.isHidden = true // 背景を非表示
    }
    
    // 更新ボタンタップ時のイベント
    @objc func tapEditVisitorInfoUpdateButton() {
        if repeatTextField.text == "" {
            errorMessageLabel.text = "新規/リピーターを選択してください"
            return
        }
        if patternTextField.text == "" {
            errorMessageLabel.text = "パターンを選択してください"
            return
        }
        if countAdultTextField.text == "" {
            errorMessageLabel.text = "大人の人数を選択してください"
            return
        }
        if countChildTextField.text == "" {
            errorMessageLabel.text = "子供の人数を選択してください"
            return
        }
        if countAdultTextField.text == "0" && countChildTextField.text == "0" {
            errorMessageLabel.text = "人数を選択してください"
            return
        }
        if enterTimeTextField.text == "" {
            errorMessageLabel.text = "入店時間を選択してください"
            return
        }
        if leftTimeTextField.text == "" {
            errorMessageLabel.text = "退店時間を選択してください"
            return
        }
        if stayTimeTextField.text == "" {
            errorMessageLabel.text = "滞在時間を選択してください"
            return
        }
        if basicPriceTextField.text == "" {
            errorMessageLabel.text = "基本料金を入力してください"
            return
        }
        if discountAmountTextField.text == "" {
            errorMessageLabel.text = "割引額を入力してください"
            return
        }
        if salesAmountTextField.text == "" {
            errorMessageLabel.text = "販売額を入力してください"
            return
        }
        if feeTextField.text == "" {
            errorMessageLabel.text = "料金を入力してください"
            return
        }
        
        var repeatFlag = false
        if selectedRepeatPickerId != 1 {
            repeatFlag = true
        }
        
        delegate?.tapEditVisitorInfoUpdateButton(id: visitorInfo.id, repeatFlag: repeatFlag, patternId: selectedPatternPickerId, name: nameTextField.text ?? "", date: visitorInfo.date, holidayFlag: visitorInfo.holidayFlag, kidsDayFlag: visitorInfo.kidsdayFlag, adultCount: Int(countAdultTextField.text!)!, childCount: Int(countChildTextField.text!)!, enterTime: enterTimeTextField.text!, leftTime: leftTimeTextField.text!, stayTime: Int(stayTimeTextField.text!)!, calcAmount: Int(basicPriceTextField.text!)!, discountAmount: Int(discountAmountTextField.text!)!, salesAmount: Int(salesAmountTextField.text!)!, gachaAmount: Int(gachaAmountTextField.text!)!, totalAmount: Int(feeTextField.text!)!, memo: memoTextField.text ?? "")
    }
    
    // キャンセルボタンタップ時のイベント
    @objc func tapEditVisitorInfoBackButton() {
        delegate?.tapEditVisitorInfoBackButton()
    }

    func commaSeparateThreeDigits(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}

extension EditVisitorInfoView: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // 列数
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == repeatPickerView {
            return repeatPickerData.count // repeatPickerViewの選択肢の数
        } else if pickerView == patternPickerView {
            return patternPickerData.count // patternPickerViewの選択肢の数
        } else if pickerView == countAdultPickerView {
            return countAdultPickerData.count // countAdultPickerViewの選択肢の数
        } else if pickerView == countChildPickerView {
            return countChildPickerData.count // countChildPickerViewの選択肢の数
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == repeatPickerView {
            return repeatPickerData[row].name // repeatPickerViewの各行のタイトル
        } else if pickerView == patternPickerView {
            return patternPickerData[row].name // patternPickerViewの各行のタイトル
        } else if pickerView == countAdultPickerView {
            return countAdultPickerData[row] // countAdultPickerViewの各行のタイトル
        } else if pickerView == countChildPickerView {
            return countChildPickerData[row] // countChildPickerViewの各行のタイトル
        }
        return nil
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == repeatPickerView {
            selectedRepeatPickerId = repeatPickerData[row].id
            repeatTextField.text = repeatPickerData[row].name // repeatPickerViewの選択された値を表示
        } else if pickerView == patternPickerView {
            selectedPatternPickerId = patternPickerData[row].id
            patternTextField.text = patternPickerData[row].name // patternPickerViewの選択された値を表示
        } else if pickerView == countAdultPickerView {
            countAdultTextField.text = countAdultPickerData[row] // countAdultPickerViewの選択された値を表示
        } else if pickerView == countChildPickerView {
            countChildTextField.text = countChildPickerData[row] // countChildPickerViewの選択された値を表示
        }
    }
}
