//
//  SettingsViewController.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import Foundation
import UIKit
import RxSwift

protocol SettingsViewControllerProtocol {
    
}

final class SettingsViewController: UIViewController, SettingsViewControllerProtocol {
    
    var presenter: SettingsPresenterProtocol!
    
    // TitleView
    let titleView = TitleView()
    
    // main
    let mainLabel = UILabel()
    let salesButton = UIButton()
    let dummy1Botton = UIButton()
    var stackView = UIStackView()
    
    // view
    let salesSettingsView = SalesSettingsView()
    let editSalesSettingsView = EditSalesSettingsView()
    
    var activityIndicator: UIActivityIndicatorView!
    var overlayView: UIView!

    private let disposeBag = DisposeBag()
    
    public func inject(presenter: SettingsPresenterProtocol) {
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

private extension SettingsViewController {
    
    func setupViews() {
        // TitleViewの追加
        titleView.delegate = self
        self.view.addSubview(titleView)
        
        mainLabel.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        mainLabel.isUserInteractionEnabled = true
        self.view.addSubview(mainLabel)
        
        salesButton.backgroundColor = UIColor.lightGray
        salesButton.setTitle("物販", for: .normal)
        salesButton.setTitleColor(.white, for: .normal)
        //        salesButton.addTarget(self, action: #selector(self.tapSalesButton(_:)), for: UIControl.Event.touchUpInside)
        
        dummy1Botton.backgroundColor = UIColor.lightGray
        
        stackView.backgroundColor = UIColor.red
        stackView = UIStackView(arrangedSubviews: [self.salesButton, self.dummy1Botton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        mainLabel.addSubview(stackView)
        
        salesSettingsView.isHidden = false
        salesSettingsView.delegate = self
        mainLabel.addSubview(salesSettingsView)
        
        editSalesSettingsView.isHidden = true
        editSalesSettingsView.delegate = self
        mainLabel.addSubview(editSalesSettingsView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        salesButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        salesSettingsView.translatesAutoresizingMaskIntoConstraints = false
        editSalesSettingsView.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            salesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
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
                salesSettingsView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                salesSettingsView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                salesSettingsView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                salesSettingsView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                editSalesSettingsView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                editSalesSettingsView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                editSalesSettingsView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                editSalesSettingsView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
            ])
        } else { // 通常の画面の場合
            salesButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
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
                salesSettingsView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                salesSettingsView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                salesSettingsView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                salesSettingsView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                editSalesSettingsView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                editSalesSettingsView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                editSalesSettingsView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                editSalesSettingsView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
            ])
        }
    }
    
    func setSubscribe() {
        presenter.viewSales
            .subscribe(onNext: { [unowned self] model in
                print("Received cat info data: \(model)")
                salesSettingsView.salesMasterList = model.salesMasterModel
                salesSettingsView.tableView.reloadData()
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
}

extension SettingsViewController: TitleDelegate {
    func tapMenuButton() {
        presenter.didTapMenuButton()
    }
}

extension SettingsViewController: SalesSettingsViewDelegate {
    func tapNewButton() {
        editSalesSettingsView.isHidden = false
    }
    
    func tapEditTableViewRow(selectedSalesMaster: SalesMasterModel) {
        editSalesSettingsView.setSalesSettings(salesMaster: selectedSalesMaster)
        editSalesSettingsView.isHidden = false
    }
    
    func tapDeleteTableViewRow(selectedSalesMaster: SalesMasterModel) {
        presenter.deleteSalesMaster(selectedSalesMaster: selectedSalesMaster)
    }
}

extension SettingsViewController: EditSalesSettingsViewDelegate {
    func didTapEditSalesSettingsSubmitButton(salesMaster: SalesMasterModel) {
        presenter.setSalesMaster(salesMaster: salesMaster)
    }
    
    func didTapEditSalesSettingsCancelButton() {
        editSalesSettingsView.isHidden = true
    }
}
