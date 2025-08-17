//
//  VisitorInfoView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/10.
//

import Foundation
import UIKit

protocol VisitorInfoDelegate: AnyObject  {
//    func tapLeaveSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String)
    func tapBackButton()
}

public class VisitorInfoView: UIView {
    
    let repeatTitleLabel = UILabel()
    let repeatLabel = UILabel()
    let repeatPickerView = UIPickerView()
    let patternTitleLabel = UILabel()
    let patternLabel = UILabel()
    let patternPickerView = UIPickerView()
    let nameTitleLabel = UILabel()
    let nameLabel = UILabel()
    let countTitleLabel = UILabel()
    let countLabel = UILabel()
    
    let stayTimeTitleLabel = UILabel()
    let stayTimeLabel = UILabel()
    let basicPriceTitleLabel = UILabel()
    let basicPriceLabel = UILabel()
    let discountAmountTitleLabel = UILabel()
    let discountAmountLabel = UILabel()
    let gachaAmountTitleLabel = UILabel()
    let gachaAmountLabel = UILabel()
    let salesAmountTitleLabel = UILabel()
    let salesAmountLabel = UILabel()
    let feeTitleLabel = UILabel()
    let feeLabel = UILabel()
    let memoTitleLabel = UILabel()
    let memoLabel = UILabel()
    
    let submitButton = UIButton()
    let backButton = UIButton()
    
    weak var delegate: VisitorInfoDelegate?
    
    public init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVisitorInfo(selectGuestInfo: GuestInfoModel){
        repeatLabel.text = selectGuestInfo.repeatFlag ? "リピーター" : "新規"
        if selectGuestInfo.patternId == 1 {
            patternLabel.text = "家族"
        } else if selectGuestInfo.patternId == 2 {
            patternLabel.text = "友人"
        } else if selectGuestInfo.patternId == 3 {
            patternLabel.text = "おひとり"
        } else {
            patternLabel.text = "その他"
        }
        nameLabel.text = selectGuestInfo.name ?? ""
        countLabel.text = "大人：" + String(selectGuestInfo.adultCount) + "名、子供：" + String(selectGuestInfo.childCount) + "名"
        stayTimeLabel.text = selectGuestInfo.enterTime + "～" + selectGuestInfo.leftTime + "　" + String(selectGuestInfo.stayTime) + "分"
    basicPriceLabel.text = commaSeparateThreeDigits(selectGuestInfo.calcAmount) + "円"
    discountAmountLabel.text = commaSeparateThreeDigits(selectGuestInfo.discountAmount) + "円"
    gachaAmountLabel.text = commaSeparateThreeDigits(selectGuestInfo.gachaAmount) + "円"
    salesAmountLabel.text = commaSeparateThreeDigits(selectGuestInfo.salesAmount) + "円"
    feeLabel.text = commaSeparateThreeDigits(selectGuestInfo.totalAmount) + "円"
        memoLabel.text = selectGuestInfo.memo ?? ""
    }
}

private extension VisitorInfoView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        
        func setupLabel(_ label: UILabel, text: String = "") {
            label.text = text
            label.font = UIFont.systemFont(ofSize: 32)
            label.textColor = UIColor.black
        }
        
        setupLabel(repeatTitleLabel, text: "新規/リピーター：")
        self.addSubview(repeatTitleLabel)
        
        setupLabel(repeatLabel)
        repeatLabel.textAlignment = .center
        self.addSubview(repeatLabel)
        
        setupLabel(patternTitleLabel, text: "パターン：")
        self.addSubview(patternTitleLabel)
        
        setupLabel(patternLabel)
        patternLabel.textAlignment = .center
        self.addSubview(patternLabel)
        
        setupLabel(nameTitleLabel, text: "氏名：")
        self.addSubview(nameTitleLabel)
        
        setupLabel(nameLabel)
        nameLabel.textAlignment = .center
        self.addSubview(nameLabel)
        
        setupLabel(countTitleLabel, text: "人数：")
        self.addSubview(countTitleLabel)
        
        setupLabel(countLabel)
        countLabel.textAlignment = .center
        self.addSubview(countLabel)

        setupLabel(stayTimeTitleLabel, text: "滞在時間：")
        self.addSubview(stayTimeTitleLabel)

        setupLabel(stayTimeLabel)
        stayTimeLabel.textAlignment = .center
        self.addSubview(stayTimeLabel)
        
        setupLabel(basicPriceTitleLabel, text: "基本料金：")
        self.addSubview(basicPriceTitleLabel)
        
        setupLabel(basicPriceLabel)
        basicPriceLabel.textAlignment = .center
        self.addSubview(basicPriceLabel)
        
        setupLabel(discountAmountTitleLabel, text: "割引額：")
        self.addSubview(discountAmountTitleLabel)
        
        setupLabel(discountAmountLabel)
        discountAmountLabel.textColor = UIColor.red
        discountAmountLabel.textAlignment = .center
        self.addSubview(discountAmountLabel)
        
        setupLabel(gachaAmountTitleLabel, text: "ガチャ額：")
        self.addSubview(gachaAmountTitleLabel)
        
        setupLabel(gachaAmountLabel)
        gachaAmountLabel.textAlignment = .center
        self.addSubview(gachaAmountLabel)

        setupLabel(salesAmountTitleLabel, text: "販売額：")
        self.addSubview(salesAmountTitleLabel)
        
        setupLabel(salesAmountLabel)
        salesAmountLabel.textAlignment = .center
        self.addSubview(salesAmountLabel)
        
        setupLabel(feeTitleLabel, text: "料金：")
        self.addSubview(feeTitleLabel)
        
        setupLabel(feeLabel)
        feeLabel.textAlignment = .center
        self.addSubview(feeLabel)
        
        setupLabel(memoTitleLabel, text: "メモ：")
        memoTitleLabel.textAlignment = .center
        self.addSubview(memoTitleLabel)
        
        setupLabel(memoLabel)
        self.addSubview(memoLabel)
        
        backButton.setTitle("戻る", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.backgroundColor = UIColor.white
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderWidth = 1.0
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(self.tapBackButton), for: .touchUpInside)
        self.addSubview(backButton)

        repeatTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        repeatLabel.translatesAutoresizingMaskIntoConstraints = false
        patternTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        patternLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        countTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        stayTimeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        basicPriceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        basicPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        discountAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        discountAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        gachaAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        gachaAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        salesAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        salesAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        feeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        feeLabel.translatesAutoresizingMaskIntoConstraints = false
        memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        memoLabel.translatesAutoresizingMaskIntoConstraints = false
//        submitButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            repeatTitleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 64),
            repeatTitleLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 64),
            repeatLabel.centerYAnchor.constraint(equalTo: repeatTitleLabel.centerYAnchor),
            repeatLabel.leftAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor, constant: 24),
            
            patternTitleLabel.centerYAnchor.constraint(equalTo: repeatTitleLabel.centerYAnchor),
            patternTitleLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            patternLabel.centerYAnchor.constraint(equalTo: patternTitleLabel.centerYAnchor),
            patternLabel.leftAnchor.constraint(equalTo: patternTitleLabel.rightAnchor, constant: 24),
            
            nameTitleLabel.topAnchor.constraint(equalTo: repeatTitleLabel.bottomAnchor, constant: 24),
            nameTitleLabel.rightAnchor.constraint(equalTo: repeatTitleLabel.rightAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: nameTitleLabel.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: nameTitleLabel.rightAnchor, constant: 24),
            
            countTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 24),
            countTitleLabel.rightAnchor.constraint(equalTo: nameTitleLabel.rightAnchor),
            countLabel.centerYAnchor.constraint(equalTo: countTitleLabel.centerYAnchor),
            countLabel.leftAnchor.constraint(equalTo: countTitleLabel.rightAnchor, constant: 24),
            
            stayTimeTitleLabel.topAnchor.constraint(equalTo: countTitleLabel.bottomAnchor, constant: 24),
            stayTimeTitleLabel.rightAnchor.constraint(equalTo: countTitleLabel.rightAnchor),
            stayTimeLabel.centerYAnchor.constraint(equalTo: stayTimeTitleLabel.centerYAnchor),
            stayTimeLabel.leftAnchor.constraint(equalTo: stayTimeTitleLabel.rightAnchor, constant: 24),
            
            basicPriceTitleLabel.topAnchor.constraint(equalTo: stayTimeLabel.bottomAnchor, constant: 24),
            basicPriceTitleLabel.rightAnchor.constraint(equalTo: stayTimeTitleLabel.rightAnchor),
            basicPriceLabel.centerYAnchor.constraint(equalTo: basicPriceTitleLabel.centerYAnchor),
            basicPriceLabel.leftAnchor.constraint(equalTo: basicPriceTitleLabel.rightAnchor, constant: 24),
            discountAmountTitleLabel.centerYAnchor.constraint(equalTo: basicPriceTitleLabel.centerYAnchor),
            discountAmountTitleLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            discountAmountLabel.centerYAnchor.constraint(equalTo: discountAmountTitleLabel.centerYAnchor),
            discountAmountLabel.leftAnchor.constraint(equalTo: discountAmountTitleLabel.rightAnchor, constant: 24),
            
            gachaAmountTitleLabel.topAnchor.constraint(equalTo: basicPriceTitleLabel.bottomAnchor, constant: 24),
            gachaAmountTitleLabel.rightAnchor.constraint(equalTo: basicPriceTitleLabel.rightAnchor),
            gachaAmountLabel.centerYAnchor.constraint(equalTo: gachaAmountTitleLabel.centerYAnchor),
            gachaAmountLabel.leftAnchor.constraint(equalTo: gachaAmountTitleLabel.rightAnchor, constant: 24),
            salesAmountTitleLabel.centerYAnchor.constraint(equalTo: gachaAmountTitleLabel.centerYAnchor),
            salesAmountTitleLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            salesAmountLabel.centerYAnchor.constraint(equalTo: salesAmountTitleLabel.centerYAnchor),
            salesAmountLabel.leftAnchor.constraint(equalTo: salesAmountTitleLabel.rightAnchor, constant: 24),
            
            feeTitleLabel.topAnchor.constraint(equalTo: gachaAmountTitleLabel.bottomAnchor, constant: 24),
            feeTitleLabel.rightAnchor.constraint(equalTo: gachaAmountTitleLabel.rightAnchor),
            feeLabel.centerYAnchor.constraint(equalTo: feeTitleLabel.centerYAnchor),
            feeLabel.leftAnchor.constraint(equalTo: feeTitleLabel.rightAnchor, constant: 24),
            
            memoTitleLabel.topAnchor.constraint(equalTo: feeTitleLabel.bottomAnchor, constant: 24),
            memoTitleLabel.rightAnchor.constraint(equalTo: feeTitleLabel.rightAnchor),
            memoLabel.centerYAnchor.constraint(equalTo: memoTitleLabel.centerYAnchor),
            memoLabel.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 24),
            backButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            backButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    // キャンセルボタンタップ時のイベント
    @objc func tapBackButton() {
        delegate?.tapBackButton()
    }

    func commaSeparateThreeDigits(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}
