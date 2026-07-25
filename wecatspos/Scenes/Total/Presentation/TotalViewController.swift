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
    let salesView = SalesView()
    let reservationNightView = ReservationNightView()
    
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
        
        salesView.isHidden = true
        salesView.delegate = self
        mainLabel.addSubview(salesView)
        
        reservationNightView.isHidden = true
        reservationNightView.delegate = self
        mainLabel.addSubview(reservationNightView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        dayTotalButton.translatesAutoresizingMaskIntoConstraints = false
        monthTotalButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        dayTotalView.translatesAutoresizingMaskIntoConstraints = false
        monthTotalView.translatesAutoresizingMaskIntoConstraints = false
        visitorInfoView.translatesAutoresizingMaskIntoConstraints = false
        editVisitorInfoView.translatesAutoresizingMaskIntoConstraints = false
        salesView.translatesAutoresizingMaskIntoConstraints = false
        reservationNightView.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        if LayoutBreakpoint.isCompact(sideLength: screenWidth) { // 小さい画面の場合
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
                editVisitorInfoView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                salesView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                salesView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                salesView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                salesView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                reservationNightView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                reservationNightView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                reservationNightView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                reservationNightView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor)
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
                editVisitorInfoView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                salesView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                salesView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                salesView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                salesView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                reservationNightView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                reservationNightView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                reservationNightView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                reservationNightView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor)
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
                salesView.isHidden = true
                reservationNightView.isHidden = true
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
                salesView.isHidden = true
                reservationNightView.isHidden = true
                stopLoading()
            }).disposed(by: disposeBag)
        
        presenter.viewSales
            .subscribe(onNext: { [unowned self] model in
                print("Received cat info data: \(model)")
                salesView.readOnlyFlg = true
                salesView.setItems(salesMasterModel: model.salesMasterModel, salesModel: model.salesModel)
                visitorInfoView.isHidden = true
                editVisitorInfoView.isHidden = true
                salesView.isHidden = false
                reservationNightView.isHidden = true
                stopLoading()
            }).disposed(by: disposeBag)
        
        presenter.getReservationNightInfo
            .subscribe(onNext: { [unowned self] model in
                reservationNightView.setReservationNightInfo(reservationNightViewModel: model)
                reservationNightView.isHidden = false
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
        overlayView.frame = view.bounds
        activityIndicator.center = overlayView.center
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
        formatter_data.dateFormat = "yyyy/MM"
        monthTotalView.monthLabel.text = formatter_data.string(from: Date())
        dayTotalView.isHidden = true
        monthTotalView.isHidden = false
        dayTotalButton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        monthTotalButton.backgroundColor = UIColor.lightGray
        dayTotalButton.setTitleColor(UIColor.black, for: .normal)
        monthTotalButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func extractInteger(from text: String, pattern: String) -> Int? {
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
              let range = Range(match.range(at: 1), in: text) else {
            return nil
        }
        return Int(text[range])
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
        if selectGuestInfo.name == "物販" {
            startLoading()
            presenter.getSales(date: selectGuestInfo.date)
        } else if selectGuestInfo.name!.hasPrefix("夜猫カフェ") {
            if let memo = selectGuestInfo.memo,
                let range = memo.range(of: #"\d{4}-\d{2}-\d{2}"#, options: .regularExpression) {
                let date = String(memo[range])
                var name = selectGuestInfo.name!
                name.removeFirst("夜猫カフェ".count)
                name.removeLast("様".count)
                startLoading()
                reservationNightView.updateFlg = false
                reservationNightView.selectedVisitorHistoryId = selectGuestInfo.id
                presenter.getReservationNightInfo(date: date, name: name)
            }
        } else {
            visitorInfoView.setVisitorInfo(selectGuestInfo: selectGuestInfo)
            visitorInfoView.isHidden = false
        }
    }
    
    func tapDeleteDayTotalTableVieRow(selectGuestInfo: GuestInfoModel) {
        if selectGuestInfo.name!.hasPrefix("夜猫カフェ") {
            if let memo = selectGuestInfo.memo {
                var name = selectGuestInfo.name!
                name.removeFirst("夜猫カフェ".count)
                name.removeLast("様".count)
                let id = extractInteger(from: memo, pattern: #"reservation_id:\s*(-?\d+)"#) ?? -1
                let branch = extractInteger(from: memo, pattern: #"branch:\s*(-?\d+)"#) ?? -1
                presenter.didTapReservationNightDeleteButton(id: id, branch: branch, date: selectGuestInfo.date, visitorHistoryId: selectGuestInfo.id)
            }
        } else {
            presenter.didTapDeleteButton(id: selectGuestInfo.id, date: selectGuestInfo.date)
        }
    }
    
    func tapEditDayTotalTableViewRow(selectGuestInfo: GuestInfoModel) {
        if let name = selectGuestInfo.name, !name.isEmpty {
            if selectGuestInfo.name!.hasPrefix("夜猫カフェ") {
                if let memo = selectGuestInfo.memo,
                    let range = memo.range(of: #"\d{4}-\d{2}-\d{2}"#, options: .regularExpression) {
                    let date = String(memo[range])
                    var name = selectGuestInfo.name!
                    name.removeFirst("夜猫カフェ".count)
                    name.removeLast("様".count)
                    startLoading()
                    reservationNightView.updateFlg = true
                    reservationNightView.selectedVisitorHistoryId = selectGuestInfo.id
                    presenter.getReservationNightInfo(date: date, name: name)
                }
            } else {
                editVisitorInfoView.setVisitorInfo(selectGuestInfo: selectGuestInfo)
                editVisitorInfoView.isHidden = false
            }
        } else {
            editVisitorInfoView.setVisitorInfo(selectGuestInfo: selectGuestInfo)
            editVisitorInfoView.isHidden = false
        }
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
    func tapEditVisitorInfoUpdateButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, saleAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String){
        presenter.didTapEditVisitorInfoUpdateButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, saleAmount: saleAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
    }
    
    func tapEditVisitorInfoBackButton() {
        editVisitorInfoView.isHidden = true
    }
}

extension TotalViewController: SalesViewDelegate {
    func tapSalesRegisterButton(sales: [SalesModel], totalAmount: Int) {
        // TotalViewControllerではRegisterButtonをタップされることはない
    }
    
    func tapSalesCancelButton() {
        salesView.isHidden = true
    }
    
    func salesViewWillClose(hasUnsavedChanges: Bool, completion: @escaping (Bool) -> Void) {
        // TotalViewControllerでは値が変更されることはない
    }
}

extension TotalViewController: ReservationNightViewDelegate {
    func tapReservationNightSubmitButton(id: Int, branch: Int, date: String, name: String, tel: String, count: Int, price: Int, memo: String, visitorHistoryId: Int) {
        startLoading()
        presenter.didTapReservationNightSubmitButton(id: id, branch: branch, date: date, name: name, tel: tel, count: count, price: price, memo: memo, visitorHistoryId: visitorHistoryId)
    }
    
    func tapReservationNightCancelButton() {
        reservationNightView.isHidden = true
    }
}
