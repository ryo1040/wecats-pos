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
        
        repeatTitleLabel.text = "新規/リピーター："
        repeatTitleLabel.font = UIFont.systemFont(ofSize: 32)
        repeatTitleLabel.textColor = UIColor.black
        self.addSubview(repeatTitleLabel)
        
        repeatLabel.text = "リピーター"
        repeatLabel.font = UIFont.systemFont(ofSize: 32)
        repeatLabel.textColor = UIColor.black
        self.addSubview(repeatLabel)
        
        patternTitleLabel.text = "パターン："
        patternTitleLabel.font = UIFont.systemFont(ofSize: 32)
        patternTitleLabel.textColor = UIColor.black
        self.addSubview(patternTitleLabel)
        
        patternLabel.text = "家族"
        patternLabel.font = UIFont.systemFont(ofSize: 32)
        patternLabel.textColor = UIColor.black
        self.addSubview(patternLabel)
        
        nameTitleLabel.text = "氏名："
        nameTitleLabel.font = UIFont.systemFont(ofSize: 32)
        nameTitleLabel.textColor = UIColor.black
        self.addSubview(nameTitleLabel)
        
        nameLabel.text = ""
        nameLabel.font = UIFont.systemFont(ofSize: 32)
        nameLabel.textColor = UIColor.black
        self.addSubview(nameLabel)
        
        countTitleLabel.text = "人数："
        countTitleLabel.font = UIFont.systemFont(ofSize: 32)
        countTitleLabel.textColor = UIColor.black
        self.addSubview(countTitleLabel)
        
        countLabel.text = "大人：1人、子ども：1人"
        countLabel.font = UIFont.systemFont(ofSize: 32)
        countLabel.textColor = UIColor.black
        self.addSubview(countLabel)

        stayTimeTitleLabel.text = "滞在時間："
        stayTimeTitleLabel.font = UIFont.systemFont(ofSize: 32)
        stayTimeTitleLabel.textColor = UIColor.black
        self.addSubview(stayTimeTitleLabel)

        stayTimeLabel.text = "13:00〜15:00 120分"
        stayTimeLabel.font = UIFont.systemFont(ofSize: 32)
        stayTimeLabel.textColor = UIColor.black
        stayTimeLabel.textAlignment = .center
        self.addSubview(stayTimeLabel)
        
        basicPriceTitleLabel.text = "基本料金："
        basicPriceTitleLabel.font = UIFont.systemFont(ofSize: 32)
        basicPriceTitleLabel.textColor = UIColor.black
        self.addSubview(basicPriceTitleLabel)
        
        basicPriceLabel.text = "1,800円"
        basicPriceLabel.font = UIFont.systemFont(ofSize: 32)
        basicPriceLabel.textColor = UIColor.black
        self.addSubview(basicPriceLabel)
        
        discountAmountTitleLabel.text = "割引額："
        discountAmountTitleLabel.font = UIFont.systemFont(ofSize: 32)
        discountAmountTitleLabel.textColor = UIColor.black
        self.addSubview(discountAmountTitleLabel)
        
        discountAmountLabel.text = "300円"
        discountAmountLabel.font = discountAmountLabel.font?.withSize(32)
        discountAmountLabel.textColor = UIColor.red
        discountAmountLabel.textAlignment = .center
        self.addSubview(discountAmountLabel)
        
        gachaAmountTitleLabel.text = "ガチャ額："
        gachaAmountTitleLabel.font = UIFont.systemFont(ofSize: 32)
        gachaAmountTitleLabel.textColor = UIColor.black
        self.addSubview(gachaAmountTitleLabel)
        
        gachaAmountLabel.text = "400円"
        gachaAmountLabel.font = gachaAmountLabel.font?.withSize(32)
        gachaAmountLabel.textColor = UIColor.black
        gachaAmountLabel.textAlignment = .center
        self.addSubview(gachaAmountLabel)

        salesAmountTitleLabel.text = "販売額："
        salesAmountTitleLabel.font = UIFont.systemFont(ofSize: 32)
        salesAmountTitleLabel.textColor = UIColor.black
        self.addSubview(salesAmountTitleLabel)
        
        salesAmountLabel.text = "100円"
        salesAmountLabel.font = salesAmountLabel.font?.withSize(32)
        salesAmountLabel.textColor = UIColor.black
        salesAmountLabel.textAlignment = .center
        self.addSubview(salesAmountLabel)
        
        feeTitleLabel.text = "料金："
        feeTitleLabel.font = UIFont.systemFont(ofSize: 32)
        feeTitleLabel.textColor = UIColor.black
        self.addSubview(feeTitleLabel)
        
        feeLabel.text = "2,000円"
        feeLabel.font = UIFont.systemFont(ofSize: 32)
        feeLabel.textColor = UIColor.black
        feeLabel.textAlignment = .center
        self.addSubview(feeLabel)
        
        memoTitleLabel.text = "メモ："
        memoTitleLabel.font = UIFont.systemFont(ofSize: 32)
        memoTitleLabel.textColor = UIColor.black
        memoTitleLabel.textAlignment = .center
        self.addSubview(memoTitleLabel)
        
        memoLabel.text = "メモ"
        memoLabel.textColor = UIColor.black
        memoLabel.font = UIFont.systemFont(ofSize: 32)
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
