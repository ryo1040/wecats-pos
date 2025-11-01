//
//  DenominationView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/20.
//

import Foundation
import UIKit

protocol DenominationDelegate: AnyObject  {
    func tapDenominationSubmitButton(date: String, tenThousandYenCount: Int, fiveThousandYenCount: Int, twoThousandYenCount: Int, oneThousandYenCount: Int, fiveHundredYenCount: Int, oneHundredYenCount: Int, fiftyYenCount: Int, tenYenCount: Int, fiveYenCount: Int, oneYenCount: Int, exportAmount: Int, ticketAmount: Int, totalAmount: Int, memo: String)
    func tapDenominationCancelButton()
    func checkTotalAmount(date: String, totalAmount: Int, ticketAmount: Int, exportAmount: Int)
}

public class DenominationView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // キーボード対応用のプロパティ
    var activeTextField: UITextField?
    var originalContentInset: UIEdgeInsets = .zero
    var originalScrollIndicatorInsets: UIEdgeInsets = .zero
    var originalContentOffset: CGPoint = .zero
    var keyboardIsVisible: Bool = false
    
    let errorMessageLabel = UILabel()
    let dateTitleLabel = UILabel()
    let dateLabel = UILabel()
    let dailySalesTitleLabel = UILabel()
    let dailySalesLabel = UILabel()
    let tenThousandYenTitleLabel = UILabel()
    let tenThousandYenCountTextField = UITextField()
    let tenThousandYenMaiLabel = UILabel()
    let tenThousandYenLabel = UILabel()
    let fiveThousandYenTitleLabel = UILabel()
    let fiveThousandYenCountTextField = UITextField()
    let fiveThousandYenMaiLabel = UILabel()
    let fiveThousandYenLabel = UILabel()
    let twoThousandYenTitleLabel = UILabel()
    let twoThousandYenCountTextField = UITextField()
    let twoThousandYenMaiLabel = UILabel()
    let twoThousandYenLabel = UILabel()
    let oneThousandYenTitleLabel = UILabel()
    let oneThousandYenCountTextField = UITextField()
    let oneThousandYenMaiLabel = UILabel()
    let oneThousandYenLabel = UILabel()
    let fiveHundredYenTitleLabel = UILabel()
    let fiveHundredYenCountTextField = UITextField()
    let fiveHundredYenMaiLabel = UILabel()
    let fiveHundredYenLabel = UILabel()
    let oneHundredYenTitleLabel = UILabel()
    let oneHundredYenCountTextField = UITextField()
    let oneHundredYenMaiLabel = UILabel()
    let oneHundredYenLabel = UILabel()
    let fiftyYenTitleLabel = UILabel()
    let fiftyYenCountTextField = UITextField()
    let fiftyYenMaiLabel = UILabel()
    let fiftyYenLabel = UILabel()
    let tenYenTitleLabel = UILabel()
    let tenYenCountTextField = UITextField()
    let tenYenMaiLabel = UILabel()
    let tenYenLabel = UILabel()
    let fiveYenTitleLabel = UILabel()
    let fiveYenCountTextField = UITextField()
    let fiveYenMaiLabel = UILabel()
    let fiveYenLabel = UILabel()
    let oneYenTitleLabel = UILabel()
    let oneYenCountTextField = UITextField()
    let oneYenMaiLabel = UILabel()
    let oneYenLabel = UILabel()
    let exportAmountTitleLabel = UILabel()
    let exportAmountTextField = UITextField()
    let exportAmountYenLabel = UILabel()
    let ticketTitleLabel = UILabel()
    let ticketYenTextField = UITextField()
    let ticketYenLabel = UILabel()
    let totalYenAmountLabel = UILabel()
    let totalAmountLabel = UILabel()
    let calcButton = UIButton()
    let memoTitleLabel = UILabel()
    let memoTextField = UITextField()
    let submitButton = UIButton()
    let cancelButton = UIButton()
    
    private var currentConstraints: [NSLayoutConstraint] = []
    var screenWidth = UIScreen.main.bounds.width
    // 画面向きを判定するプロパティ
    private var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
    var editId = -1
    
    weak var delegate: DenominationDelegate?
    
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
    
    func setInitialDenomination() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = formatter.string(from: Date())
        dailySalesLabel.text = ""
        tenThousandYenCountTextField.text = "0"
        fiveThousandYenCountTextField.text = "0"
        twoThousandYenCountTextField.text = "0"
        oneThousandYenCountTextField.text = "0"
        fiveHundredYenCountTextField.text = "0"
        oneHundredYenCountTextField.text = "0"
        fiftyYenCountTextField.text = "0"
        tenYenCountTextField.text = "0"
        fiveYenCountTextField.text = "0"
        oneYenCountTextField.text = "0"
        ticketYenTextField.text = "0"
        exportAmountTextField.text = "0"
        memoTextField.text = ""
        calcButton.isHidden = false
        submitButton.isHidden = false
    }
    
    func setDenomination(selectedDenomination: DenominationModel, enable: Bool) {
        tenThousandYenCountTextField.isEnabled = enable
        fiveThousandYenCountTextField.isEnabled = enable
        twoThousandYenCountTextField.isEnabled = enable
        oneThousandYenCountTextField.isEnabled = enable
        fiveHundredYenCountTextField.isEnabled = enable
        oneHundredYenCountTextField.isEnabled = enable
        fiftyYenCountTextField.isEnabled = enable
        tenYenCountTextField.isEnabled = enable
        fiveYenCountTextField.isEnabled = enable
        oneYenCountTextField.isEnabled = enable
        ticketYenTextField.isEnabled = enable
        exportAmountTextField.isEnabled = enable
        memoTextField.isEnabled = enable
        calcButton.isHidden = !enable
        submitButton.isHidden = !enable
        
        dateLabel.text = selectedDenomination.date
        dailySalesLabel.text = commaSeparateThreeDigits(selectedDenomination.dailySalesAmount) + "円"
        tenThousandYenCountTextField.text = String(selectedDenomination.tenThousandYenCount)
        tenThousandYenLabel.text = commaSeparateThreeDigits(selectedDenomination.tenThousandYenCount * 10000) + "円"
        fiveThousandYenCountTextField.text = String(selectedDenomination.fiveThousandYenCount)
        fiveThousandYenLabel.text = commaSeparateThreeDigits(selectedDenomination.fiveThousandYenCount * 5000) + "円"
        twoThousandYenCountTextField.text = String(selectedDenomination.twoThousandYenCount)
        twoThousandYenLabel.text = commaSeparateThreeDigits(selectedDenomination.twoThousandYenCount * 2000) + "円"
        oneThousandYenCountTextField.text = String(selectedDenomination.oneThousandYenCount)
        oneThousandYenLabel.text = commaSeparateThreeDigits(selectedDenomination.oneThousandYenCount * 1000) + "円"
        fiveHundredYenCountTextField.text = String(selectedDenomination.fiveHundredYenCount)
        fiveHundredYenLabel.text = commaSeparateThreeDigits(selectedDenomination.fiveHundredYenCount * 500) + "円"
        oneHundredYenCountTextField.text = String(selectedDenomination.oneHundredYenCount)
        oneHundredYenLabel.text = commaSeparateThreeDigits(selectedDenomination.oneHundredYenCount * 100) + "円"
        fiftyYenCountTextField.text = String(selectedDenomination.fiftyYenCount)
        fiftyYenLabel.text = commaSeparateThreeDigits(selectedDenomination.fiftyYenCount * 50) + "円"
        tenYenCountTextField.text = String(selectedDenomination.tenYenCount)
        tenYenLabel.text = commaSeparateThreeDigits(selectedDenomination.tenYenCount * 10) + "円"
        fiveYenCountTextField.text = String(selectedDenomination.fiveYenCount)
        fiveYenLabel.text = commaSeparateThreeDigits(selectedDenomination.fiveYenCount * 5) + "円"
        oneYenCountTextField.text = String(selectedDenomination.oneYenCount)
        oneYenLabel.text = commaSeparateThreeDigits(selectedDenomination.oneYenCount * 1) + "円"
        
        ticketYenTextField.text = String(selectedDenomination.ticketCount)
        exportAmountTextField.text = String(selectedDenomination.exportAmount)
        
        totalAmountLabel.text = commaSeparateThreeDigits(selectedDenomination.totalAmount) + "円"
        memoTextField.text = selectedDenomination.memo
    }
    
    func changeSubmitButtonEnabled(enabled: Bool) {
        submitButton.isEnabled = enabled
        if enabled {
            submitButton.backgroundColor = UIColor.white
        } else {
            submitButton.backgroundColor = UIColor.lightGray
        }
    }
    
    /// スクロール位置を初期化するメソッド
    public func resetScrollPosition() {
        scrollView.setContentOffset(CGPoint.zero, animated: false)
    }
}

private extension DenominationView {
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
        
        setupLabel(dateTitleLabel, text: "日付：")
        contentView.addSubview(dateTitleLabel)
        
        setupLabel(dateLabel, text: "")
        contentView.addSubview(dateLabel)
        
        setupLabel(dailySalesTitleLabel, text: "当日売上：")
        contentView.addSubview(dailySalesTitleLabel)
        
        setupLabel(dailySalesLabel, text: "")
        contentView.addSubview(dailySalesLabel)
        
        setupLabel(tenThousandYenTitleLabel, text: "1万円札：")
        contentView.addSubview(tenThousandYenTitleLabel)
        
        setupTextField(tenThousandYenCountTextField, text: "")
        contentView.addSubview(tenThousandYenCountTextField)
        
        setupLabel(tenThousandYenMaiLabel, text: "枚")
        contentView.addSubview(tenThousandYenMaiLabel)
        
        setupLabel(tenThousandYenLabel, text: "0円")
        contentView.addSubview(tenThousandYenLabel)
        
        setupLabel(fiveThousandYenTitleLabel, text: "5千円札：")
        contentView.addSubview(fiveThousandYenTitleLabel)
        
        setupTextField(fiveThousandYenCountTextField, text: "")
        contentView.addSubview(fiveThousandYenCountTextField)
        
        setupLabel(fiveThousandYenMaiLabel, text: "枚")
        contentView.addSubview(fiveThousandYenMaiLabel)
        
        setupLabel(fiveThousandYenLabel, text: "0円")
        contentView.addSubview(fiveThousandYenLabel)
        
        setupLabel(twoThousandYenTitleLabel, text: "2千円札：")
        contentView.addSubview(twoThousandYenTitleLabel)
        
        setupTextField(twoThousandYenCountTextField, text: "")
        contentView.addSubview(twoThousandYenCountTextField)
        
        setupLabel(twoThousandYenMaiLabel, text: "枚")
        contentView.addSubview(twoThousandYenMaiLabel)
        
        setupLabel(twoThousandYenLabel, text: "0円")
        contentView.addSubview(twoThousandYenLabel)
        
        setupLabel(oneThousandYenTitleLabel, text: "千円札：")
        contentView.addSubview(oneThousandYenTitleLabel)
        
        setupTextField(oneThousandYenCountTextField, text: "")
        contentView.addSubview(oneThousandYenCountTextField)
        
        setupLabel(oneThousandYenMaiLabel, text: "枚")
        contentView.addSubview(oneThousandYenMaiLabel)
        
        setupLabel(oneThousandYenLabel, text: "0円")
        contentView.addSubview(oneThousandYenLabel)
        
        setupLabel(fiveHundredYenTitleLabel, text: "500円玉：")
        contentView.addSubview(fiveHundredYenTitleLabel)
        
        setupTextField(fiveHundredYenCountTextField, text: "")
        contentView.addSubview(fiveHundredYenCountTextField)
        
        setupLabel(fiveHundredYenMaiLabel, text: "枚")
        contentView.addSubview(fiveHundredYenMaiLabel)
        
        setupLabel(fiveHundredYenLabel, text: "0円")
        contentView.addSubview(fiveHundredYenLabel)
        
        setupLabel(oneHundredYenTitleLabel, text: "100円玉：")
        contentView.addSubview(oneHundredYenTitleLabel)
        
        setupTextField(oneHundredYenCountTextField, text: "")
        contentView.addSubview(oneHundredYenCountTextField)
        
        setupLabel(oneHundredYenMaiLabel, text: "枚")
        contentView.addSubview(oneHundredYenMaiLabel)
        
        setupLabel(oneHundredYenLabel, text: "0円")
        contentView.addSubview(oneHundredYenLabel)
        
        setupLabel(fiftyYenTitleLabel, text: "50円玉：")
        contentView.addSubview(fiftyYenTitleLabel)
        
        setupTextField(fiftyYenCountTextField, text: "")
        contentView.addSubview(fiftyYenCountTextField)
        
        setupLabel(fiftyYenMaiLabel, text: "枚")
        contentView.addSubview(fiftyYenMaiLabel)
        
        setupLabel(fiftyYenLabel, text: "0円")
        contentView.addSubview(fiftyYenLabel)
        
        setupLabel(tenYenTitleLabel, text: "10円玉：")
        contentView.addSubview(tenYenTitleLabel)
        
        setupTextField(tenYenCountTextField, text: "")
        contentView.addSubview(tenYenCountTextField)
        
        setupLabel(tenYenMaiLabel, text: "枚")
        contentView.addSubview(tenYenMaiLabel)
        
        setupLabel(tenYenLabel, text: "0円")
        contentView.addSubview(tenYenLabel)
        
        setupLabel(fiveYenTitleLabel, text: "5円玉：")
        contentView.addSubview(fiveYenTitleLabel)
        
        setupTextField(fiveYenCountTextField, text: "")
        contentView.addSubview(fiveYenCountTextField)
        
        setupLabel(fiveYenMaiLabel, text: "枚")
        contentView.addSubview(fiveYenMaiLabel)
        
        setupLabel(fiveYenLabel, text: "0円")
        contentView.addSubview(fiveYenLabel)
        
        setupLabel(oneYenTitleLabel, text: "1円玉：")
        contentView.addSubview(oneYenTitleLabel)
        
        setupTextField(oneYenCountTextField, text: "")
        contentView.addSubview(oneYenCountTextField)
        
        setupLabel(oneYenMaiLabel, text: "枚")
        contentView.addSubview(oneYenMaiLabel)
        
        setupLabel(oneYenLabel, text: "0円")
        contentView.addSubview(oneYenLabel)
        
        setupLabel(ticketTitleLabel, text: "応援券など：")
        contentView.addSubview(ticketTitleLabel)
        
        setupTextField(ticketYenTextField, text: "0")
        contentView.addSubview(ticketYenTextField)
        
        setupLabel(ticketYenLabel, text: "円")
        contentView.addSubview(ticketYenLabel)
    
        setupLabel(exportAmountTitleLabel, text: "持ち帰り額：")
        contentView.addSubview(exportAmountTitleLabel)
        
        setupTextField(exportAmountTextField, text: "")
        contentView.addSubview(exportAmountTextField)
        
        setupLabel(exportAmountYenLabel, text: "円")
        contentView.addSubview(exportAmountYenLabel)
        
        setupLabel(totalYenAmountLabel, text: "合計金額：")
        contentView.addSubview(totalYenAmountLabel)
        
        setupLabel(totalAmountLabel, text: "0円")
        totalAmountLabel.textAlignment = .center
        contentView.addSubview(totalAmountLabel)
        
        setupButton(calcButton, text: "料金計算＆チェック")
        calcButton.addTarget(self, action: #selector(self.tapCalcButton), for: .touchUpInside)
        contentView.addSubview(calcButton)
        
        setupLabel(memoTitleLabel, text: "メモ：")
        contentView.addSubview(memoTitleLabel)
        
        setupTextField(memoTextField, text: "")
        memoTextField.keyboardType = .default
        contentView.addSubview(memoTextField)

        setupButton(submitButton, text: "登録")
        submitButton.addTarget(self, action: #selector(self.tapSubmitButton), for: .touchUpInside)
        contentView.addSubview(submitButton)

        setupButton(cancelButton, text: "キャンセル")
        cancelButton.addTarget(self, action: #selector(self.tapCancelButton), for: .touchUpInside)
        contentView.addSubview(cancelButton)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dailySalesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dailySalesLabel.translatesAutoresizingMaskIntoConstraints = false
        tenThousandYenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tenThousandYenCountTextField.translatesAutoresizingMaskIntoConstraints = false
        tenThousandYenMaiLabel.translatesAutoresizingMaskIntoConstraints = false
        tenThousandYenLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveThousandYenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveThousandYenCountTextField.translatesAutoresizingMaskIntoConstraints = false
        fiveThousandYenMaiLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveThousandYenLabel.translatesAutoresizingMaskIntoConstraints = false
        twoThousandYenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        twoThousandYenCountTextField.translatesAutoresizingMaskIntoConstraints = false
        twoThousandYenMaiLabel.translatesAutoresizingMaskIntoConstraints = false
        twoThousandYenLabel.translatesAutoresizingMaskIntoConstraints = false
        oneThousandYenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        oneThousandYenCountTextField.translatesAutoresizingMaskIntoConstraints = false
        oneThousandYenMaiLabel.translatesAutoresizingMaskIntoConstraints = false
        oneThousandYenLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveHundredYenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveHundredYenCountTextField.translatesAutoresizingMaskIntoConstraints = false
        fiveHundredYenMaiLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveHundredYenLabel.translatesAutoresizingMaskIntoConstraints = false
        oneHundredYenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        oneHundredYenCountTextField.translatesAutoresizingMaskIntoConstraints = false
        oneHundredYenMaiLabel.translatesAutoresizingMaskIntoConstraints = false
        oneHundredYenLabel.translatesAutoresizingMaskIntoConstraints = false
        fiftyYenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        fiftyYenCountTextField.translatesAutoresizingMaskIntoConstraints = false
        fiftyYenMaiLabel.translatesAutoresizingMaskIntoConstraints = false
        fiftyYenLabel.translatesAutoresizingMaskIntoConstraints = false
        tenYenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tenYenCountTextField.translatesAutoresizingMaskIntoConstraints = false
        tenYenMaiLabel.translatesAutoresizingMaskIntoConstraints = false
        tenYenLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveYenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveYenCountTextField.translatesAutoresizingMaskIntoConstraints = false
        fiveYenMaiLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveYenLabel.translatesAutoresizingMaskIntoConstraints = false
        oneYenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        oneYenCountTextField.translatesAutoresizingMaskIntoConstraints = false
        oneYenMaiLabel.translatesAutoresizingMaskIntoConstraints = false
        oneYenLabel.translatesAutoresizingMaskIntoConstraints = false
        exportAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        exportAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        exportAmountYenLabel.translatesAutoresizingMaskIntoConstraints = false
        ticketTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ticketYenTextField.translatesAutoresizingMaskIntoConstraints = false
        ticketYenLabel.translatesAutoresizingMaskIntoConstraints = false
        totalYenAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        calcButton.translatesAutoresizingMaskIntoConstraints = false
        memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        memoTextField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // キーボードを閉じるメソッド
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    // 入店ボタンタップ時のイベント
    @objc func tapSubmitButton() {
        // 入力チェック
        if exportAmountTextField.text == "" {
            errorMessageLabel.text = "会社へ持ち帰った金額を入力してください"
            return
        }
        
        if tenThousandYenCountTextField.text == "" {
            errorMessageLabel.text = "1万円札の枚数を入力してください"
            return
        }
        if fiveThousandYenCountTextField.text == "" {
            errorMessageLabel.text = "5千円札の枚数を入力してください"
            return
        }
        if twoThousandYenCountTextField.text == "" {
            errorMessageLabel.text = "2千円札の枚数を入力してください"
            return
        }
        if oneThousandYenCountTextField.text == "" {
            errorMessageLabel.text = "千円札の枚数を入力してください"
            return
        }
        if fiveHundredYenCountTextField.text == "" {
            errorMessageLabel.text = "500円玉の枚数を入力してください"
            return
        }
        if oneHundredYenCountTextField.text == "" {
            errorMessageLabel.text = "100円玉の枚数を入力してください"
            return
        }
        if fiftyYenCountTextField.text == "" {
            errorMessageLabel.text = "50円玉の枚数を入力してください"
            return
        }
        if tenYenCountTextField.text == "" {
            errorMessageLabel.text = "10円玉の枚数を入力してください"
            return
        }
        if fiveYenCountTextField.text == "" {
            errorMessageLabel.text = "5円玉の枚数を入力してください"
            return
        }
        if oneYenCountTextField.text == "" {
            errorMessageLabel.text = "1円玉の枚数を入力してください"
            return
        }
        
        let tenThousandYenCount: Int = Int(tenThousandYenCountTextField.text ?? "0") ?? 0
        let fiveThousandYenCount: Int = Int(fiveThousandYenCountTextField.text ?? "0") ?? 0
        let twoThousandYenCount: Int = Int(twoThousandYenCountTextField.text ?? "0") ?? 0
        let oneThousandYenCount: Int = Int(oneThousandYenCountTextField.text ?? "0") ?? 0
        let fiveHundredYenCount: Int = Int(fiveHundredYenCountTextField.text ?? "0") ?? 0
        let oneHundredYenCount: Int = Int(oneHundredYenCountTextField.text ?? "0") ?? 0
        let fiftyYenCount: Int = Int(fiftyYenCountTextField.text ?? "0") ?? 0
        let tenYenCount: Int = Int(tenYenCountTextField.text ?? "0") ?? 0
        let fiveYenCount: Int = Int(fiveYenCountTextField.text ?? "0") ?? 0
        let oneYenCount: Int = Int(oneYenCountTextField.text ?? "0") ?? 0
        let ticketAmount: Int = Int(ticketYenTextField.text ?? "0") ?? 0
        let exportAmount: Int = Int(exportAmountTextField.text ?? "0") ?? 0
        
        let totalAmount = tenThousandYenCount * 10000 + fiveThousandYenCount * 5000 + twoThousandYenCount * 2000 + oneThousandYenCount * 1000 + fiveHundredYenCount * 500 + oneHundredYenCount * 100 + fiftyYenCount * 50 + tenYenCount * 10 + fiveYenCount * 5 + oneYenCount * 1
        
        // TODO: totalの入力チェックどうする？合計額とあってるかまでチェックする？
        delegate?.tapDenominationSubmitButton(date: dateLabel.text!, tenThousandYenCount: tenThousandYenCount, fiveThousandYenCount: fiveThousandYenCount, twoThousandYenCount: twoThousandYenCount, oneThousandYenCount: oneThousandYenCount, fiveHundredYenCount: fiveHundredYenCount, oneHundredYenCount: oneHundredYenCount, fiftyYenCount: fiftyYenCount, tenYenCount: tenYenCount, fiveYenCount: fiveYenCount, oneYenCount: oneYenCount, exportAmount: exportAmount, ticketAmount: ticketAmount, totalAmount: totalAmount, memo: memoTextField.text ?? "")
    }

    // キャンセルボタンタップ時のイベント
    @objc func tapCancelButton() {
        tenThousandYenCountTextField.text = "0"
        fiveThousandYenCountTextField.text = "0"
        twoThousandYenCountTextField.text = "0"
        oneThousandYenCountTextField.text = "0"
        fiveHundredYenCountTextField.text = "0"
        oneHundredYenCountTextField.text = "0"
        fiftyYenCountTextField.text = "0"
        tenYenCountTextField.text = "0"
        fiveYenCountTextField.text = "0"
        oneYenCountTextField.text = "0"
        totalAmountLabel.text = "0"
        memoTextField.text = ""
        resetScrollPosition()
        delegate?.tapDenominationCancelButton()
    }
    
    @objc func tapCalcButton() {
        // 入力チェック
        if exportAmountTextField.text == "" {
            errorMessageLabel.text = "会社へ持ち帰った金額を入力してください"
            return
        }
        if tenThousandYenCountTextField.text == "" {
            errorMessageLabel.text = "1万円札の枚数を入力してください"
            return
        }
        if fiveThousandYenCountTextField.text == "" {
            errorMessageLabel.text = "5千円札の枚数を入力してください"
            return
        }
        if twoThousandYenCountTextField.text == "" {
            errorMessageLabel.text = "2千円札の枚数を入力してください"
            return
        }
        if oneThousandYenCountTextField.text == "" {
            errorMessageLabel.text = "千円札の枚数を入力してください"
            return
        }
        if fiveHundredYenCountTextField.text == "" {
            errorMessageLabel.text = "500円玉の枚数を入力してください"
            return
        }
        if oneHundredYenCountTextField.text == "" {
            errorMessageLabel.text = "100円玉の枚数を入力してください"
            return
        }
        if fiftyYenCountTextField.text == "" {
            errorMessageLabel.text = "50円玉の枚数を入力してください"
            return
        }
        if tenYenCountTextField.text == "" {
            errorMessageLabel.text = "10円玉の枚数を入力してください"
            return
        }
        if fiveYenCountTextField.text == "" {
            errorMessageLabel.text = "5円玉の枚数を入力してください"
            return
        }
        if oneYenCountTextField.text == "" {
            errorMessageLabel.text = "1円玉の枚数を入力してください"
            return
        }
        if ticketYenTextField.text == "" {
            errorMessageLabel.text = "応援券等の金額を入力してください"
            return
        }
        
        let tenThousandYenCount: Int = Int(tenThousandYenCountTextField.text ?? "0") ?? 0
        let fiveThousandYenCount: Int = Int(fiveThousandYenCountTextField.text ?? "0") ?? 0
        let twoThousandYenCount: Int = Int(twoThousandYenCountTextField.text ?? "0") ?? 0
        let oneThousandYenCount: Int = Int(oneThousandYenCountTextField.text ?? "0") ?? 0
        let fiveHundredYenCount: Int = Int(fiveHundredYenCountTextField.text ?? "0") ?? 0
        let oneHundredYenCount: Int = Int(oneHundredYenCountTextField.text ?? "0") ?? 0
        let fiftyYenCount: Int = Int(fiftyYenCountTextField.text ?? "0") ?? 0
        let tenYenCount: Int = Int(tenYenCountTextField.text ?? "0") ?? 0
        let fiveYenCount: Int = Int(fiveYenCountTextField.text ?? "0") ?? 0
        let oneYenCount: Int = Int(oneYenCountTextField.text ?? "0") ?? 0
        let ticketAmount: Int = Int(ticketYenTextField.text ?? "0") ?? 0
        let exportAmount: Int = Int(exportAmountTextField.text ?? "0") ?? 0

        tenThousandYenLabel.text = commaSeparateThreeDigits(tenThousandYenCount * 10000) + "円"
        fiveThousandYenLabel.text = commaSeparateThreeDigits(fiveThousandYenCount * 5000) + "円"
        twoThousandYenLabel.text = commaSeparateThreeDigits(twoThousandYenCount * 2000) + "円"
        oneThousandYenLabel.text = commaSeparateThreeDigits(oneThousandYenCount * 1000) + "円"
        fiveHundredYenLabel.text = commaSeparateThreeDigits(fiveHundredYenCount * 500) + "円"
        oneHundredYenLabel.text = commaSeparateThreeDigits(oneHundredYenCount * 100) + "円"
        fiftyYenLabel.text = commaSeparateThreeDigits(fiftyYenCount * 50) + "円"
        tenYenLabel.text = commaSeparateThreeDigits(tenYenCount * 10) + "円"
        fiveYenLabel.text = commaSeparateThreeDigits(fiveYenCount * 5) + "円"
        oneYenLabel.text = commaSeparateThreeDigits(oneYenCount * 1) + "円"
        

        let totalAmount = tenThousandYenCount * 10000 + fiveThousandYenCount * 5000 + twoThousandYenCount * 2000 + oneThousandYenCount * 1000 + fiveHundredYenCount * 500 + oneHundredYenCount * 100 + fiftyYenCount * 50 + tenYenCount * 10 + fiveYenCount * 5 + oneYenCount * 1
        totalAmountLabel.text = commaSeparateThreeDigits(totalAmount) + "円"
        
        delegate?.checkTotalAmount(date: dateLabel.text!, totalAmount: totalAmount, ticketAmount: ticketAmount, exportAmount: exportAmount)
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

extension DenominationView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

// MARK: - Orientation Handling
private extension DenominationView {
    
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
            
            print("画面の向きが変更されました: \(self.isPortrait ? "縦向き" : "横向き")")
            
            // 画面幅を更新
            self.screenWidth = UIScreen.main.bounds.width
            
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
private extension DenominationView {
    
    func updateLayoutForCurrentOrientation() {
        // 既存の制約を削除
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.removeAll()
        
        // 新しい制約を作成
        if screenWidth < 668 {
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
                // 日付
                dateTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                dateTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 90),
                dateLabel.centerYAnchor.constraint(equalTo: dateTitleLabel.centerYAnchor),
                dateLabel.leftAnchor.constraint(equalTo: dateTitleLabel.rightAnchor, constant: 8),
                // 当日売上
                dailySalesTitleLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
                dailySalesTitleLabel.rightAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 100),
                dailySalesLabel.centerYAnchor.constraint(equalTo: dailySalesTitleLabel.centerYAnchor),
                dailySalesLabel.leftAnchor.constraint(equalTo: dailySalesTitleLabel.rightAnchor, constant: 8),
                // 1万円札
                tenThousandYenTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 24),
                tenThousandYenTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
                tenThousandYenCountTextField.centerYAnchor.constraint(equalTo: tenThousandYenTitleLabel.centerYAnchor),
                tenThousandYenCountTextField.leftAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor, constant: 8),
                tenThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 50),
                tenThousandYenCountTextField.heightAnchor.constraint(equalToConstant: 25),
                // 5千円札
                fiveThousandYenTitleLabel.topAnchor.constraint(equalTo: tenThousandYenTitleLabel.bottomAnchor, constant: 32),
                fiveThousandYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                fiveThousandYenCountTextField.centerYAnchor.constraint(equalTo: fiveThousandYenTitleLabel.centerYAnchor),
                fiveThousandYenCountTextField.leftAnchor.constraint(equalTo: fiveThousandYenTitleLabel.rightAnchor, constant: 8),
                fiveThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiveThousandYenMaiLabel.centerYAnchor.constraint(equalTo: fiveThousandYenTitleLabel.centerYAnchor),
                fiveThousandYenMaiLabel.leftAnchor.constraint(equalTo: fiveThousandYenCountTextField.rightAnchor, constant: 8),
                fiveThousandYenLabel.centerYAnchor.constraint(equalTo: fiveThousandYenTitleLabel.centerYAnchor),
                fiveThousandYenLabel.leftAnchor.constraint(equalTo: fiveThousandYenMaiLabel.rightAnchor, constant: 16),
                fiveThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 2千円札
                twoThousandYenTitleLabel.topAnchor.constraint(equalTo: fiveThousandYenTitleLabel.bottomAnchor, constant: 32),
                twoThousandYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                twoThousandYenCountTextField.centerYAnchor.constraint(equalTo: twoThousandYenTitleLabel.centerYAnchor),
                twoThousandYenCountTextField.leftAnchor.constraint(equalTo: twoThousandYenTitleLabel.rightAnchor, constant: 8),
                twoThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                twoThousandYenMaiLabel.centerYAnchor.constraint(equalTo: twoThousandYenTitleLabel.centerYAnchor),
                twoThousandYenMaiLabel.leftAnchor.constraint(equalTo: twoThousandYenCountTextField.rightAnchor, constant: 8),
                twoThousandYenLabel.centerYAnchor.constraint(equalTo: twoThousandYenTitleLabel.centerYAnchor),
                twoThousandYenLabel.leftAnchor.constraint(equalTo: twoThousandYenMaiLabel.rightAnchor, constant: 16),
                twoThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 千円札
                oneThousandYenTitleLabel.topAnchor.constraint(equalTo: twoThousandYenTitleLabel.bottomAnchor, constant: 32),
                oneThousandYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                oneThousandYenCountTextField.centerYAnchor.constraint(equalTo: oneThousandYenTitleLabel.centerYAnchor),
                oneThousandYenCountTextField.leftAnchor.constraint(equalTo: oneThousandYenTitleLabel.rightAnchor, constant: 8),
                oneThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                oneThousandYenMaiLabel.centerYAnchor.constraint(equalTo: oneThousandYenTitleLabel.centerYAnchor),
                oneThousandYenMaiLabel.leftAnchor.constraint(equalTo: oneThousandYenCountTextField.rightAnchor, constant: 8),
                oneThousandYenLabel.centerYAnchor.constraint(equalTo: oneThousandYenTitleLabel.centerYAnchor),
                oneThousandYenLabel.leftAnchor.constraint(equalTo: oneThousandYenMaiLabel.rightAnchor, constant: 16),
                oneThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 500円玉
                fiveHundredYenTitleLabel.topAnchor.constraint(equalTo: oneThousandYenTitleLabel.bottomAnchor, constant: 32),
                fiveHundredYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                fiveHundredYenCountTextField.centerYAnchor.constraint(equalTo: fiveHundredYenTitleLabel.centerYAnchor),
                fiveHundredYenCountTextField.leftAnchor.constraint(equalTo: fiveHundredYenTitleLabel.rightAnchor, constant: 8),
                fiveHundredYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiveHundredYenMaiLabel.centerYAnchor.constraint(equalTo: fiveHundredYenTitleLabel.centerYAnchor),
                fiveHundredYenMaiLabel.leftAnchor.constraint(equalTo: fiveHundredYenCountTextField.rightAnchor, constant: 8),
                fiveHundredYenLabel.centerYAnchor.constraint(equalTo: fiveHundredYenTitleLabel.centerYAnchor),
                fiveHundredYenLabel.leftAnchor.constraint(equalTo: fiveHundredYenMaiLabel.rightAnchor, constant: 16),
                fiveHundredYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 100円玉
                oneHundredYenCountTextField.centerYAnchor.constraint(equalTo: oneHundredYenTitleLabel.centerYAnchor),
                oneHundredYenCountTextField.leftAnchor.constraint(equalTo: oneHundredYenTitleLabel.rightAnchor, constant: 8),
                oneHundredYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                oneHundredYenMaiLabel.centerYAnchor.constraint(equalTo: oneHundredYenTitleLabel.centerYAnchor),
                oneHundredYenMaiLabel.leftAnchor.constraint(equalTo: oneHundredYenCountTextField.rightAnchor, constant: 8),
                oneHundredYenLabel.centerYAnchor.constraint(equalTo: oneHundredYenTitleLabel.centerYAnchor),
                oneHundredYenLabel.leftAnchor.constraint(equalTo: oneHundredYenMaiLabel.rightAnchor, constant: 16),
                oneHundredYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 50円玉
                fiftyYenCountTextField.centerYAnchor.constraint(equalTo: fiftyYenTitleLabel.centerYAnchor),
                fiftyYenCountTextField.leftAnchor.constraint(equalTo: fiftyYenTitleLabel.rightAnchor, constant: 8),
                fiftyYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiftyYenMaiLabel.centerYAnchor.constraint(equalTo: fiftyYenTitleLabel.centerYAnchor),
                fiftyYenMaiLabel.leftAnchor.constraint(equalTo: fiftyYenCountTextField.rightAnchor, constant: 8),
                fiftyYenLabel.centerYAnchor.constraint(equalTo: fiftyYenTitleLabel.centerYAnchor),
                fiftyYenLabel.leftAnchor.constraint(equalTo: fiftyYenMaiLabel.rightAnchor, constant: 16),
                fiftyYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 10円玉
                tenYenCountTextField.centerYAnchor.constraint(equalTo: tenYenTitleLabel.centerYAnchor),
                tenYenCountTextField.leftAnchor.constraint(equalTo: tenYenTitleLabel.rightAnchor, constant: 8),
                tenYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                tenYenMaiLabel.centerYAnchor.constraint(equalTo: tenYenTitleLabel.centerYAnchor),
                tenYenMaiLabel.leftAnchor.constraint(equalTo: tenYenCountTextField.rightAnchor, constant: 8),
                tenYenLabel.centerYAnchor.constraint(equalTo: tenYenTitleLabel.centerYAnchor),
                tenYenLabel.leftAnchor.constraint(equalTo: tenYenMaiLabel.rightAnchor, constant: 16),
                tenYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 5円玉
                fiveYenCountTextField.centerYAnchor.constraint(equalTo: fiveYenTitleLabel.centerYAnchor),
                fiveYenCountTextField.leftAnchor.constraint(equalTo: fiveYenTitleLabel.rightAnchor, constant: 8),
                fiveYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiveYenMaiLabel.centerYAnchor.constraint(equalTo: fiveYenTitleLabel.centerYAnchor),
                fiveYenMaiLabel.leftAnchor.constraint(equalTo: fiveYenCountTextField.rightAnchor, constant: 8),
                fiveYenLabel.centerYAnchor.constraint(equalTo: fiveYenTitleLabel.centerYAnchor),
                fiveYenLabel.leftAnchor.constraint(equalTo: fiveYenMaiLabel.rightAnchor, constant: 16),
                fiveYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 1円玉
                oneYenCountTextField.centerYAnchor.constraint(equalTo: oneYenTitleLabel.centerYAnchor),
                oneYenCountTextField.leftAnchor.constraint(equalTo: oneYenTitleLabel.rightAnchor, constant: 8),
                oneYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                oneYenMaiLabel.centerYAnchor.constraint(equalTo: oneYenTitleLabel.centerYAnchor),
                oneYenMaiLabel.leftAnchor.constraint(equalTo: oneYenCountTextField.rightAnchor, constant: 8),
                oneYenLabel.centerYAnchor.constraint(equalTo: oneYenTitleLabel.centerYAnchor),
                oneYenLabel.leftAnchor.constraint(equalTo: oneYenMaiLabel.rightAnchor, constant: 16),
                oneYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 応援券など
                ticketYenTextField.centerYAnchor.constraint(equalTo: ticketTitleLabel.centerYAnchor),
                ticketYenTextField.leftAnchor.constraint(equalTo: ticketTitleLabel.rightAnchor, constant: 8),
                ticketYenTextField.widthAnchor.constraint(equalToConstant: 200),
                ticketYenLabel.centerYAnchor.constraint(equalTo: ticketTitleLabel.centerYAnchor),
                ticketYenLabel.leftAnchor.constraint(equalTo: ticketYenTextField.rightAnchor, constant: 8),
                // 持ち帰り
                exportAmountTextField.centerYAnchor.constraint(equalTo: exportAmountTitleLabel.centerYAnchor),
                exportAmountTextField.leftAnchor.constraint(equalTo: exportAmountTitleLabel.rightAnchor, constant: 8),
                exportAmountTextField.widthAnchor.constraint(equalToConstant: 200),
                exportAmountYenLabel.centerYAnchor.constraint(equalTo: exportAmountTextField.centerYAnchor),
                exportAmountYenLabel.leftAnchor.constraint(equalTo: exportAmountTextField.rightAnchor, constant: 8),
                // 合計金額
                totalYenAmountLabel.topAnchor.constraint(equalTo: exportAmountTitleLabel.bottomAnchor, constant: 32),
                totalYenAmountLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                totalAmountLabel.centerYAnchor.constraint(equalTo: totalYenAmountLabel.centerYAnchor),
                totalAmountLabel.leftAnchor.constraint(equalTo: totalYenAmountLabel.rightAnchor, constant: 16),
                totalAmountLabel.widthAnchor.constraint(equalToConstant: 200),
                // 料金計算・チェックボタン
                calcButton.centerYAnchor.constraint(equalTo: totalYenAmountLabel.centerYAnchor),
                calcButton.leftAnchor.constraint(equalTo: totalAmountLabel.rightAnchor, constant: 24),
                calcButton.heightAnchor.constraint(equalToConstant: 48),
                calcButton.widthAnchor.constraint(equalToConstant: 240),
                // メモ
                memoTitleLabel.topAnchor.constraint(equalTo: totalYenAmountLabel.bottomAnchor, constant: 32),
                memoTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                memoTextField.topAnchor.constraint(equalTo: memoTitleLabel.topAnchor),
                memoTextField.bottomAnchor.constraint(equalTo: memoTitleLabel.bottomAnchor),
                memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 16),
                memoTextField.widthAnchor.constraint(equalToConstant: 400),
                // 登録ボタン
                submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
                submitButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32),
                submitButton.heightAnchor.constraint(equalToConstant: 48),
                submitButton.widthAnchor.constraint(equalToConstant: 160),
                // キャンセルボタン
                cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
                cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -32),
                cancelButton.heightAnchor.constraint(equalToConstant: 48),
                cancelButton.widthAnchor.constraint(equalToConstant: 160),
                
                // ContentViewの高さを決定
                contentView.heightAnchor.constraint(equalToConstant: 800)
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
                errorMessageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 64),
                // 日付
                dateTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
                dateTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 120),
                dateLabel.centerYAnchor.constraint(equalTo: dateTitleLabel.centerYAnchor),
                dateLabel.leftAnchor.constraint(equalTo: dateTitleLabel.rightAnchor, constant: 8),
                // 当日売上
                dailySalesTitleLabel.rightAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 200),
                dailySalesTitleLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
                dailySalesLabel.centerYAnchor.constraint(equalTo: dailySalesTitleLabel.centerYAnchor),
                dailySalesLabel.leftAnchor.constraint(equalTo: dailySalesTitleLabel.rightAnchor, constant: 8),
                // 1万円札
                tenThousandYenTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 32),
                tenThousandYenTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 150),
                tenThousandYenCountTextField.centerYAnchor.constraint(equalTo: tenThousandYenTitleLabel.centerYAnchor),
                tenThousandYenCountTextField.leftAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor, constant: 8),
                tenThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                tenThousandYenMaiLabel.centerYAnchor.constraint(equalTo: tenThousandYenTitleLabel.centerYAnchor),
                tenThousandYenMaiLabel.leftAnchor.constraint(equalTo: tenThousandYenCountTextField.rightAnchor, constant: 8),
                tenThousandYenLabel.centerYAnchor.constraint(equalTo: tenThousandYenTitleLabel.centerYAnchor),
                tenThousandYenLabel.leftAnchor.constraint(equalTo: tenThousandYenMaiLabel.rightAnchor, constant: 16),
                tenThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 5千円札
                fiveThousandYenTitleLabel.topAnchor.constraint(equalTo: tenThousandYenTitleLabel.bottomAnchor, constant: 32),
                fiveThousandYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                fiveThousandYenCountTextField.centerYAnchor.constraint(equalTo: fiveThousandYenTitleLabel.centerYAnchor),
                fiveThousandYenCountTextField.leftAnchor.constraint(equalTo: fiveThousandYenTitleLabel.rightAnchor, constant: 8),
                fiveThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiveThousandYenMaiLabel.centerYAnchor.constraint(equalTo: fiveThousandYenTitleLabel.centerYAnchor),
                fiveThousandYenMaiLabel.leftAnchor.constraint(equalTo: fiveThousandYenCountTextField.rightAnchor, constant: 8),
                fiveThousandYenLabel.centerYAnchor.constraint(equalTo: fiveThousandYenTitleLabel.centerYAnchor),
                fiveThousandYenLabel.leftAnchor.constraint(equalTo: fiveThousandYenMaiLabel.rightAnchor, constant: 16),
                fiveThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 2千円札
                twoThousandYenTitleLabel.topAnchor.constraint(equalTo: fiveThousandYenTitleLabel.bottomAnchor, constant: 32),
                twoThousandYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                twoThousandYenCountTextField.centerYAnchor.constraint(equalTo: twoThousandYenTitleLabel.centerYAnchor),
                twoThousandYenCountTextField.leftAnchor.constraint(equalTo: twoThousandYenTitleLabel.rightAnchor, constant: 8),
                twoThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                twoThousandYenMaiLabel.centerYAnchor.constraint(equalTo: twoThousandYenTitleLabel.centerYAnchor),
                twoThousandYenMaiLabel.leftAnchor.constraint(equalTo: twoThousandYenCountTextField.rightAnchor, constant: 8),
                twoThousandYenLabel.centerYAnchor.constraint(equalTo: twoThousandYenTitleLabel.centerYAnchor),
                twoThousandYenLabel.leftAnchor.constraint(equalTo: twoThousandYenMaiLabel.rightAnchor, constant: 16),
                twoThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 千円札
                oneThousandYenTitleLabel.topAnchor.constraint(equalTo: twoThousandYenTitleLabel.bottomAnchor, constant: 32),
                oneThousandYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                oneThousandYenCountTextField.centerYAnchor.constraint(equalTo: oneThousandYenTitleLabel.centerYAnchor),
                oneThousandYenCountTextField.leftAnchor.constraint(equalTo: oneThousandYenTitleLabel.rightAnchor, constant: 8),
                oneThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                oneThousandYenMaiLabel.centerYAnchor.constraint(equalTo: oneThousandYenTitleLabel.centerYAnchor),
                oneThousandYenMaiLabel.leftAnchor.constraint(equalTo: oneThousandYenCountTextField.rightAnchor, constant: 8),
                oneThousandYenLabel.centerYAnchor.constraint(equalTo: oneThousandYenTitleLabel.centerYAnchor),
                oneThousandYenLabel.leftAnchor.constraint(equalTo: oneThousandYenMaiLabel.rightAnchor, constant: 16),
                oneThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 500円玉
                fiveHundredYenTitleLabel.topAnchor.constraint(equalTo: oneThousandYenTitleLabel.bottomAnchor, constant: 32),
                fiveHundredYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                fiveHundredYenCountTextField.centerYAnchor.constraint(equalTo: fiveHundredYenTitleLabel.centerYAnchor),
                fiveHundredYenCountTextField.leftAnchor.constraint(equalTo: fiveHundredYenTitleLabel.rightAnchor, constant: 8),
                fiveHundredYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiveHundredYenMaiLabel.centerYAnchor.constraint(equalTo: fiveHundredYenTitleLabel.centerYAnchor),
                fiveHundredYenMaiLabel.leftAnchor.constraint(equalTo: fiveHundredYenCountTextField.rightAnchor, constant: 8),
                fiveHundredYenLabel.centerYAnchor.constraint(equalTo: fiveHundredYenTitleLabel.centerYAnchor),
                fiveHundredYenLabel.leftAnchor.constraint(equalTo: fiveHundredYenMaiLabel.rightAnchor, constant: 16),
                fiveHundredYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 100円玉
                oneHundredYenTitleLabel.topAnchor.constraint(equalTo: fiveHundredYenTitleLabel.bottomAnchor, constant: 32),
                oneHundredYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                oneHundredYenCountTextField.centerYAnchor.constraint(equalTo: oneHundredYenTitleLabel.centerYAnchor),
                oneHundredYenCountTextField.leftAnchor.constraint(equalTo: oneHundredYenTitleLabel.rightAnchor, constant: 8),
                oneHundredYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                oneHundredYenMaiLabel.centerYAnchor.constraint(equalTo: oneHundredYenTitleLabel.centerYAnchor),
                oneHundredYenMaiLabel.leftAnchor.constraint(equalTo: oneHundredYenCountTextField.rightAnchor, constant: 8),
                oneHundredYenLabel.centerYAnchor.constraint(equalTo: oneHundredYenTitleLabel.centerYAnchor),
                oneHundredYenLabel.leftAnchor.constraint(equalTo: oneHundredYenMaiLabel.rightAnchor, constant: 16),
                oneHundredYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 50円玉
                fiftyYenTitleLabel.topAnchor.constraint(equalTo: oneHundredYenTitleLabel.bottomAnchor, constant: 32),
                fiftyYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                fiftyYenCountTextField.centerYAnchor.constraint(equalTo: fiftyYenTitleLabel.centerYAnchor),
                fiftyYenCountTextField.leftAnchor.constraint(equalTo: fiftyYenTitleLabel.rightAnchor, constant: 8),
                fiftyYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiftyYenMaiLabel.centerYAnchor.constraint(equalTo: fiftyYenTitleLabel.centerYAnchor),
                fiftyYenMaiLabel.leftAnchor.constraint(equalTo: fiftyYenCountTextField.rightAnchor, constant: 8),
                fiftyYenLabel.centerYAnchor.constraint(equalTo: fiftyYenTitleLabel.centerYAnchor),
                fiftyYenLabel.leftAnchor.constraint(equalTo: fiftyYenMaiLabel.rightAnchor, constant: 16),
                fiftyYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 10円玉
                tenYenTitleLabel.topAnchor.constraint(equalTo: fiftyYenTitleLabel.bottomAnchor, constant: 32),
                tenYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                tenYenCountTextField.centerYAnchor.constraint(equalTo: tenYenTitleLabel.centerYAnchor),
                tenYenCountTextField.leftAnchor.constraint(equalTo: tenYenTitleLabel.rightAnchor, constant: 8),
                tenYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                tenYenMaiLabel.centerYAnchor.constraint(equalTo: tenYenTitleLabel.centerYAnchor),
                tenYenMaiLabel.leftAnchor.constraint(equalTo: tenYenCountTextField.rightAnchor, constant: 8),
                tenYenLabel.centerYAnchor.constraint(equalTo: tenYenTitleLabel.centerYAnchor),
                tenYenLabel.leftAnchor.constraint(equalTo: tenYenMaiLabel.rightAnchor, constant: 16),
                tenYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 5円玉
                fiveYenTitleLabel.topAnchor.constraint(equalTo: tenYenTitleLabel.bottomAnchor, constant: 32),
                fiveYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                fiveYenCountTextField.centerYAnchor.constraint(equalTo: fiveYenTitleLabel.centerYAnchor),
                fiveYenCountTextField.leftAnchor.constraint(equalTo: fiveYenTitleLabel.rightAnchor, constant: 8),
                fiveYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiveYenMaiLabel.centerYAnchor.constraint(equalTo: fiveYenTitleLabel.centerYAnchor),
                fiveYenMaiLabel.leftAnchor.constraint(equalTo: fiveYenCountTextField.rightAnchor, constant: 8),
                fiveYenLabel.centerYAnchor.constraint(equalTo: fiveYenTitleLabel.centerYAnchor),
                fiveYenLabel.leftAnchor.constraint(equalTo: fiveYenMaiLabel.rightAnchor, constant: 16),
                fiveYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 1円玉
                oneYenTitleLabel.topAnchor.constraint(equalTo: fiveYenTitleLabel.bottomAnchor, constant: 32),
                oneYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                oneYenCountTextField.centerYAnchor.constraint(equalTo: oneYenTitleLabel.centerYAnchor),
                oneYenCountTextField.leftAnchor.constraint(equalTo: oneYenTitleLabel.rightAnchor, constant: 8),
                oneYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                oneYenMaiLabel.centerYAnchor.constraint(equalTo: oneYenTitleLabel.centerYAnchor),
                oneYenMaiLabel.leftAnchor.constraint(equalTo: oneYenCountTextField.rightAnchor, constant: 8),
                oneYenLabel.centerYAnchor.constraint(equalTo: oneYenTitleLabel.centerYAnchor),
                oneYenLabel.leftAnchor.constraint(equalTo: oneYenMaiLabel.rightAnchor, constant: 16),
                oneYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 応援券など
                ticketTitleLabel.topAnchor.constraint(equalTo: oneYenTitleLabel.bottomAnchor, constant: 32),
                ticketTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                ticketYenTextField.centerYAnchor.constraint(equalTo: ticketTitleLabel.centerYAnchor),
                ticketYenTextField.leftAnchor.constraint(equalTo: ticketTitleLabel.rightAnchor, constant: 8),
                ticketYenTextField.widthAnchor.constraint(equalToConstant: 200),
                ticketYenLabel.centerYAnchor.constraint(equalTo: ticketTitleLabel.centerYAnchor),
                ticketYenLabel.leftAnchor.constraint(equalTo: ticketYenTextField.rightAnchor, constant: 8),
                // 持ち帰り
                exportAmountTitleLabel.topAnchor.constraint(equalTo: ticketTitleLabel.bottomAnchor, constant: 32),
                exportAmountTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                exportAmountTextField.centerYAnchor.constraint(equalTo: exportAmountTitleLabel.centerYAnchor),
                exportAmountTextField.leftAnchor.constraint(equalTo: exportAmountTitleLabel.rightAnchor, constant: 8),
                exportAmountTextField.widthAnchor.constraint(equalToConstant: 200),
                exportAmountYenLabel.centerYAnchor.constraint(equalTo: exportAmountTextField.centerYAnchor),
                exportAmountYenLabel.leftAnchor.constraint(equalTo: exportAmountTextField.rightAnchor, constant: 8),
                // 合計金額
                totalYenAmountLabel.topAnchor.constraint(equalTo: exportAmountTitleLabel.bottomAnchor, constant: 32),
                totalYenAmountLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                totalAmountLabel.centerYAnchor.constraint(equalTo: totalYenAmountLabel.centerYAnchor),
                totalAmountLabel.leftAnchor.constraint(equalTo: totalYenAmountLabel.rightAnchor, constant: 16),
                totalAmountLabel.widthAnchor.constraint(equalToConstant: 200),
                // 料金計算・チェックボタン
                calcButton.centerYAnchor.constraint(equalTo: totalYenAmountLabel.centerYAnchor),
                calcButton.leftAnchor.constraint(equalTo: totalAmountLabel.rightAnchor, constant: 24),
                calcButton.heightAnchor.constraint(equalToConstant: 48),
                calcButton.widthAnchor.constraint(equalToConstant: 240),
                // メモ
                memoTitleLabel.topAnchor.constraint(equalTo: totalYenAmountLabel.bottomAnchor, constant: 32),
                memoTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                memoTextField.topAnchor.constraint(equalTo: memoTitleLabel.topAnchor),
                memoTextField.bottomAnchor.constraint(equalTo: memoTitleLabel.bottomAnchor),
                memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 16),
                memoTextField.widthAnchor.constraint(equalToConstant: 400),
                // 登録ボタン
                submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
                submitButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32),
                submitButton.heightAnchor.constraint(equalToConstant: 48),
                submitButton.widthAnchor.constraint(equalToConstant: 160),
                // キャンセルボタン
                cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
                cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -32),
                cancelButton.heightAnchor.constraint(equalToConstant: 48),
                cancelButton.widthAnchor.constraint(equalToConstant: 160),
                
                // ContentViewの高さを決定（縦向きは高めに設定）
                contentView.heightAnchor.constraint(equalToConstant: 1170)
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
                errorMessageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 64),
                // 日付
                dateTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
                dateTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 120),
                dateLabel.centerYAnchor.constraint(equalTo: dateTitleLabel.centerYAnchor),
                dateLabel.leftAnchor.constraint(equalTo: dateTitleLabel.rightAnchor, constant: 8),
                // 当日売上
                dailySalesTitleLabel.rightAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 200),
                dailySalesTitleLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
                dailySalesLabel.centerYAnchor.constraint(equalTo: dailySalesTitleLabel.centerYAnchor),
                dailySalesLabel.leftAnchor.constraint(equalTo: dailySalesTitleLabel.rightAnchor, constant: 8),
                // 1万円札
                tenThousandYenTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 32),
                tenThousandYenTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
                tenThousandYenCountTextField.centerYAnchor.constraint(equalTo: tenThousandYenTitleLabel.centerYAnchor),
                tenThousandYenCountTextField.leftAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor, constant: 8),
                tenThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                tenThousandYenMaiLabel.centerYAnchor.constraint(equalTo: tenThousandYenTitleLabel.centerYAnchor),
                tenThousandYenMaiLabel.leftAnchor.constraint(equalTo: tenThousandYenCountTextField.rightAnchor, constant: 8),
                tenThousandYenLabel.centerYAnchor.constraint(equalTo: tenThousandYenTitleLabel.centerYAnchor),
                tenThousandYenLabel.leftAnchor.constraint(equalTo: tenThousandYenMaiLabel.rightAnchor, constant: 16),
                tenThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 5千円札
                fiveThousandYenTitleLabel.topAnchor.constraint(equalTo: tenThousandYenTitleLabel.bottomAnchor, constant: 32),
                fiveThousandYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                fiveThousandYenCountTextField.centerYAnchor.constraint(equalTo: fiveThousandYenTitleLabel.centerYAnchor),
                fiveThousandYenCountTextField.leftAnchor.constraint(equalTo: fiveThousandYenTitleLabel.rightAnchor, constant: 8),
                fiveThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiveThousandYenMaiLabel.centerYAnchor.constraint(equalTo: fiveThousandYenTitleLabel.centerYAnchor),
                fiveThousandYenMaiLabel.leftAnchor.constraint(equalTo: fiveThousandYenCountTextField.rightAnchor, constant: 8),
                fiveThousandYenLabel.centerYAnchor.constraint(equalTo: fiveThousandYenTitleLabel.centerYAnchor),
                fiveThousandYenLabel.leftAnchor.constraint(equalTo: fiveThousandYenMaiLabel.rightAnchor, constant: 16),
                fiveThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 2千円札
                twoThousandYenTitleLabel.topAnchor.constraint(equalTo: fiveThousandYenTitleLabel.bottomAnchor, constant: 32),
                twoThousandYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                twoThousandYenCountTextField.centerYAnchor.constraint(equalTo: twoThousandYenTitleLabel.centerYAnchor),
                twoThousandYenCountTextField.leftAnchor.constraint(equalTo: twoThousandYenTitleLabel.rightAnchor, constant: 8),
                twoThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                twoThousandYenMaiLabel.centerYAnchor.constraint(equalTo: twoThousandYenTitleLabel.centerYAnchor),
                twoThousandYenMaiLabel.leftAnchor.constraint(equalTo: twoThousandYenCountTextField.rightAnchor, constant: 8),
                twoThousandYenLabel.centerYAnchor.constraint(equalTo: twoThousandYenTitleLabel.centerYAnchor),
                twoThousandYenLabel.leftAnchor.constraint(equalTo: twoThousandYenMaiLabel.rightAnchor, constant: 16),
                twoThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 千円札
                oneThousandYenTitleLabel.topAnchor.constraint(equalTo: twoThousandYenTitleLabel.bottomAnchor, constant: 32),
                oneThousandYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                oneThousandYenCountTextField.centerYAnchor.constraint(equalTo: oneThousandYenTitleLabel.centerYAnchor),
                oneThousandYenCountTextField.leftAnchor.constraint(equalTo: oneThousandYenTitleLabel.rightAnchor, constant: 8),
                oneThousandYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                oneThousandYenMaiLabel.centerYAnchor.constraint(equalTo: oneThousandYenTitleLabel.centerYAnchor),
                oneThousandYenMaiLabel.leftAnchor.constraint(equalTo: oneThousandYenCountTextField.rightAnchor, constant: 8),
                oneThousandYenLabel.centerYAnchor.constraint(equalTo: oneThousandYenTitleLabel.centerYAnchor),
                oneThousandYenLabel.leftAnchor.constraint(equalTo: oneThousandYenMaiLabel.rightAnchor, constant: 16),
                oneThousandYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 500円玉
                fiveHundredYenTitleLabel.topAnchor.constraint(equalTo: oneThousandYenTitleLabel.bottomAnchor, constant: 32),
                fiveHundredYenTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                fiveHundredYenCountTextField.centerYAnchor.constraint(equalTo: fiveHundredYenTitleLabel.centerYAnchor),
                fiveHundredYenCountTextField.leftAnchor.constraint(equalTo: fiveHundredYenTitleLabel.rightAnchor, constant: 8),
                fiveHundredYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiveHundredYenMaiLabel.centerYAnchor.constraint(equalTo: fiveHundredYenTitleLabel.centerYAnchor),
                fiveHundredYenMaiLabel.leftAnchor.constraint(equalTo: fiveHundredYenCountTextField.rightAnchor, constant: 8),
                fiveHundredYenLabel.centerYAnchor.constraint(equalTo: fiveHundredYenTitleLabel.centerYAnchor),
                fiveHundredYenLabel.leftAnchor.constraint(equalTo: fiveHundredYenMaiLabel.rightAnchor, constant: 16),
                fiveHundredYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 100円玉
                oneHundredYenTitleLabel.centerYAnchor.constraint(equalTo: tenThousandYenTitleLabel.centerYAnchor),
                oneHundredYenTitleLabel.rightAnchor.constraint(equalTo: dailySalesTitleLabel.rightAnchor),
                oneHundredYenCountTextField.centerYAnchor.constraint(equalTo: oneHundredYenTitleLabel.centerYAnchor),
                oneHundredYenCountTextField.leftAnchor.constraint(equalTo: oneHundredYenTitleLabel.rightAnchor, constant: 8),
                oneHundredYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                oneHundredYenMaiLabel.centerYAnchor.constraint(equalTo: oneHundredYenTitleLabel.centerYAnchor),
                oneHundredYenMaiLabel.leftAnchor.constraint(equalTo: oneHundredYenCountTextField.rightAnchor, constant: 8),
                oneHundredYenLabel.centerYAnchor.constraint(equalTo: oneHundredYenTitleLabel.centerYAnchor),
                oneHundredYenLabel.leftAnchor.constraint(equalTo: oneHundredYenMaiLabel.rightAnchor, constant: 16),
                oneHundredYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 50円玉
                fiftyYenTitleLabel.centerYAnchor.constraint(equalTo: fiveThousandYenTitleLabel.centerYAnchor),
                fiftyYenTitleLabel.rightAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 200),
                fiftyYenCountTextField.centerYAnchor.constraint(equalTo: fiftyYenTitleLabel.centerYAnchor),
                fiftyYenCountTextField.leftAnchor.constraint(equalTo: fiftyYenTitleLabel.rightAnchor, constant: 8),
                fiftyYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiftyYenMaiLabel.centerYAnchor.constraint(equalTo: fiftyYenTitleLabel.centerYAnchor),
                fiftyYenMaiLabel.leftAnchor.constraint(equalTo: fiftyYenCountTextField.rightAnchor, constant: 8),
                fiftyYenLabel.centerYAnchor.constraint(equalTo: fiftyYenTitleLabel.centerYAnchor),
                fiftyYenLabel.leftAnchor.constraint(equalTo: fiftyYenMaiLabel.rightAnchor, constant: 16),
                fiftyYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 10円玉
                tenYenTitleLabel.centerYAnchor.constraint(equalTo: twoThousandYenTitleLabel.centerYAnchor),
                tenYenTitleLabel.rightAnchor.constraint(equalTo: fiftyYenTitleLabel.rightAnchor),
                tenYenCountTextField.centerYAnchor.constraint(equalTo: tenYenTitleLabel.centerYAnchor),
                tenYenCountTextField.leftAnchor.constraint(equalTo: tenYenTitleLabel.rightAnchor, constant: 8),
                tenYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                tenYenMaiLabel.centerYAnchor.constraint(equalTo: tenYenTitleLabel.centerYAnchor),
                tenYenMaiLabel.leftAnchor.constraint(equalTo: tenYenCountTextField.rightAnchor, constant: 8),
                tenYenLabel.centerYAnchor.constraint(equalTo: tenYenTitleLabel.centerYAnchor),
                tenYenLabel.leftAnchor.constraint(equalTo: tenYenMaiLabel.rightAnchor, constant: 16),
                tenYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 5円玉
                fiveYenTitleLabel.centerYAnchor.constraint(equalTo: oneThousandYenTitleLabel.centerYAnchor),
                fiveYenTitleLabel.rightAnchor.constraint(equalTo: fiftyYenTitleLabel.rightAnchor),
                fiveYenCountTextField.centerYAnchor.constraint(equalTo: fiveYenTitleLabel.centerYAnchor),
                fiveYenCountTextField.leftAnchor.constraint(equalTo: fiveYenTitleLabel.rightAnchor, constant: 8),
                fiveYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                fiveYenMaiLabel.centerYAnchor.constraint(equalTo: fiveYenTitleLabel.centerYAnchor),
                fiveYenMaiLabel.leftAnchor.constraint(equalTo: fiveYenCountTextField.rightAnchor, constant: 8),
                fiveYenLabel.centerYAnchor.constraint(equalTo: fiveYenTitleLabel.centerYAnchor),
                fiveYenLabel.leftAnchor.constraint(equalTo: fiveYenMaiLabel.rightAnchor, constant: 16),
                fiveYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 1円玉
                oneYenTitleLabel.centerYAnchor.constraint(equalTo: fiveHundredYenTitleLabel.centerYAnchor),
                oneYenTitleLabel.rightAnchor.constraint(equalTo: fiftyYenTitleLabel.rightAnchor),
                oneYenCountTextField.centerYAnchor.constraint(equalTo: oneYenTitleLabel.centerYAnchor),
                oneYenCountTextField.leftAnchor.constraint(equalTo: oneYenTitleLabel.rightAnchor, constant: 8),
                oneYenCountTextField.widthAnchor.constraint(equalToConstant: 100),
                oneYenMaiLabel.centerYAnchor.constraint(equalTo: oneYenTitleLabel.centerYAnchor),
                oneYenMaiLabel.leftAnchor.constraint(equalTo: oneYenCountTextField.rightAnchor, constant: 8),
                oneYenLabel.centerYAnchor.constraint(equalTo: oneYenTitleLabel.centerYAnchor),
                oneYenLabel.leftAnchor.constraint(equalTo: oneYenMaiLabel.rightAnchor, constant: 16),
                oneYenLabel.widthAnchor.constraint(equalToConstant: 180),
                // 応援券など
                ticketTitleLabel.topAnchor.constraint(equalTo: fiveHundredYenTitleLabel.bottomAnchor, constant: 32),
                ticketTitleLabel.rightAnchor.constraint(equalTo: dateTitleLabel.rightAnchor),
                ticketYenTextField.centerYAnchor.constraint(equalTo: ticketTitleLabel.centerYAnchor),
                ticketYenTextField.leftAnchor.constraint(equalTo: ticketTitleLabel.rightAnchor, constant: 8),
                ticketYenTextField.widthAnchor.constraint(equalToConstant: 200),
                ticketYenLabel.centerYAnchor.constraint(equalTo: ticketTitleLabel.centerYAnchor),
                ticketYenLabel.leftAnchor.constraint(equalTo: ticketYenTextField.rightAnchor, constant: 8),
                // 持ち帰り
                exportAmountTitleLabel.centerYAnchor.constraint(equalTo: ticketTitleLabel.centerYAnchor),
                exportAmountTitleLabel.rightAnchor.constraint(equalTo: oneHundredYenTitleLabel.rightAnchor),
                exportAmountTextField.centerYAnchor.constraint(equalTo: exportAmountTitleLabel.centerYAnchor),
                exportAmountTextField.leftAnchor.constraint(equalTo: exportAmountTitleLabel.rightAnchor, constant: 8),
                exportAmountTextField.widthAnchor.constraint(equalToConstant: 200),
                exportAmountYenLabel.centerYAnchor.constraint(equalTo: exportAmountTextField.centerYAnchor),
                exportAmountYenLabel.leftAnchor.constraint(equalTo: exportAmountTextField.rightAnchor, constant: 8),
                // 合計金額
                totalYenAmountLabel.topAnchor.constraint(equalTo: exportAmountTitleLabel.bottomAnchor, constant: 32),
                totalYenAmountLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                totalAmountLabel.centerYAnchor.constraint(equalTo: totalYenAmountLabel.centerYAnchor),
                totalAmountLabel.leftAnchor.constraint(equalTo: totalYenAmountLabel.rightAnchor, constant: 16),
                totalAmountLabel.widthAnchor.constraint(equalToConstant: 200),
                // 料金計算・チェックボタン
                calcButton.centerYAnchor.constraint(equalTo: totalYenAmountLabel.centerYAnchor),
                calcButton.leftAnchor.constraint(equalTo: totalAmountLabel.rightAnchor, constant: 24),
                calcButton.heightAnchor.constraint(equalToConstant: 48),
                calcButton.widthAnchor.constraint(equalToConstant: 240),
                // メモ
                memoTitleLabel.topAnchor.constraint(equalTo: totalYenAmountLabel.bottomAnchor, constant: 32),
                memoTitleLabel.rightAnchor.constraint(equalTo: tenThousandYenTitleLabel.rightAnchor),
                memoTextField.topAnchor.constraint(equalTo: memoTitleLabel.topAnchor),
                memoTextField.bottomAnchor.constraint(equalTo: memoTitleLabel.bottomAnchor),
                memoTextField.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 16),
                memoTextField.widthAnchor.constraint(equalToConstant: 400),
                // 登録ボタン
                submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
                submitButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32),
                submitButton.heightAnchor.constraint(equalToConstant: 48),
                submitButton.widthAnchor.constraint(equalToConstant: 160),
                // キャンセルボタン
                cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
                cancelButton.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -32),
                cancelButton.heightAnchor.constraint(equalToConstant: 48),
                cancelButton.widthAnchor.constraint(equalToConstant: 160),
                
                // ContentViewの高さを決定（横向きは低めに設定）
                contentView.heightAnchor.constraint(equalToConstant: 680)
            ]
            
            currentConstraints.append(contentsOf: constraints)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func updateUIElementsForOrientation() {
        // フォントサイズの更新
        let fontSize: CGFloat = screenWidth < 668 ? 12 : 32
        let buttonFontSize: CGFloat = screenWidth < 668 ? 12 : 24
        
        // 全てのラベルのフォントサイズを更新
        [dateTitleLabel, dateLabel, dailySalesTitleLabel, dailySalesLabel,
         tenThousandYenTitleLabel, tenThousandYenMaiLabel, tenThousandYenLabel,
         fiveThousandYenTitleLabel, fiveThousandYenMaiLabel, fiveThousandYenLabel,
         twoThousandYenTitleLabel, twoThousandYenMaiLabel, twoThousandYenLabel,
         oneThousandYenTitleLabel, oneThousandYenMaiLabel, oneThousandYenLabel,
         fiveHundredYenTitleLabel, fiveHundredYenMaiLabel, fiveHundredYenLabel,
         oneHundredYenTitleLabel, oneHundredYenMaiLabel, oneHundredYenLabel,
         fiftyYenTitleLabel,fiftyYenMaiLabel, fiftyYenLabel,
         tenYenTitleLabel, tenYenMaiLabel, tenYenLabel,
         fiveYenTitleLabel, fiveYenMaiLabel, fiveYenLabel,
         oneYenTitleLabel, oneYenMaiLabel, oneYenLabel,
         ticketTitleLabel, ticketYenLabel, exportAmountTitleLabel, exportAmountYenLabel,
         totalYenAmountLabel, totalAmountLabel, memoTitleLabel
        ].forEach { label in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        // 全てのテキストフィールドのフォントサイズを更新
        [tenThousandYenCountTextField, fiveThousandYenCountTextField,
         twoThousandYenCountTextField, oneThousandYenCountTextField,
         fiveHundredYenCountTextField, oneHundredYenCountTextField,
         fiftyYenCountTextField, tenYenCountTextField,
         fiveYenCountTextField, oneYenCountTextField,
         ticketYenTextField, exportAmountTextField, memoTextField
        ].forEach { textField in
            textField.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        // ボタンのフォントサイズを更新
        [calcButton, submitButton, cancelButton].forEach { button in
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
