//
//  TitleView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/10.
//

import UIKit

protocol TitleDelegate: AnyObject  {
    func tapMenuButton()
}

final class TitleView: UIView {
    
    let titleBackgroundLabel = UILabel()
    let titleTextLabel = UILabel()
    let titleMenuButton = UIButton()
    let titleDateLabel = UILabel()
    let titleTimeLabel = UILabel()
    
    weak var delegate: TitleDelegate? 
    
    private var timeUpdateTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupTimeUpdateTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor.white
        
        titleBackgroundLabel.backgroundColor = UIColor.black
        
        titleTextLabel.text = "We Cats"
        titleTextLabel.textColor = UIColor.white
        
        titleMenuButton.setTitle("Menu", for: .normal)
        titleMenuButton.setTitleColor(UIColor.white, for: .normal)
        titleMenuButton.addTarget(self, action: #selector(self.tapMenuButton), for: .touchUpInside)
        titleMenuButton.backgroundColor = UIColor.black
        
        titleDateLabel.text = "2025/04/xx"
        titleDateLabel.textAlignment = .center
        titleDateLabel.textColor = UIColor.white
        
        titleTimeLabel.text = ""
        titleTimeLabel.textAlignment = .center
        titleTimeLabel.textColor = UIColor.white
        
        self.addSubview(titleBackgroundLabel)
        self.addSubview(titleTextLabel)
        self.addSubview(titleMenuButton)
        self.addSubview(titleDateLabel)
        self.addSubview(titleTimeLabel)
        
        titleBackgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        titleMenuButton.translatesAutoresizingMaskIntoConstraints = false
        titleDateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            titleTextLabel.font = UIFont.systemFont(ofSize: 24)
            titleMenuButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            titleDateLabel.font = UIFont.systemFont(ofSize: 12)
            titleTimeLabel.font = UIFont.systemFont(ofSize: 12)
            
            NSLayoutConstraint.activate([
                titleBackgroundLabel.topAnchor.constraint(equalTo: self.topAnchor),
                titleBackgroundLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                titleBackgroundLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
                titleBackgroundLabel.heightAnchor.constraint(equalToConstant: 50),
                titleTextLabel.topAnchor.constraint(equalTo: titleBackgroundLabel.topAnchor, constant: 16),
                titleTextLabel.bottomAnchor.constraint(equalTo: titleBackgroundLabel.bottomAnchor, constant: -16),
                titleTextLabel.leftAnchor.constraint(equalTo: titleBackgroundLabel.leftAnchor, constant: 50),
                titleMenuButton.centerYAnchor.constraint(equalTo: titleBackgroundLabel.centerYAnchor),
                titleMenuButton.centerXAnchor.constraint(equalTo: titleBackgroundLabel.centerXAnchor),
                titleDateLabel.topAnchor.constraint(equalTo: titleBackgroundLabel.topAnchor, constant: 8),
                titleDateLabel.rightAnchor.constraint(equalTo: titleBackgroundLabel.rightAnchor, constant: -32),
                titleTimeLabel.topAnchor.constraint(equalTo: titleDateLabel.bottomAnchor, constant: 4),
                titleTimeLabel.bottomAnchor.constraint(equalTo: titleBackgroundLabel.bottomAnchor, constant: -8),
                titleTimeLabel.leftAnchor.constraint(equalTo: titleDateLabel.leftAnchor),
                titleTimeLabel.rightAnchor.constraint(equalTo: titleDateLabel.rightAnchor)
            ])
        } else { // 通常の画面の場合
            titleTextLabel.font = UIFont.systemFont(ofSize: 48)
            titleMenuButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
            titleDateLabel.font = UIFont.systemFont(ofSize: 24)
            titleTimeLabel.font = UIFont.systemFont(ofSize: 24)
            
            NSLayoutConstraint.activate([
                titleBackgroundLabel.topAnchor.constraint(equalTo: self.topAnchor),
                titleBackgroundLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                titleBackgroundLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
                titleBackgroundLabel.heightAnchor.constraint(equalToConstant: 100),
                titleTextLabel.topAnchor.constraint(equalTo: titleBackgroundLabel.topAnchor, constant: 16),
                titleTextLabel.bottomAnchor.constraint(equalTo: titleBackgroundLabel.bottomAnchor, constant: -16),
                titleTextLabel.leftAnchor.constraint(equalTo: titleBackgroundLabel.leftAnchor, constant: 50),
                titleMenuButton.centerYAnchor.constraint(equalTo: titleBackgroundLabel.centerYAnchor),
                titleMenuButton.centerXAnchor.constraint(equalTo: titleBackgroundLabel.centerXAnchor),
                titleDateLabel.topAnchor.constraint(equalTo: titleBackgroundLabel.topAnchor, constant: 16),
                titleDateLabel.rightAnchor.constraint(equalTo: titleBackgroundLabel.rightAnchor, constant: -32),
                titleTimeLabel.topAnchor.constraint(equalTo: titleDateLabel.bottomAnchor, constant: 8),
                titleTimeLabel.bottomAnchor.constraint(equalTo: titleBackgroundLabel.bottomAnchor, constant: -16),
                titleTimeLabel.leftAnchor.constraint(equalTo: titleDateLabel.leftAnchor),
                titleTimeLabel.rightAnchor.constraint(equalTo: titleDateLabel.rightAnchor)
            ])
        }
    }
    
    private func setupTimeUpdateTimer() {
        updateCurrentTime()
        timeUpdateTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCurrentTime),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func updateCurrentTime() {
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH:mm:ss"
//        let currentTime = formatterTime.string(from: Date())
        titleTimeLabel.text = formatterTime.string(from: Date())
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy/MM/dd"
        titleDateLabel.text = formatterDate.string(from: Date())
        
    }
    
    deinit {
        timeUpdateTimer?.invalidate()
        timeUpdateTimer = nil
    }

    @objc func tapMenuButton(_ sender: UIButton) {
        delegate?.tapMenuButton()
    }
}
