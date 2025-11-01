//
//  CloseViewController.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/19.
//

import Foundation
import UIKit
import RxSwift

protocol CloseViewControllerProtocol {
    
}

final class CloseViewController: UIViewController, CloseViewControllerProtocol {
    
    var presenter: ClosePresenterProtocol!
    
    // TitleView
    let titleView = TitleView()
    
    // main
    let mainLabel = UILabel()
    let closeRegisterButton = UIButton()
    let blankView = UIView()
    var stackView = UIStackView()
    
    // Views
    let closeRegisterView = CloseRegisterView()
    let denominationView = DenominationView()
    
    var activityIndicator: UIActivityIndicatorView!
    var overlayView: UIView!
    
    private let disposeBag = DisposeBag()
    
    public func inject(presenter: ClosePresenterProtocol) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setSubscribe()
        
        setupActivityIndicator()

        startLoading()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        presenter.load(month: formatter.string(from: Date()))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // DenominationViewが表示される際にスクロール位置を初期化
        denominationView.resetScrollPosition()
    }
}

// MARK: - 外観の調整

private extension CloseViewController {
    
    func setupViews() {
        // TitleViewの追加
        titleView.delegate = self
        self.view.addSubview(titleView)
        
        mainLabel.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        mainLabel.isUserInteractionEnabled = true
        self.view.addSubview(mainLabel)
        
        closeRegisterButton.backgroundColor = UIColor.lightGray
        closeRegisterButton.setTitle("金種表", for: .normal)
        closeRegisterButton.setTitleColor(UIColor.white, for: .normal)
//        closeRegisterButton.addTarget(self, action: #selector(self.tapStayingButton(_:)), for: UIControl.Event.touchUpInside)
        
//        blankView.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        blankView.backgroundColor = UIColor.lightGray

        stackView.backgroundColor = UIColor.red
        stackView = UIStackView(arrangedSubviews: [self.closeRegisterButton, self.blankView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        mainLabel.addSubview(stackView)
        
        closeRegisterView.isHidden = false
        closeRegisterView.delegate = self
        mainLabel.addSubview(closeRegisterView)
        
        denominationView.isHidden = true
        denominationView.delegate = self
        mainLabel.addSubview(denominationView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        closeRegisterView.translatesAutoresizingMaskIntoConstraints = false
        denominationView.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            closeRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)

            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                titleView.heightAnchor.constraint(equalToConstant: 50),
                mainLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                mainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                mainLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                mainLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                stackView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                stackView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                stackView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                stackView.heightAnchor.constraint(equalToConstant: 40),
                closeRegisterView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                closeRegisterView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                closeRegisterView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                closeRegisterView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                denominationView.topAnchor.constraint(equalTo:  mainLabel.topAnchor),
                denominationView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                denominationView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                denominationView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
            ])
        } else { // 通常の画面の場合
            closeRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                titleView.heightAnchor.constraint(equalToConstant: 100),
                mainLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                mainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                mainLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                mainLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                stackView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                stackView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                stackView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                stackView.heightAnchor.constraint(equalToConstant: 80),
                closeRegisterView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                closeRegisterView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                closeRegisterView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                closeRegisterView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                denominationView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                denominationView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                denominationView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                denominationView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
            ])
        }
    }
    
    func setSubscribe() {
        presenter.viewCloseResister
            .subscribe(onNext: { [unowned self] model in
                print("Received close registrer data: \(model)") // デバッグログ
                closeRegisterView.denominationList = model.sorted(by: { $0.date < $1.date })
                closeRegisterView.tableView.reloadData()

                // 当日のデータが存在しないかチェック
                // 当日の日付を取得
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let today = formatter.string(from: Date())
                
                // denominationListに当日のデータが存在するかチェック
                let hasTodayData = model.contains { denomination in
                    return denomination.date == today
                }
                
                if hasTodayData {
                    closeRegisterView.newButton.isEnabled = false
                    closeRegisterView.newButton.backgroundColor = UIColor.lightGray
                }
                
                denominationView.isHidden = true
                stopLoading()
            }).disposed(by: disposeBag)
        
        presenter.viewCheckResult
            .subscribe(onNext: { [unowned self] model in
                stopLoading()
                denominationView.dailySalesLabel.text = commaSeparateThreeDigits(model.todaySales) + "円"
                if model.status != 200 {
                    // TODO: 一時的に登録ボタン非活性化をコメントアウト
//                    denominationView.changeSubmitButtonEnabled(enabled: false)
                } else {
                    denominationView.changeSubmitButtonEnabled(enabled: true)
                }
            }).disposed(by: disposeBag)
    }
    
    func setupActivityIndicator() {
        // 半透明のビューを作成
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 半透明の黒
        overlayView.isHidden = true // 初期状態では非表示
        view.addSubview(overlayView)
        
        // アクティビティインジケーターを作成
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = overlayView.center
        activityIndicator.hidesWhenStopped = true // アニメーション停止時に非表示
        overlayView.addSubview(activityIndicator)
    }

    func startLoading() {
        overlayView.isHidden = false // 半透明ビューを表示
        activityIndicator.startAnimating() // クルクル開始
    }

    func stopLoading() {
        activityIndicator.stopAnimating() // クルクル終了
        overlayView.isHidden = true // 半透明ビューを非表示
    }
    
    func commaSeparateThreeDigits(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}

extension CloseViewController: TitleDelegate {
    func tapMenuButton() {
        presenter.didTapMenuButton()
    }
}

extension CloseViewController: CloseRegisterDelegate {
    func changeMonth(month: String) {
        startLoading()
        presenter.load(month: month)
    }
    
    func tapNewButton() {
        denominationView.setInitialDenomination()
        denominationView.isHidden = false
    }
    
    func tapTableViewRow(selectedDenomination: DenominationModel) {
        denominationView.setDenomination(selectedDenomination: selectedDenomination, enable: false)
        denominationView.isHidden = false
    }
    
    func tapEditTableViewRow(selectedDenomination: DenominationModel) {
        denominationView.setDenomination(selectedDenomination: selectedDenomination, enable: true)
        denominationView.isHidden = false
    }
    
    func tapDeleteTableViewRow(selectedDenomination: DenominationModel) {
        presenter.didTapDenominationDeleteButton(date: selectedDenomination.date)
    }
}

extension CloseViewController: DenominationDelegate {
    func tapDenominationSubmitButton(date: String, tenThousandYenCount: Int, fiveThousandYenCount: Int, twoThousandYenCount: Int, oneThousandYenCount: Int, fiveHundredYenCount: Int, oneHundredYenCount: Int, fiftyYenCount: Int, tenYenCount: Int, fiveYenCount: Int, oneYenCount: Int, exportAmount: Int, ticketAmount: Int, totalAmount: Int, memo: String) {
        startLoading()
        presenter.didTapDenominationSubmitButton(date: date, tenThousandYenCount: tenThousandYenCount, fiveThousandYenCount: fiveThousandYenCount, twoThousandYenCount: twoThousandYenCount, oneThousandYenCount: oneThousandYenCount, fiveHundredYenCount: fiveHundredYenCount, oneHundredYenCount: oneHundredYenCount, fiftyYenCount: fiftyYenCount, tenYenCount: tenYenCount, fiveYenCount: fiveYenCount, oneYenCount: oneYenCount, exportAmount: exportAmount, ticketAmount: ticketAmount, totalAmount: totalAmount, memo: memo)
    }
    
    func tapDenominationCancelButton() {
        denominationView.isHidden = true
    }
    
    func checkTotalAmount(date: String, totalAmount: Int, ticketAmount: Int, exportAmount: Int) {
        startLoading()
        presenter.checkTotalAmount(date: date, totalAmount: totalAmount, ticketAmount: ticketAmount, exportAmount: exportAmount)
    }
    
}
