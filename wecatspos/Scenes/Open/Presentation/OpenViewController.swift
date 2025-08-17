//
//  OpenViewController.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/03.
//

import Foundation
import UIKit
import RxSwift

protocol OpenViewControllerProtocol {
    
}

final class OpenViewController: UIViewController, OpenViewControllerProtocol {
    
    var presenter: OpenPresenterProtocol!
    
    // TitleView
    let titleView = TitleView()
    
    // main
    let mainLabel = UILabel()
    let stayingButton = UIButton()
    let leftBotton = UIButton()
    var stackView = UIStackView()
    
    // Views
    let stayingView = StayingView()
    let leftView = LeftView()
    let enterView = EnterView()
    let leaveView = LeaveView()
    let visitorInfoView = VisitorInfoView()
    let editVisitorInfoView = EditVisitorInfoView()
    
    var activityIndicator: UIActivityIndicatorView!
    var overlayView: UIView!
    
    private let disposeBag = DisposeBag()
    
    public func inject(presenter: OpenPresenterProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setSubscribe()
        
        setupActivityIndicator()

        startLoading()
        presenter.load()
    }
}

// MARK: - 外観の調整

private extension OpenViewController {
    
    func setupViews() {
        // TitleViewの追加
        titleView.delegate = self
        self.view.addSubview(titleView)
        
        mainLabel.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        mainLabel.isUserInteractionEnabled = true
        self.view.addSubview(mainLabel)
        
        stayingButton.backgroundColor = UIColor.lightGray
        stayingButton.setTitle("滞在中", for: .normal)
        stayingButton.setTitleColor(UIColor.white, for: .normal)
//        stayingButton.layer.borderWidth = 0.5
        stayingButton.addTarget(self, action: #selector(self.tapStayingButton(_:)), for: UIControl.Event.touchUpInside)
        
        leftBotton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        leftBotton.setTitle("退店済", for: .normal)
        leftBotton.setTitleColor(.black, for: .normal)
//        leftBotton.layer.borderWidth = 0.5
        leftBotton.addTarget(self, action: #selector(self.tapLeftBotton(_:)), for: UIControl.Event.touchUpInside)
        
        stackView.backgroundColor = UIColor.red
        stackView = UIStackView(arrangedSubviews: [self.stayingButton, self.leftBotton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        mainLabel.addSubview(stackView)
        
        stayingView.isHidden = false
        stayingView.delegate = self
        mainLabel.addSubview(stayingView)
        
        leftView.isHidden = true
        leftView.delegate = self
        mainLabel.addSubview(leftView)
        
        enterView.isHidden = true
        enterView.delegate = self
        mainLabel.addSubview(enterView)
        
        leaveView.isHidden = true
        leaveView.delegate = self
        mainLabel.addSubview(leaveView)
        
        visitorInfoView.isHidden = true
        visitorInfoView.delegate = self
        mainLabel.addSubview(visitorInfoView)
        
        editVisitorInfoView.isHidden = true
        editVisitorInfoView.delegate = self
        mainLabel.addSubview(editVisitorInfoView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        stayingButton.translatesAutoresizingMaskIntoConstraints = false
        leftBotton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stayingView.translatesAutoresizingMaskIntoConstraints = false
        leftView.translatesAutoresizingMaskIntoConstraints = false
        enterView.translatesAutoresizingMaskIntoConstraints = false
        leaveView.translatesAutoresizingMaskIntoConstraints = false
        visitorInfoView.translatesAutoresizingMaskIntoConstraints = false
        editVisitorInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            stayingButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            leftBotton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
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
                stayingView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                stayingView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                stayingView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                stayingView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                leftView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                leftView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                leftView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                leftView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                enterView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                enterView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                enterView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                enterView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                leaveView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                leaveView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                leaveView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                leaveView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
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
            stayingButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            leftBotton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
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
                stayingView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                stayingView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                stayingView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                stayingView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                leftView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                leftView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                leftView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                leftView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                enterView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                enterView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                enterView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                enterView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                leaveView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                leaveView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                leaveView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                leaveView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
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
                stayingView.stayingList = model.filter { $0.stayingFlag }.sorted(by: { $0.enterTime < $1.enterTime })
                stayingView.tableView.reloadData()
                leftView.leftList = model.filter { !$0.stayingFlag }.sorted(by: { $0.enterTime < $1.enterTime })
                leftView.calcDayTotalFee()
                leftView.tableView.reloadData()
                enterView.isHidden = true
                leaveView.isHidden = true
                visitorInfoView.isHidden = true
                editVisitorInfoView.isHidden = true
                stopLoading()
            }).disposed(by: disposeBag)
        
        presenter.viewEntry
            .subscribe(onNext: { [unowned self] model in
                print("Received create guest info: \(model)")
                stayingView.stayingList = model.filter { $0.stayingFlag }.sorted(by: { $0.enterTime < $1.enterTime })
                stayingView.tableView.reloadData()
                leftView.leftList = model.filter { !$0.stayingFlag }.sorted(by: { $0.enterTime < $1.enterTime })
                leftView.calcDayTotalFee()
                leftView.tableView.reloadData()
                enterView.isHidden = true
                leaveView.isHidden = true
                visitorInfoView.isHidden = true
                editVisitorInfoView.isHidden = true
                stopLoading()
            }).disposed(by: disposeBag)
        
        presenter.viewLeave
            .subscribe(onNext: { [unowned self] model in
                print("Received cat info data: \(model)")
                stayingView.stayingList = model.filter { $0.stayingFlag }.sorted(by: { $0.enterTime < $1.enterTime })
                stayingView.tableView.reloadData()
                leftView.leftList = model.filter { !$0.stayingFlag }.sorted(by: { $0.enterTime < $1.enterTime })
                leftView.calcDayTotalFee()
                leftView.tableView.reloadData()
                enterView.isHidden = true
                leaveView.isHidden = true
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
    
    @objc func tapStayingButton(_ sender: UIButton) {
        startLoading()
        presenter.load()
        stayingView.isHidden = false
        leftView.isHidden = true
        stayingButton.backgroundColor = UIColor.lightGray
        leftBotton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        stayingButton.setTitleColor(UIColor.white, for: .normal)
        leftBotton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @objc func tapLeftBotton(_ sender: UIButton) {
        startLoading()
        presenter.load()
        stayingView.isHidden = true
        leftView.isHidden = false
        stayingButton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        leftBotton.backgroundColor = UIColor.lightGray
        stayingButton.setTitleColor(UIColor.black, for: .normal)
        leftBotton.setTitleColor(UIColor.white, for: .normal)
    }
}

extension OpenViewController: StayingDelegate {
    func tapEnterStoreButton() {
        enterView.setEnterInfo()
        enterView.isHidden = false
    }
    
    func tapTableViewRow(selectGuestInfo: GuestInfoModel) {
        leaveView.setLeaveInfo(id: selectGuestInfo.id, repeatFlag: selectGuestInfo.repeatFlag, patternId: selectGuestInfo.patternId, name: selectGuestInfo.name, date: selectGuestInfo.date, holidayFlag: selectGuestInfo.holidayFlag, kidsdayFlag: selectGuestInfo.kidsdayFlag, enterTime: selectGuestInfo.enterTime, adultCount: selectGuestInfo.adultCount, childCount: selectGuestInfo.childCount, memo: selectGuestInfo.memo ?? "")
        leaveView.isHidden = false
    }
    
    func tapDeleteTableVieRow(selectGuestInfo: GuestInfoModel) {
        presenter.didTapDeleteButton(id: selectGuestInfo.id, date: selectGuestInfo.date)
    }

    func tapEditTableViewRow(selectGuestInfo: GuestInfoModel) {
        enterView.editEnterInfo(selectGuestInfo: selectGuestInfo)
        enterView.isHidden = false
    }
}

extension OpenViewController: LeftDelegate {
    func tapLeftTableViewRow(selectGuestInfo: GuestInfoModel) {
        visitorInfoView.setVisitorInfo(selectGuestInfo: selectGuestInfo)
        visitorInfoView.isHidden = false
    }
    
    func tapDeleteLeftTableVieRow(selectGuestInfo: GuestInfoModel) {
        presenter.didTapDeleteButton(id: selectGuestInfo.id, date: selectGuestInfo.date)
    }

    func tapEditLeftTableViewRow(selectGuestInfo: GuestInfoModel) {
        editVisitorInfoView.setVisitorInfo(selectGuestInfo: selectGuestInfo)
        editVisitorInfoView.isHidden = false
    }
}

extension OpenViewController: TitleDelegate {
    func tapMenuButton() {
        presenter.didTapMenuButton()
    }
}

extension OpenViewController: EnterDelegate {
    func checkDayInfo(date: Date) {
        switch presenter.checkDay(date: date) {
        case 1:
            enterView.holidayFlag = true
            enterView.kidsdayFlag = false
        case 2:
            enterView.holidayFlag = false
            enterView.kidsdayFlag = true
        case 3:
            enterView.holidayFlag = true
            enterView.kidsdayFlag = true
        default:
            enterView.holidayFlag = false
            enterView.kidsdayFlag = false
        }
        
    }
    
    func tapEnterCancelButton() {
        enterView.isHidden = true
    }
    
    func tapEnterSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String) {
        startLoading()
        presenter.didTapEnterSubmitButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsdayFlag: kidsdayFlag, enterTime: enterTime, countAdult: countAdult, countChild: countChild, memo: memo)
    }
    
    func tapUpdateSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String) {
        startLoading()
        presenter.didTapUpdateSubmitButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsdayFlag: kidsdayFlag, enterTime: enterTime, countAdult: countAdult, countChild: countChild, memo: memo)
    }
}

extension OpenViewController: LeaveDelegate {

    func tapLeaveCancelButton() {
        leaveView.isHidden = true
    }
    
    func tapLeaveSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String) {
        startLoading()
        presenter.didTapLeaveSubmitButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: salesAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
    }
}

extension OpenViewController: VisitorInfoDelegate {
    func tapBackButton() {
        visitorInfoView.isHidden = true
    }
}

extension OpenViewController: EditVisitorInfoDelegate {
    func tapEditVisitorInfoUpdateButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String){
        presenter.didTapEditVisitorInfoUpdateButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: salesAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
    }
    
    func tapEditVisitorInfoBackButton() {
        editVisitorInfoView.isHidden = true
    }
}
