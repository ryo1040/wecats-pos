//
//  CheckoutView.swift
//  wecatspos
//
//  Created by matsumoto on 2026/03/28.
//

import Foundation
import UIKit

protocol CheckoutDelegate: AnyObject  {
    func tapCheckoutCloseButton()
}

public class CheckoutView: UIView {
    
    let logoLabel = UILabel()
    let shopNameLabel = UILabel()
    let closeButton = UIButton()
    let visitorCountLabel = UILabel()
    let totalTimeTitleLabel = UILabel()
    let totalTimeLabel = UILabel()
    let chargeTitleLabel = UILabel()
    let chargeLabel = UILabel()
    let breakdownLabel = UILabel()
    let messageLabel1 = UILabel()
    let messageLabel2 = UILabel()
    
    private var currentConstraints: [NSLayoutConstraint] = []
    var screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    // 画面向きを判定するプロパティ
    private var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
    
    weak var delegate: CheckoutDelegate?
    
    public init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.red
                
        setupViews()
//        
//        setupOrientationObserver()
//
//        enterTimePicker.date = Date()
        
//        // タップジェスチャーを追加
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelPicker))
//        tapGesture.cancelsTouchesInView = false // 他のビューのタップイベントも処理する
//        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCheckout(selectedGuest: GetTotalAmountModel) {
        visitorCountLabel.text = "大人" + String(selectedGuest.adultCount) + "名、子ども" + String(selectedGuest.childCount) + "名"
        totalTimeLabel.text = String(selectedGuest.stayTime) + "分"
        chargeLabel.text = "¥" + commaSeparateThreeDigits(selectedGuest.totalAmount)
        
        let adultUnitPrice = selectedGuest.adultUnitPrice
        var childUnitPrice = selectedGuest.childUnitPrice
        let formattedAdultUnitPrice = commaSeparateThreeDigits(adultUnitPrice)
        if selectedGuest.kidsDayFlg {
            let formattedChildUnitPrice = commaSeparateThreeDigits(childUnitPrice)
            breakdownLabel.text = "大人¥" + formattedAdultUnitPrice + "×" + String(selectedGuest.adultCount) + "名 + 子ども¥" + formattedChildUnitPrice + "×" + String(selectedGuest.childCount) + "名（半額）"
        } else {
            let formattedChildUnitPrice = commaSeparateThreeDigits(childUnitPrice)
            breakdownLabel.text = "大人¥" + formattedAdultUnitPrice + "×" + String(selectedGuest.adultCount) + "名 + 子ども¥" + formattedChildUnitPrice + "×" + String(selectedGuest.childCount) + "名"
        }
    }
}

private extension CheckoutView {
    func setupViews() {
        
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        
        // UI要素の設定（制約は後で動的に設定するため、ここでは基本設定のみ）
        setupUIElements()
        
        // 初回レイアウト設定
        updateLayoutForCurrentOrientation()
    }
    
    func setupUIElements() {
        // UI要素の基本設定のみ行う（制約は除く）
        
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
        
        setupLabel(shopNameLabel, text: "We Cats")
        self.addSubview(shopNameLabel)
        
        setupLabel(visitorCountLabel, text: "大人○名、子ども○名")
        self.addSubview(visitorCountLabel)
        
        setupLabel(totalTimeTitleLabel, text: "ご滞在時間")
        self.addSubview(totalTimeTitleLabel)
        
        setupLabel(totalTimeLabel, text: "○時間○○分")
        self.addSubview(totalTimeLabel)
        
        setupLabel(chargeTitleLabel, text: "お会計")
        self.addSubview(chargeTitleLabel)
        
        setupLabel(chargeLabel, text: "¥2,700")
        self.addSubview(chargeLabel)
        
        setupLabel(breakdownLabel, text: "大人¥1,800×1名 + 子ども¥900×1名（半額）")
        self.addSubview(breakdownLabel)
        
        setupLabel(messageLabel1, text: "またのご来店をお待ちしております")
        self.addSubview(messageLabel1)
        
        setupLabel(messageLabel2, text: "猫たちも待ってます")
        self.addSubview(messageLabel2)
        
        setupButton(closeButton, text: "閉じる")
        closeButton.addTarget(self, action: #selector(self.tapCloseButton), for: .touchUpInside)
        self.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 閉じるボタンタップ時のイベント
    @objc func tapCloseButton() {
        delegate?.tapCheckoutCloseButton()
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

// MARK: - Layout Update Methods
private extension CheckoutView {
    
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
        
        // アニメーション付きでレイアウトを更新
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func setupSmallScreenConstraints() {
        // 小さい画面用の制約
        let constraints = [
            
            shopNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            shopNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            visitorCountLabel.topAnchor.constraint(equalTo: shopNameLabel.bottomAnchor, constant: 16),
            visitorCountLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            totalTimeTitleLabel.topAnchor.constraint(equalTo: visitorCountLabel.bottomAnchor, constant: 16),
            totalTimeTitleLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            totalTimeLabel.topAnchor.constraint(equalTo: totalTimeTitleLabel.bottomAnchor, constant: 16),
            totalTimeLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            chargeTitleLabel.topAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor, constant: 16),
            chargeTitleLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            chargeLabel.topAnchor.constraint(equalTo: chargeTitleLabel.bottomAnchor, constant: 16),
            chargeLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            breakdownLabel.topAnchor.constraint(equalTo: chargeLabel.bottomAnchor, constant: 16),
            breakdownLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            messageLabel1.topAnchor.constraint(equalTo: breakdownLabel.bottomAnchor, constant: 32),
            messageLabel1.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            messageLabel2.topAnchor.constraint(equalTo: messageLabel1.bottomAnchor, constant: 16),
            messageLabel2.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            closeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
            closeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
            closeButton.heightAnchor.constraint(equalToConstant: 48),
            closeButton.widthAnchor.constraint(equalToConstant: 160),
        ]
        currentConstraints.append(contentsOf: constraints)
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupPortraitConstraints() {
        // 縦向き用の制約
        let constraints = [
            shopNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 96),
            shopNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            visitorCountLabel.topAnchor.constraint(equalTo: shopNameLabel.bottomAnchor, constant: 96),
            visitorCountLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            totalTimeTitleLabel.topAnchor.constraint(equalTo: visitorCountLabel.bottomAnchor, constant: 90),
            totalTimeTitleLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            totalTimeLabel.topAnchor.constraint(equalTo: totalTimeTitleLabel.bottomAnchor, constant: 32),
            totalTimeLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            chargeTitleLabel.topAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor, constant: 90),
            chargeTitleLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            chargeLabel.topAnchor.constraint(equalTo: chargeTitleLabel.bottomAnchor, constant: 32),
            chargeLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            breakdownLabel.topAnchor.constraint(equalTo: chargeLabel.bottomAnchor, constant: 32),
            breakdownLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            messageLabel1.topAnchor.constraint(equalTo: breakdownLabel.bottomAnchor, constant: 96),
            messageLabel1.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            messageLabel2.topAnchor.constraint(equalTo: messageLabel1.bottomAnchor, constant: 32),
            messageLabel2.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            closeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
            closeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
            closeButton.heightAnchor.constraint(equalToConstant: 48),
            closeButton.widthAnchor.constraint(equalToConstant: 160),
        ]
        currentConstraints.append(contentsOf: constraints)
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupLandscapeConstraints() {
        // 横向き用の制約
        let constraints = [
            shopNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 64),
            shopNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            visitorCountLabel.topAnchor.constraint(equalTo: shopNameLabel.bottomAnchor, constant: 48),
            visitorCountLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            totalTimeTitleLabel.topAnchor.constraint(equalTo: visitorCountLabel.bottomAnchor, constant: 64),
            totalTimeTitleLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            totalTimeLabel.topAnchor.constraint(equalTo: totalTimeTitleLabel.bottomAnchor, constant: 16),
            totalTimeLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            chargeTitleLabel.topAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor, constant: 48),
            chargeTitleLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            chargeLabel.topAnchor.constraint(equalTo: chargeTitleLabel.bottomAnchor, constant: 16),
            chargeLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            breakdownLabel.topAnchor.constraint(equalTo: chargeLabel.bottomAnchor, constant: 16),
            breakdownLabel.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            messageLabel1.topAnchor.constraint(equalTo: breakdownLabel.bottomAnchor, constant: 48),
            messageLabel1.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            messageLabel2.topAnchor.constraint(equalTo: messageLabel1.bottomAnchor, constant: 16),
            messageLabel2.centerXAnchor.constraint(equalTo: shopNameLabel.centerXAnchor),
            
            closeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
            closeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
            closeButton.heightAnchor.constraint(equalToConstant: 48),
            closeButton.widthAnchor.constraint(equalToConstant: 160),
        ]
        currentConstraints.append(contentsOf: constraints)
        NSLayoutConstraint.activate(constraints)
    }
    
    func updateUIElementsForOrientation() {
        // フォントサイズの更新
        let fontSize: CGFloat = LayoutBreakpoint.isCompact(sideLength: screenWidth) ? 12 : 32
        let fontSize2: CGFloat = LayoutBreakpoint.isCompact(sideLength: screenWidth) ? 9 : 20
        let fontSize3: CGFloat = LayoutBreakpoint.isCompact(sideLength: screenWidth) ? 18 : 48
        let buttonFontSize: CGFloat = LayoutBreakpoint.isCompact(sideLength: screenWidth) ? 12 : 24
        
        // 全てのラベルのフォントサイズを更新
        [visitorCountLabel, totalTimeLabel, chargeLabel, messageLabel1, messageLabel2
        ].forEach { label in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
        [totalTimeTitleLabel, chargeTitleLabel, breakdownLabel
        ].forEach { label in
            label.font = UIFont.systemFont(ofSize: fontSize2)
        }
        [shopNameLabel, totalTimeLabel, chargeLabel
        ].forEach { label in
            label.font = UIFont.systemFont(ofSize: fontSize3)
        }
        
        // ボタンのフォントサイズを更新
        [closeButton].forEach { button in
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        }
    }
}
