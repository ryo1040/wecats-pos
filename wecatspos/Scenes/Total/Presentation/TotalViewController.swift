//
//  TotalViewController.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/09.
//

import Foundation
import UIKit
import RxSwift

protocol TotalViewControllerProtocol {
    
}

final class TotalViewController: UIViewController, TotalViewControllerProtocol {
    
    var presenter: TotalPresenterProtocol!

    // TitleView
    let titleView = TitleView()
    
    // main
    let mainLabel = UILabel()
    let dayTotalButton = UIButton()
    let monthTotalButton = UIButton()
    var stackView = UIStackView()
    
    // Views
    let dayTotalView = DayTotalView()
    let monthTotalView = MonthTotalView()
    let visitorInfoView = VisitorInfoView()
    let editVisitorInfoView = EditVisitorInfoView()
    
    var activityIndicator: UIActivityIndicatorView!
    var overlayView: UIView!
    
    private let disposeBag = DisposeBag()
    
    public func inject(presenter: TotalPresenterProtocol) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setSubscribe()
        
        setupActivityIndicator()

        startLoading()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        presenter.load(date: formatter.string(from: Date()))
    }
}

// MARK: - 外観の調整

private extension TotalViewController {
    
    func setupViews() {
        // TitleViewの追加
        titleView.delegate = self
        self.view.addSubview(titleView)
        
        mainLabel.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        mainLabel.isUserInteractionEnabled = true
        self.view.addSubview(mainLabel)
        
        dayTotalButton.backgroundColor = UIColor.lightGray
        dayTotalButton.setTitle("日別集計", for: .normal)
        dayTotalButton.setTitleColor(UIColor.white, for: .normal)
//        dayTotalButton.layer.borderWidth = 0.5
        dayTotalButton.addTarget(self, action: #selector(self.tapDayTotalButton(_:)), for: UIControl.Event.touchUpInside)
        
        monthTotalButton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        monthTotalButton.setTitle("月別集計", for: .normal)
        monthTotalButton.setTitleColor(.black, for: .normal)
//        monthTotalButton.layer.borderWidth = 0.5
        monthTotalButton.addTarget(self, action: #selector(self.tapMonthTotalButton(_:)), for: UIControl.Event.touchUpInside)
        
        stackView.backgroundColor = UIColor.red
        stackView = UIStackView(arrangedSubviews: [self.dayTotalButton, self.monthTotalButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        mainLabel.addSubview(stackView)
        
        dayTotalView.isHidden = false
        dayTotalView.delegate = self
        mainLabel.addSubview(dayTotalView)
        
        monthTotalView.isHidden = true
        monthTotalView.delegate = self
        mainLabel.addSubview(monthTotalView)
        
        visitorInfoView.isHidden = true
        visitorInfoView.delegate = self
        mainLabel.addSubview(visitorInfoView)
        
        editVisitorInfoView.isHidden = true
        editVisitorInfoView.delegate = self
        mainLabel.addSubview(editVisitorInfoView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        dayTotalButton.translatesAutoresizingMaskIntoConstraints = false
        monthTotalButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        dayTotalView.translatesAutoresizingMaskIntoConstraints = false
        monthTotalView.translatesAutoresizingMaskIntoConstraints = false
        visitorInfoView.translatesAutoresizingMaskIntoConstraints = false
        editVisitorInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            dayTotalButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            monthTotalButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
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
                dayTotalView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                dayTotalView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                dayTotalView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                dayTotalView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                monthTotalView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                monthTotalView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                monthTotalView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                monthTotalView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                visitorInfoView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                visitorInfoView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                visitorInfoView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                visitorInfoView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                editVisitorInfoView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                editVisitorInfoView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                editVisitorInfoView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                editVisitorInfoView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor)
            ])
        } else { // 通常の画面の場合
            dayTotalButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            monthTotalButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
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
                dayTotalView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                dayTotalView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                dayTotalView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                dayTotalView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                monthTotalView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                monthTotalView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                monthTotalView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                monthTotalView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                visitorInfoView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                visitorInfoView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                visitorInfoView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                visitorInfoView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                editVisitorInfoView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                editVisitorInfoView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                editVisitorInfoView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                editVisitorInfoView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor)
            ])
        }
    }
    
    func setSubscribe() {
        presenter.viewGuestInfo
            .subscribe(onNext: { [unowned self] model in
                print("Received guest info data: \(model)") // デバッグログ
                dayTotalView.guestList = model.filter { !$0.stayingFlag }.sorted(by: { $0.leftTime < $1.leftTime })
                dayTotalView.calcDayTotalFee()
                dayTotalView.tableView.reloadData()
                visitorInfoView.isHidden = true
                editVisitorInfoView.isHidden = true
                stopLoading()
            }).disposed(by: disposeBag)
        
        presenter.viewTotalAmountList
            .subscribe(onNext: { [unowned self] model in
                print("Received guest info data: \(model)") // デバッグログ
                monthTotalView.totalAmountList = model.sorted(by: { $0.date < $1.date })
                monthTotalView.calcMonthTotalFee()
                monthTotalView.tableView.reloadData()
                visitorInfoView.isHidden = true
                editVisitorInfoView.isHidden = true
                stopLoading()
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

    @objc func tapDayTotalButton(_ sender: UIButton) {
        startLoading()
        presenter.load(date: dayTotalView.dayLabel.text!.replacingOccurrences(of: "/", with: "-"))
        dayTotalView.isHidden = false
        monthTotalView.isHidden = true
        dayTotalButton.backgroundColor = UIColor.lightGray
        monthTotalButton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        dayTotalButton.setTitleColor(UIColor.white, for: .normal)
        monthTotalButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @objc func tapMonthTotalButton(_ sender: UIButton) {
        startLoading()
        let formatter_data = DateFormatter()
        formatter_data.dateFormat = "yyyy-MM"
        presenter.getTotalAmountList(month: formatter_data.string(from: Date()))
        dayTotalView.isHidden = true
        monthTotalView.isHidden = false
        dayTotalButton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        monthTotalButton.backgroundColor = UIColor.lightGray
        dayTotalButton.setTitleColor(UIColor.black, for: .normal)
        monthTotalButton.setTitleColor(UIColor.white, for: .normal)
    }
}

extension TotalViewController: TitleDelegate {
    func tapMenuButton() {
        presenter.didTapMenuButton()
    }
}

extension TotalViewController: DayTotalDelegate {
    func changeDay(day: String) {
        startLoading()
        presenter.load(date: day)
    }
    
    func tapDayTotalTableViewRow(selectGuestInfo: GuestInfoModel) {
        visitorInfoView.setVisitorInfo(selectGuestInfo: selectGuestInfo)
        visitorInfoView.isHidden = false
    }
    
    func tapDeleteDayTotalTableVieRow(selectGuestInfo: GuestInfoModel) {
        presenter.didTapDeleteButton(id: selectGuestInfo.id, date: selectGuestInfo.date)
    }
    
    func tapEditDayTotalTableViewRow(selectGuestInfo: GuestInfoModel) {
        editVisitorInfoView.setVisitorInfo(selectGuestInfo: selectGuestInfo)
        editVisitorInfoView.isHidden = false
    }
}

extension TotalViewController: MonthTotalDelegate {
    func changeMonth(month: String) {
        startLoading()
        presenter.getTotalAmountList(month: month)
    }
}

extension TotalViewController: VisitorInfoDelegate {
    func tapBackButton() {
        visitorInfoView.isHidden = true
    }
}

extension TotalViewController: EditVisitorInfoDelegate {
    func tapEditVisitorInfoUpdateButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String){
        presenter.didTapEditVisitorInfoUpdateButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: salesAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
    }
    
    func tapEditVisitorInfoBackButton() {
        editVisitorInfoView.isHidden = true
    }
}
