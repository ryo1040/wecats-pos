//
//  MenuViewController.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/28.
//

import Foundation
import UIKit
//import RxSwift

protocol MenuViewControllerProtocol {}

final class MenuViewController: UIViewController, MenuViewControllerProtocol {
    
    var presenter: MenuPresenterProtocol!
    
    // TitleView
    let titleView = TitleView()
    
    let mainLabel = UILabel()
    let catInfoButton = UIButton()
    let openButton = UIButton()
    let totalButton = UIButton()
    
    public func inject(presenter: MenuPresenterProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        titleView.titleMenuButton.isHidden = true
    }
}

// MARK: - 外観の調整

private extension MenuViewController {

    func setupViews() {
        // TitleViewの追加
        titleView.delegate = self
        self.view.addSubview(titleView)
        
        mainLabel.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        mainLabel.isUserInteractionEnabled = true

        catInfoButton.backgroundColor = UIColor.white
        catInfoButton.layer.borderColor = UIColor.black.cgColor
        catInfoButton.layer.borderWidth = 2.0
        catInfoButton.layer.cornerRadius = 25
        catInfoButton.setTitle("猫情報", for: .normal)
        catInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 48)
        catInfoButton.setTitleColor(UIColor.black, for: .normal)
        catInfoButton.addTarget(self, action: #selector(self.tapCatInfoButton(_:)), for: UIControl.Event.touchUpInside)

        openButton.backgroundColor = UIColor.white
        openButton.layer.borderColor = UIColor.black.cgColor
        openButton.layer.borderWidth = 2.0
        openButton.layer.cornerRadius = 25
        openButton.setTitle("営業中", for: .normal)
        openButton.titleLabel?.font = UIFont.systemFont(ofSize: 48)
        openButton.setTitleColor(UIColor.black, for: .normal)
        openButton.addTarget(self, action: #selector(self.tapOpenButton(_:)), for: UIControl.Event.touchUpInside)
        
        totalButton.backgroundColor = UIColor.white
        totalButton.layer.borderColor = UIColor.black.cgColor
        totalButton.layer.borderWidth = 2.0
        totalButton.layer.cornerRadius = 25
        totalButton.setTitle("集計", for: .normal)
        totalButton.titleLabel?.font = UIFont.systemFont(ofSize: 48)
        totalButton.setTitleColor(UIColor.black, for: .normal)
        totalButton.addTarget(self, action: #selector(self.tapTotalButton(_:)), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(mainLabel)
        mainLabel.addSubview(catInfoButton)
        mainLabel.addSubview(openButton)
        mainLabel.addSubview(totalButton)

        titleView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        catInfoButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.translatesAutoresizingMaskIntoConstraints = false
        totalButton.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            catInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            openButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            totalButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            
            catInfoButton.layer.cornerRadius = 15
            openButton.layer.cornerRadius = 15
            totalButton.layer.cornerRadius = 15
            
            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                titleView.heightAnchor.constraint(equalToConstant: 50),
                mainLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                mainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                mainLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                mainLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                catInfoButton.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
                catInfoButton.leftAnchor.constraint(equalTo: mainLabel.leftAnchor, constant: 64),
                catInfoButton.heightAnchor.constraint(equalToConstant: 90),
                catInfoButton.widthAnchor.constraint(equalToConstant: 120),
                openButton.centerYAnchor.constraint(equalTo: catInfoButton.centerYAnchor),
                openButton.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor),
                openButton.heightAnchor.constraint(equalToConstant: 90),
                openButton.widthAnchor.constraint(equalToConstant: 120),
                totalButton.centerYAnchor.constraint(equalTo: catInfoButton.centerYAnchor),
                totalButton.rightAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: -64),
                totalButton.heightAnchor.constraint(equalToConstant: 90),
                totalButton.widthAnchor.constraint(equalToConstant: 120),
            ])
        } else { // 通常の画面の場合
            catInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 48)
            openButton.titleLabel?.font = UIFont.systemFont(ofSize: 48)
            totalButton.titleLabel?.font = UIFont.systemFont(ofSize: 48)
            
            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                titleView.heightAnchor.constraint(equalToConstant: 100),
                mainLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                mainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                mainLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                mainLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                catInfoButton.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
                catInfoButton.leftAnchor.constraint(equalTo: mainLabel.leftAnchor, constant: 96),
                catInfoButton.heightAnchor.constraint(equalToConstant: 180),
                catInfoButton.widthAnchor.constraint(equalToConstant: 240),
                openButton.centerYAnchor.constraint(equalTo: catInfoButton.centerYAnchor),
                openButton.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor),
                openButton.heightAnchor.constraint(equalToConstant: 180),
                openButton.widthAnchor.constraint(equalToConstant: 240),
                totalButton.centerYAnchor.constraint(equalTo: catInfoButton.centerYAnchor),
                totalButton.rightAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: -96),
                totalButton.heightAnchor.constraint(equalToConstant: 180),
                totalButton.widthAnchor.constraint(equalToConstant: 240),
            ])
        }
    }
    
    @objc func tapCatInfoButton(_ sender: UIButton){
        presenter.didTapCatInfoButton()
    }
    
    @objc func tapOpenButton(_ sender: UIButton){
        presenter.didTapOpenButton()
    }
    
    @objc func tapTotalButton(_ sender: UIButton){
        presenter.didTapTotalButton()
    }
}

extension MenuViewController: TitleDelegate {
    func tapMenuButton() {
        // Menuボタンは非表示のため、呼ばれることはない
    }
}
