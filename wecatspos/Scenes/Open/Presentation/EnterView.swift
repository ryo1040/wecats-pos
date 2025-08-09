//
//  EnterView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/03.
//

import Foundation
import UIKit

protocol EnterDelegate: AnyObject  {
    func checkDayInfo(date: Date)
    func tapEnterSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String)
    func tapEnterCancelButton()
}

public class EnterView: UIView {
    
    let scrollView = UIScrollView()
    
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
    let countAdultTitleLabel = UILabel()
    let countAdultTextField = UITextField()
    let countAdultPickerView = UIPickerView()
    let countChildTitleLabel = UILabel()
    let countChildTextField = UITextField()
    let countChildPickerView = UIPickerView()
    let enterTimeLabel = UILabel()
    let enterTimeTextField = UITextField()
    let enterTimePicker = UIDatePicker()
    let memoTitleLabel = UILabel()
    let memoTextField = UITextField()
    let submitButton = UIButton()
    let cancelButton = UIButton()
    
    // ドラムロールの選択肢
    let repeatPickerData = [(id: 1, name: "新規"), (id: 2, name: "リピーター")]
    let patternPickerData = [(id: 1, name: "家族"), (id: 2, name: "友人"), (id: 3, name: "おひとり"), (id: 4, name: "その他")]
    let countAdultPickerData = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let countChildPickerData = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var selectedRepeatPickerId = 0
    var selectedPatternPickerId = 0
    var selectedCountAdultPickerId = 0
    var selectedCountChildPickerId = 0
    var holidayFlag = false
    var kidsdayFlag = false
    
    weak var delegate: EnterDelegate?
    
    public init() {
        super.init(frame: .zero)
                
        setupViews()

        enterTimePicker.date = Date()
        
        // タップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelPicker))
        tapGesture.cancelsTouchesInView = false // 他のビューのタップイベントも処理する
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEnterInfo() {
        repeatTextField.text = ""
        patternTextField.text = ""
        nameTextField.text = ""
        countAdultTextField.text = "1"
        countChildTextField.text = "0"
        enterTimeTextField.text = "0"
        memoTextField.text = ""
        enterTimePicker.date = Date()
        setupEnterTimeTextField()
        delegate?.checkDayInfo(date: Date())
    }
}

private extension EnterView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)

        scrollView.isScrollEnabled = true
//        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        self.addSubview(scrollView)
        
        pickerBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 半透明のグレー
        pickerBackgroundView.isHidden = true
        self.addSubview(pickerBackgroundView)
        
        errorMessageLabel.text = " "
        errorMessageLabel.textColor = UIColor.red
        scrollView.addSubview(errorMessageLabel)
        
        repeatTitleLabel.text = "新規/リピーター："
        repeatTitleLabel.textColor = UIColor.black
        scrollView.addSubview(repeatTitleLabel)
        
        repeatTextField.keyboardType = .default
        repeatTextField.returnKeyType = .next
        repeatTextField.textColor = UIColor.black
        repeatTextField.backgroundColor = UIColor.white
        repeatTextField.textAlignment = .center
        repeatTextField.borderStyle = .roundedRect
        repeatTextField.layer.borderColor = UIColor.black.cgColor
        repeatTextField.layer.borderWidth = 1.0
        repeatTextField.frame = self.frame
        repeatTextField.tag = 1
        scrollView.addSubview(repeatTextField)
        
        patternTitleLabel.text = "パターン："
        patternTitleLabel.textColor = UIColor.black
        scrollView.addSubview(patternTitleLabel)

        patternTextField.keyboardType = .default
        patternTextField.returnKeyType = .next
        patternTextField.textColor = UIColor.black
        patternTextField.backgroundColor = UIColor.white
        patternTextField.textAlignment = .center
        patternTextField.borderStyle = .roundedRect
        patternTextField.layer.borderColor = UIColor.black.cgColor
        patternTextField.layer.borderWidth = 1.0
        patternTextField.frame = self.frame
        patternTextField.tag = 1
        scrollView.addSubview(patternTextField)
        
        setupRepeatTextField()
        
        nameTitleLabel.text = "氏名（わかれば）："
        nameTitleLabel.textColor = UIColor.black
        scrollView.addSubview(nameTitleLabel)
        
        nameTextField.keyboardType = .default
        nameTextField.returnKeyType = .next
        nameTextField.textColor = UIColor.black
        nameTextField.backgroundColor = UIColor.white
        nameTextField.leftViewMode = .always
        nameTextField.textAlignment = .center
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.frame = self.frame
        nameTextField.tag = 1
        scrollView.addSubview(nameTextField)
        
        setupPatternTextField()
        
        countTitleLabel.text = "人数："
        countTitleLabel.textColor = UIColor.black
        scrollView.addSubview(countTitleLabel)
        
        countAdultTitleLabel.text = "大人："
        countAdultTitleLabel.textColor = UIColor.black
        scrollView.addSubview(countAdultTitleLabel)
        
        countAdultTextField.keyboardType = .default
        countAdultTextField.returnKeyType = .next
        countAdultTextField.textColor = UIColor.black
        countAdultTextField.backgroundColor = UIColor.white
        countAdultTextField.textAlignment = .center
        countAdultTextField.borderStyle = .roundedRect
        countAdultTextField.layer.borderColor = UIColor.black.cgColor
        countAdultTextField.layer.borderWidth = 1.0
        countAdultTextField.frame = self.frame
        countAdultTextField.tag = 2
        scrollView.addSubview(countAdultTextField)
        
        setupCountAdultTextField()
        
        countChildTitleLabel.text = "子供："
        countChildTitleLabel.textColor = UIColor.black
        scrollView.addSubview(countChildTitleLabel)
        
        countChildTextField.keyboardType = .default
        countChildTextField.returnKeyType = .next
        countChildTextField.textColor = UIColor.black
        countChildTextField.backgroundColor = UIColor.white
        countChildTextField.textAlignment = .center
        countChildTextField.borderStyle = .roundedRect
        countChildTextField.layer.borderColor = UIColor.black.cgColor
        countChildTextField.layer.borderWidth = 1.0
        countChildTextField.frame = self.frame
        countChildTextField.tag = 3
        scrollView.addSubview(countChildTextField)
        
        setupCountChildTextField()
        
        enterTimeLabel.text = "入店時間："
        enterTimeLabel.textColor = UIColor.black
        scrollView.addSubview(enterTimeLabel)
        
        enterTimeTextField.keyboardType = .default
        enterTimeTextField.returnKeyType = .next
        enterTimeTextField.textColor = UIColor.black
        enterTimeTextField.backgroundColor = UIColor.white
        enterTimeTextField.textAlignment = .center
        enterTimeTextField.borderStyle = .roundedRect
        enterTimeTextField.layer.borderColor = UIColor.black.cgColor
        enterTimeTextField.layer.borderWidth = 1.0
        enterTimeTextField.frame = self.frame
        enterTimeTextField.tag = 3
        scrollView.addSubview(enterTimeTextField)
        
        setupEnterTimeTextField()

        memoTitleLabel.text = "メモ："
        memoTitleLabel.textColor = UIColor.black
        scrollView.addSubview(memoTitleLabel)
        
        memoTextField.keyboardType = .default
        memoTextField.returnKeyType = .next
        memoTextField.textColor = UIColor.black
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
        
        submitButton.setTitle("入店", for: .normal)
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pickerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        repeatTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        repeatTextField.translatesAutoresizingMaskIntoConstraints = false
        patternTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        patternTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        countTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        countAdultTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        countAdultTextField.translatesAutoresizingMaskIntoConstraints = false
        countChildTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        countChildTextField.translatesAutoresizingMaskIntoConstraints = false
        enterTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        enterTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        memoTextField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            errorMessageLabel.font = UIFont.systemFont(ofSize: 16)
            repeatTitleLabel.font = UIFont.systemFont(ofSize: 16)
            repeatTextField.font = UIFont.systemFont(ofSize: 16)
            patternTitleLabel.font = UIFont.systemFont(ofSize: 16)
            patternTextField.font = UIFont.systemFont(ofSize: 16)
            nameTitleLabel.font = UIFont.systemFont(ofSize: 16)
            nameTextField.font = UIFont.systemFont(ofSize: 16)
            countTitleLabel.font = UIFont.systemFont(ofSize: 16)
            countAdultTitleLabel.font = UIFont.systemFont(ofSize: 16)
            countAdultTextField.font = UIFont.systemFont(ofSize: 16)
            countChildTitleLabel.font = UIFont.systemFont(ofSize: 16)
            countChildTextField.font = UIFont.systemFont(ofSize: 16)
            enterTimeLabel.font = UIFont.systemFont(ofSize: 16)
            enterTimeTextField.font = UIFont.systemFont(ofSize: 16)
            memoTitleLabel.font = UIFont.systemFont(ofSize: 16)
            memoTextField.font = UIFont.systemFont(ofSize: 16)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                scrollView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
                pickerBackgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                pickerBackgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                pickerBackgroundView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                pickerBackgroundView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
                errorMessageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
                errorMessageLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 32),
                repeatTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 8),
                repeatTitleLabel.rightAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 200),
                repeatTextField.topAnchor.constraint(equalTo: repeatTitleLabel.topAnchor),
                repeatTextField.bottomAnchor.constraint(equalTo: repeatTitleLabel.bottomAnchor),
                repeatTextField.leftAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor, constant: 8),
                repeatTextField.widthAnchor.constraint(equalToConstant: 120),
                patternTitleLabel.topAnchor.constraint(equalTo: repeatTitleLabel.bottomAnchor, constant: 8),
                patternTitleLabel.rightAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor),
                patternTextField.topAnchor.constraint(equalTo: patternTitleLabel.topAnchor),
                patternTextField.bottomAnchor.constraint(equalTo: patternTitleLabel.bottomAnchor),
                patternTextField.leftAnchor.constraint(equalTo: patternTitleLabel.rightAnchor, constant: 8),
                patternTextField.widthAnchor.constraint(equalToConstant: 120),
                nameTitleLabel.topAnchor.constraint(equalTo: patternTitleLabel.bottomAnchor, constant: 8),
                nameTitleLabel.rightAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor),
                nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.topAnchor),
                nameTextField.bottomAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor),
                nameTextField.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 8),
                nameTextField.widthAnchor.constraint(equalToConstant: 120),
                countTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
                countTitleLabel.rightAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor),
                countAdultTitleLabel.topAnchor.constraint(equalTo: countTitleLabel.topAnchor),
                countAdultTitleLabel.bottomAnchor.constraint(equalTo: countTitleLabel.bottomAnchor),
                countAdultTitleLabel.leftAnchor.constraint(equalTo: countTitleLabel.rightAnchor, constant: 8),
                countAdultTextField.topAnchor.constraint(equalTo: countAdultTitleLabel.topAnchor),
                countAdultTextField.bottomAnchor.constraint(equalTo: countAdultTitleLabel.bottomAnchor),
                countAdultTextField.leftAnchor.constraint(equalTo: countAdultTitleLabel.rightAnchor),
                countAdultTextField.widthAnchor.constraint(equalToConstant: 40),
                countChildTitleLabel.topAnchor.constraint(equalTo: countAdultTitleLabel.topAnchor),
                countChildTitleLabel.bottomAnchor.constraint(equalTo: countAdultTitleLabel.bottomAnchor),
                countChildTitleLabel.leftAnchor.constraint(equalTo: countAdultTextField.rightAnchor, constant: 40),
                countChildTextField.topAnchor.constraint(equalTo: countChildTitleLabel.topAnchor),
                countChildTextField.bottomAnchor.constraint(equalTo: countChildTitleLabel.bottomAnchor),
                countChildTextField.leftAnchor.constraint(equalTo: countChildTitleLabel.rightAnchor, constant: 8),
                countChildTextField.widthAnchor.constraint(equalToConstant: 40),
                enterTimeLabel.topAnchor.constraint(equalTo: countAdultTitleLabel.bottomAnchor, constant: 8),
                enterTimeLabel.rightAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor),
                enterTimeTextField.topAnchor.constraint(equalTo: enterTimeLabel.topAnchor),
                enterTimeTextField.bottomAnchor.constraint(equalTo: enterTimeLabel.bottomAnchor),
                enterTimeTextField.leftAnchor.constraint(equalTo: enterTimeLabel.rightAnchor, constant: 8),
                enterTimeTextField.widthAnchor.constraint(equalToConstant: 80),
                memoTitleLabel.topAnchor.constraint(equalTo: enterTimeLabel.bottomAnchor, constant: 8),
                memoTitleLabel.rightAnchor.constraint(equalTo: enterTimeLabel.rightAnchor),
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
            ])
        } else { // 通常の画面の場合
            errorMessageLabel.font = UIFont.systemFont(ofSize: 32)
            repeatTitleLabel.font = UIFont.systemFont(ofSize: 32)
            repeatTextField.font = UIFont.systemFont(ofSize: 32)
            patternTitleLabel.font = UIFont.systemFont(ofSize: 32)
            patternTextField.font = UIFont.systemFont(ofSize: 32)
            nameTitleLabel.font = UIFont.systemFont(ofSize: 32)
            nameTextField.font = UIFont.systemFont(ofSize: 32)
            countTitleLabel.font = UIFont.systemFont(ofSize: 32)
            countAdultTitleLabel.font = UIFont.systemFont(ofSize: 32)
            countAdultTextField.font = UIFont.systemFont(ofSize: 32)
            countChildTitleLabel.font = UIFont.systemFont(ofSize: 32)
            countChildTextField.font = UIFont.systemFont(ofSize: 32)
            enterTimeLabel.font = UIFont.systemFont(ofSize: 32)
            enterTimeTextField.font = UIFont.systemFont(ofSize: 32)
            memoTitleLabel.font = UIFont.systemFont(ofSize: 32)
            memoTextField.font = UIFont.systemFont(ofSize: 32)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                scrollView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
                pickerBackgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                pickerBackgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                pickerBackgroundView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
                pickerBackgroundView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
                errorMessageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
                errorMessageLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 64),
                repeatTitleLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 32),
                repeatTitleLabel.rightAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 400),
                repeatTextField.topAnchor.constraint(equalTo: repeatTitleLabel.topAnchor),
                repeatTextField.bottomAnchor.constraint(equalTo: repeatTitleLabel.bottomAnchor),
                repeatTextField.leftAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor, constant: 16),
                repeatTextField.widthAnchor.constraint(equalToConstant: 240),
                patternTitleLabel.topAnchor.constraint(equalTo: repeatTitleLabel.bottomAnchor, constant: 32),
                patternTitleLabel.rightAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor),
                patternTextField.topAnchor.constraint(equalTo: patternTitleLabel.topAnchor),
                patternTextField.bottomAnchor.constraint(equalTo: patternTitleLabel.bottomAnchor),
                patternTextField.leftAnchor.constraint(equalTo: patternTitleLabel.rightAnchor, constant: 16),
                patternTextField.widthAnchor.constraint(equalToConstant: 240),
                nameTitleLabel.topAnchor.constraint(equalTo: patternTitleLabel.bottomAnchor, constant: 32),
                nameTitleLabel.rightAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor),
                nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.topAnchor),
                nameTextField.bottomAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor),
                nameTextField.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 16),
                nameTextField.widthAnchor.constraint(equalToConstant: 240),
                countTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 32),
                countTitleLabel.rightAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor),
                countAdultTitleLabel.topAnchor.constraint(equalTo: countTitleLabel.topAnchor),
                countAdultTitleLabel.bottomAnchor.constraint(equalTo: countTitleLabel.bottomAnchor),
                countAdultTitleLabel.leftAnchor.constraint(equalTo: countTitleLabel.rightAnchor, constant: 16),
                countAdultTextField.topAnchor.constraint(equalTo: countAdultTitleLabel.topAnchor),
                countAdultTextField.bottomAnchor.constraint(equalTo: countAdultTitleLabel.bottomAnchor),
                countAdultTextField.leftAnchor.constraint(equalTo: countAdultTitleLabel.rightAnchor),
                countAdultTextField.widthAnchor.constraint(equalToConstant: 80),
                countChildTitleLabel.topAnchor.constraint(equalTo: countAdultTitleLabel.topAnchor),
                countChildTitleLabel.bottomAnchor.constraint(equalTo: countAdultTitleLabel.bottomAnchor),
                countChildTitleLabel.leftAnchor.constraint(equalTo: countAdultTextField.rightAnchor, constant: 80),
                countChildTextField.topAnchor.constraint(equalTo: countChildTitleLabel.topAnchor),
                countChildTextField.bottomAnchor.constraint(equalTo: countChildTitleLabel.bottomAnchor),
                countChildTextField.leftAnchor.constraint(equalTo: countChildTitleLabel.rightAnchor, constant: 16),
                countChildTextField.widthAnchor.constraint(equalToConstant: 80),
                enterTimeLabel.topAnchor.constraint(equalTo: countAdultTitleLabel.bottomAnchor, constant: 32),
                enterTimeLabel.rightAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor),
                enterTimeTextField.topAnchor.constraint(equalTo: enterTimeLabel.topAnchor),
                enterTimeTextField.bottomAnchor.constraint(equalTo: enterTimeLabel.bottomAnchor),
                enterTimeTextField.leftAnchor.constraint(equalTo: enterTimeLabel.rightAnchor, constant: 16),
                enterTimeTextField.widthAnchor.constraint(equalToConstant: 160),
                memoTitleLabel.topAnchor.constraint(equalTo: enterTimeLabel.bottomAnchor, constant: 32),
                memoTitleLabel.rightAnchor.constraint(equalTo: enterTimeLabel.rightAnchor),
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
        pickerBackgroundView.isHidden = true
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
    
    // ドラムロールのキャンセルボタン（共通）
    @objc private func cancelPicker() {
        self.endEditing(true) // 現在のファーストレスポンダーを閉じる
        pickerBackgroundView.isHidden = true    }
    
    // ドラムロールの背景ビューの操作
    @objc private func showPickerBackground() {
        pickerBackgroundView.isHidden = false // 背景を表示
    }
    private func hidePickerBackground() {
        pickerBackgroundView.isHidden = true // 背景を非表示
    }
    
    // 入店ボタンタップ時のイベント
    @objc func tapSubmitButton() {
        // 入力チェック
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
        
        var repeatFlag = false
        if selectedRepeatPickerId != 1 {
            repeatFlag = true
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        delegate?.tapEnterSubmitButton(id: -1, repeatFlag: repeatFlag, patternId: selectedPatternPickerId, name: nameTextField.text!, date: formatter.string(from: Date()), holidayFlag: holidayFlag, kidsdayFlag: kidsdayFlag, enterTime: enterTimeTextField.text!, countAdult: Int(countAdultTextField.text!)!, countChild: Int(countChildTextField.text!)!, memo: memoTextField.text!)
    }
    
    // キャンセルボタンタップ時のイベント
    @objc func tapCancelButton() {
        repeatTextField.text = ""
        patternTextField.text = ""
        nameTextField.text = ""
        countAdultTextField.text = "0"
        countChildTextField.text = "0"
        enterTimeTextField.text = "0"
        memoTextField.text = ""
        delegate?.tapEnterCancelButton()
    }
}

extension EnterView: UIPickerViewDelegate, UIPickerViewDataSource {
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
