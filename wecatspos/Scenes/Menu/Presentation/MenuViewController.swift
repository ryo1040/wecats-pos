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
    let closeButton = UIButton()
    let careButton = UIButton()
    let settingsButton = UIButton()
    
    let screenWidth = UIScreen.main.bounds.width
    
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
        self.view.addSubview(mainLabel)
        
        func setupButton(_ button: UIButton, text: String = "") {
            button.backgroundColor = UIColor.white
            if screenWidth < 668 {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                button.layer.cornerRadius = 15
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 48)
                button.layer.cornerRadius = 25
            }
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2.0
            button.setTitle(text, for: .normal)
            if screenWidth < 668 {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                button.layer.cornerRadius = 15
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 48)
                button.layer.cornerRadius = 25
            }
            button.setTitleColor(UIColor.black, for: .normal)
        }

        setupButton(catInfoButton, text: "猫情報")
        catInfoButton.addTarget(self, action: #selector(self.tapCatInfoButton(_:)), for: UIControl.Event.touchUpInside)
        mainLabel.addSubview(catInfoButton)
        
        setupButton(openButton, text: "営業中")
        openButton.addTarget(self, action: #selector(self.tapOpenButton(_:)), for: UIControl.Event.touchUpInside)
        mainLabel.addSubview(openButton)

        setupButton(closeButton, text: "締め")
        closeButton.addTarget(self, action: #selector(self.tapCloseButton(_:)), for: UIControl.Event.touchUpInside)
        mainLabel.addSubview(closeButton)

        setupButton(totalButton, text: "統計")
        totalButton.addTarget(self, action: #selector(self.tapTotalButton(_:)), for: UIControl.Event.touchUpInside)
        mainLabel.addSubview(totalButton)
        
        setupButton(careButton, text: "お手入れ")
        careButton.addTarget(self, action: #selector(self.tapCareButton(_:)), for: UIControl.Event.touchUpInside)
        mainLabel.addSubview(careButton)

        setupButton(settingsButton, text: "設定")
        settingsButton.addTarget(self, action: #selector(self.tapSettingsButton(_:)), for: UIControl.Event.touchUpInside)
        mainLabel.addSubview(settingsButton)
        
        // 2行×3列（空のUIViewで隙間を埋める）
        let dummy1 = UIView()

        let row1Stack = UIStackView(arrangedSubviews: [catInfoButton, openButton, closeButton])
        row1Stack.axis = .horizontal
        row1Stack.distribution = .fillEqually
        row1Stack.spacing = 96

        let row2Stack = UIStackView(arrangedSubviews: [totalButton, careButton, settingsButton])
        row2Stack.axis = .horizontal
        row2Stack.distribution = .fillEqually
        row2Stack.spacing = 96

        let mainStack = UIStackView(arrangedSubviews: [row1Stack, row2Stack])
        mainStack.axis = .vertical
        mainStack.distribution = .fillEqually
        mainStack.spacing = 96

        mainLabel.addSubview(mainStack)

        titleView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
      
        // レスポンシブルデザイン対応
        if screenWidth < 668 { // 小さい画面の場合
            row1Stack.spacing = 32
            row2Stack.spacing = 32
            mainStack.spacing = 32
            
            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                titleView.heightAnchor.constraint(equalToConstant: 50),
                mainLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                mainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                mainLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                mainLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                mainStack.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
                mainStack.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor),
                mainStack.widthAnchor.constraint(equalTo: mainLabel.widthAnchor, multiplier: 0.9),
                mainStack.heightAnchor.constraint(equalTo: mainLabel.heightAnchor, multiplier: 0.9),
            ])
        } else { // 通常の画面の場合
            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                titleView.heightAnchor.constraint(equalToConstant: 100),
                mainLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                mainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                mainLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                mainLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                mainStack.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
                mainStack.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor),
                mainStack.widthAnchor.constraint(equalTo: mainLabel.widthAnchor, multiplier: 0.9),
                mainStack.heightAnchor.constraint(equalTo: mainLabel.heightAnchor, multiplier: 0.7),
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
    
    @objc func tapCloseButton(_ sender: UIButton){
        presenter.didTapCloseButton()
    }
    
    @objc func tapCareButton(_ sender: UIButton){
        presenter.didTapCareButton()
    }
    
    @objc func tapSettingsButton(_ sender: UIButton){
        presenter.didTapSettingsButton()
    }
}

extension MenuViewController: TitleDelegate {
    func tapMenuButton() {
        // Menuボタンは非表示のため、呼ばれることはない
    }
}
