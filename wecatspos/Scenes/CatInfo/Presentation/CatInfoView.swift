//
//  CatInfoView.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/29.
//

import Foundation
import UIKit

public class CatInfoView: UIView {
    
    let catPicture = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
    let catSexTitleLabel = UILabel()
    let catSexLabel = UILabel()
    let catBreedTitleLabel = UILabel()
    let catBreedLabel = UILabel()
    let catBirthDayTitleLabel = UILabel()
    let catBirthDayLabel = UILabel()
    let catVaccineTitleLabel = UILabel()
    let catVaccineLabel = UILabel()
    let catMicroChipTitleLabel = UILabel()
    let catMicroChipLabel = UILabel()
    let catContraceptionTitleLabel = UILabel()
    let catContraceptionLabel = UILabel()
    let catSalesPriceTitleLabel = UILabel()
    let catSalesPriceLabel = UILabel()
    
    // 画像キャッシュ用
    private static let imageCache = NSCache<NSString, UIImage>()
    private var currentImageTask: URLSessionDataTask?
    
    public init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCatInfoData(catInfo: CatInfoModel?) {
        if let catInfo = catInfo {
            if let imageUrl = URL(string: catInfo.pic ?? "") {
                loadImage(from: imageUrl)
            } else {
                showPlaceholder()
            }

            if catInfo.sex == 0 {
                catSexLabel.text = "女の子"
            } else {
                catSexLabel.text = "男の子"
            }
            catBreedLabel.text = catInfo.breed
            catBirthDayLabel.text = catInfo.birthday
            if catInfo.vaccine == 0 {
                catVaccineLabel.text = "未接種"
            } else {
                catVaccineLabel.text = String(catInfo.vaccine) + "回接種済"
            }
            if catInfo.microchip {
                catMicroChipLabel.text = "済"
            } else {
                catMicroChipLabel.text = "未"
            }
            if catInfo.microchip {
                if catInfo.sex == 0 {
                    catContraceptionLabel.text = "避妊手術済"
                } else {
                    catContraceptionLabel.text = "去勢手術済"
                }
            } else {
                catContraceptionLabel.text = "未"
            }
            catSalesPriceLabel.text = String(catInfo.salePrice / 10000) + "万 + 避妊手術代 + マイクロチップ代"
        }
    }
    
    // S3から画像を読み込むメソッド（キャッシュ機能付き）
    private func loadImage(from url: URL) {
        let urlString = url.absoluteString
        let cacheKey = NSString(string: urlString)
        
        // 既存のタスクをキャンセル
        currentImageTask?.cancel()
        
        // キャッシュから画像を取得
        if let cachedImage = Self.imageCache.object(forKey: cacheKey) {
            displayImage(cachedImage)
            return
        }
        
        // 画像読み込み中はプレースホルダーを表示
        showPlaceholder()
        
        // URLRequestを作成してUser-Agentを設定
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        
        print("画像リクエスト開始: \(url.absoluteString)")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        // S3から画像を取得
        currentImageTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // タスクが完了したのでリセット
                self.currentImageTask = nil
                
                if let error = error {
                    print("画像取得エラー: \(error.localizedDescription)")
                    self.showPlaceholder()
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("HTTPレスポンスの取得に失敗")
                    self.showPlaceholder()
                    return
                }
                
                // ステータスコードの詳細ログ
                print("HTTP Status Code: \(httpResponse.statusCode)")
                print("URL: \(url.absoluteString)")
                
                if httpResponse.statusCode != 200 {
                    print("HTTPエラー: Status Code \(httpResponse.statusCode)")
                    print("Response Headers: \(httpResponse.allHeaderFields)")
                    self.showPlaceholder()
                    return
                }
                
                guard let data = data,
                      let image = UIImage(data: data) else {
                    print("画像データの変換に失敗")
                    self.showPlaceholder()
                    return
                }
                
                print("画像取得成功: \(url.absoluteString)")
                
                // キャッシュに保存
                Self.imageCache.setObject(image, forKey: cacheKey)
                
                // 画像を表示
                self.displayImage(image)
            }
        }
        currentImageTask?.resume()
    }
    
    // 画像を表示するヘルパーメソッド
    private func displayImage(_ image: UIImage) {
        catPicture.image = image
        catPicture.backgroundColor = UIColor.clear
        
        // プレースホルダーラベルを削除
        catPicture.subviews.forEach { subview in
            if subview is UILabel {
                subview.removeFromSuperview()
            }
        }
    }
    
    // プレースホルダー表示用のヘルパーメソッド
    private func showPlaceholder() {
        catPicture.image = nil
        catPicture.backgroundColor = UIColor.systemGray5
        
        // 猫のアイコンを文字で表示（絵文字を使用）
        let label = UILabel()
        label.text = "No Image"
        label.font = UIFont.systemFont(ofSize: 48)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 既存のプレースホルダーラベルを削除
        catPicture.subviews.forEach { subview in
            if subview is UILabel {
                subview.removeFromSuperview()
            }
        }
        
        catPicture.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: catPicture.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: catPicture.centerYAnchor)
        ])
    }
}

private extension CatInfoView {
    func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)

        catPicture.contentMode = .scaleAspectFill
        self.addSubview(catPicture)
        
        catSexTitleLabel.text = "性別："
        catSexTitleLabel.textColor = UIColor.black
        
        catSexLabel.textColor = UIColor.black
        
        catBreedTitleLabel.text = "猫種："
        catBreedTitleLabel.textColor = UIColor.black
        
        catBreedLabel.textColor = UIColor.black

        catBirthDayTitleLabel.text = "生年月日："
        catBirthDayTitleLabel.textColor = UIColor.black
        
        catBirthDayLabel.textColor = UIColor.black
        
        catVaccineTitleLabel.text = "ワクチン："
        catVaccineTitleLabel.textColor = UIColor.black
        
        catVaccineLabel.textColor = UIColor.black
        
        catMicroChipTitleLabel.text = "マイクロチップ："
        catMicroChipTitleLabel.textColor = UIColor.black
        
        catMicroChipLabel.textColor = UIColor.black
        
        catContraceptionTitleLabel.text = "去勢/避妊："
        catContraceptionTitleLabel.textColor = UIColor.black
        
        catContraceptionLabel.textColor = UIColor.black
        
        catSalesPriceTitleLabel.text = "販売価格："
        catSalesPriceTitleLabel.textColor = UIColor.black
        
        catSalesPriceLabel.textColor = UIColor.black
        
        self.addSubview(catSexTitleLabel)
        self.addSubview(catSexLabel)
        self.addSubview(catBreedTitleLabel)
        self.addSubview(catBirthDayTitleLabel)
        self.addSubview(catVaccineTitleLabel)
        self.addSubview(catMicroChipTitleLabel)
        self.addSubview(catContraceptionTitleLabel)
        self.addSubview(catSalesPriceTitleLabel)
        self.addSubview(catBreedLabel)
        self.addSubview(catBirthDayLabel)
        self.addSubview(catVaccineLabel)
        self.addSubview(catMicroChipLabel)
        self.addSubview(catContraceptionLabel)
        self.addSubview(catSalesPriceLabel)
        
        catPicture.translatesAutoresizingMaskIntoConstraints = false
        catSexTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        catSexLabel.translatesAutoresizingMaskIntoConstraints = false
        catBreedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        catBirthDayTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        catVaccineTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        catMicroChipTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        catContraceptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        catSalesPriceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        catBreedLabel.translatesAutoresizingMaskIntoConstraints = false
        catBirthDayLabel.translatesAutoresizingMaskIntoConstraints = false
        catVaccineLabel.translatesAutoresizingMaskIntoConstraints = false
        catMicroChipLabel.translatesAutoresizingMaskIntoConstraints = false
        catContraceptionLabel.translatesAutoresizingMaskIntoConstraints = false
        catSalesPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            catSexTitleLabel.font = UIFont.systemFont(ofSize: 16)
            catSexLabel.font = UIFont.systemFont(ofSize: 16)
            catBreedTitleLabel.font = UIFont.systemFont(ofSize: 16)
            catBreedLabel.font = UIFont.systemFont(ofSize: 16)
            catBirthDayTitleLabel.font = UIFont.systemFont(ofSize: 16)
            catBirthDayLabel.font = UIFont.systemFont(ofSize: 16)
            catVaccineTitleLabel.font = UIFont.systemFont(ofSize: 16)
            catVaccineLabel.font = UIFont.systemFont(ofSize: 16)
            catMicroChipTitleLabel.font = UIFont.systemFont(ofSize: 16)
            catMicroChipLabel.font = UIFont.systemFont(ofSize: 16)
            catContraceptionTitleLabel.font = UIFont.systemFont(ofSize: 16)
            catContraceptionLabel.font = UIFont.systemFont(ofSize: 16)
            catSalesPriceTitleLabel.font = UIFont.systemFont(ofSize: 16)
            catSalesPriceLabel.font = UIFont.systemFont(ofSize: 16)
            
            NSLayoutConstraint.activate([
                catPicture.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
                catPicture.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                catPicture.widthAnchor.constraint(equalToConstant: 150),

                catSexTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
                catSexTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catSexLabel.topAnchor.constraint(equalTo: catSexTitleLabel.topAnchor),
                catSexLabel.leftAnchor.constraint(equalTo: catSexTitleLabel.rightAnchor),
                catBreedTitleLabel.topAnchor.constraint(equalTo: catSexTitleLabel.bottomAnchor, constant: 8),
                catBreedTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catBreedLabel.topAnchor.constraint(equalTo: catBreedTitleLabel.topAnchor),
                catBreedLabel.leftAnchor.constraint(equalTo: catBreedTitleLabel.rightAnchor),
                catBirthDayTitleLabel.topAnchor.constraint(equalTo: catBreedTitleLabel.bottomAnchor, constant: 8),
                catBirthDayTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catBirthDayLabel.topAnchor.constraint(equalTo: catBirthDayTitleLabel.topAnchor),
                catBirthDayLabel.leftAnchor.constraint(equalTo: catBirthDayTitleLabel.rightAnchor),
                catVaccineTitleLabel.topAnchor.constraint(equalTo: catBirthDayTitleLabel.bottomAnchor, constant: 8),
                catVaccineTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catVaccineLabel.topAnchor.constraint(equalTo: catVaccineTitleLabel.topAnchor),
                catVaccineLabel.leftAnchor.constraint(equalTo: catVaccineTitleLabel.rightAnchor),
                catMicroChipTitleLabel.topAnchor.constraint(equalTo: catVaccineTitleLabel.bottomAnchor, constant: 8),
                catMicroChipTitleLabel.leftAnchor.constraint(equalTo: catPicture.rightAnchor, constant: 16),
                catMicroChipLabel.topAnchor.constraint(equalTo: catMicroChipTitleLabel.topAnchor),
                catMicroChipLabel.leftAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catContraceptionTitleLabel.topAnchor.constraint(equalTo: catMicroChipTitleLabel.bottomAnchor, constant: 8),
                catContraceptionTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catContraceptionLabel.topAnchor.constraint(equalTo: catContraceptionTitleLabel.topAnchor),
                catContraceptionLabel.leftAnchor.constraint(equalTo: catContraceptionTitleLabel.rightAnchor),
                catSalesPriceTitleLabel.topAnchor.constraint(equalTo: catContraceptionTitleLabel.bottomAnchor, constant: 8),
                catSalesPriceTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catSalesPriceLabel.topAnchor.constraint(equalTo: catSalesPriceTitleLabel.topAnchor),
                catSalesPriceLabel.leftAnchor.constraint(equalTo: catSalesPriceTitleLabel.rightAnchor)
            ])
        } else { // 通常の画面の場合
            catSexTitleLabel.font = UIFont.systemFont(ofSize: 32)
            catSexLabel.font = UIFont.systemFont(ofSize: 32)
            catBreedTitleLabel.font = UIFont.systemFont(ofSize: 32)
            catBreedLabel.font = UIFont.systemFont(ofSize: 32)
            catBirthDayTitleLabel.font = UIFont.systemFont(ofSize: 32)
            catBirthDayLabel.font = UIFont.systemFont(ofSize: 32)
            catVaccineTitleLabel.font = UIFont.systemFont(ofSize: 32)
            catVaccineLabel.font = UIFont.systemFont(ofSize: 32)
            catMicroChipTitleLabel.font = UIFont.systemFont(ofSize: 32)
            catMicroChipLabel.font = UIFont.systemFont(ofSize: 32)
            catContraceptionTitleLabel.font = UIFont.systemFont(ofSize: 32)
            catContraceptionLabel.font = UIFont.systemFont(ofSize: 32)
            catSalesPriceTitleLabel.font = UIFont.systemFont(ofSize: 32)
            catSalesPriceLabel.font = UIFont.systemFont(ofSize: 32)
            
            NSLayoutConstraint.activate([
                catPicture.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64),
                catPicture.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                catPicture.widthAnchor.constraint(equalToConstant: 300),

                catSexTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 64),
                catSexTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catSexLabel.topAnchor.constraint(equalTo: catSexTitleLabel.topAnchor),
                catSexLabel.leftAnchor.constraint(equalTo: catSexTitleLabel.rightAnchor),
                catBreedTitleLabel.topAnchor.constraint(equalTo: catSexTitleLabel.bottomAnchor, constant: 16),
                catBreedTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catBreedLabel.topAnchor.constraint(equalTo: catBreedTitleLabel.topAnchor),
                catBreedLabel.leftAnchor.constraint(equalTo: catBreedTitleLabel.rightAnchor),
                catBirthDayTitleLabel.topAnchor.constraint(equalTo: catBreedTitleLabel.bottomAnchor, constant: 16),
                catBirthDayTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catBirthDayLabel.topAnchor.constraint(equalTo: catBirthDayTitleLabel.topAnchor),
                catBirthDayLabel.leftAnchor.constraint(equalTo: catBirthDayTitleLabel.rightAnchor),
                catVaccineTitleLabel.topAnchor.constraint(equalTo: catBirthDayTitleLabel.bottomAnchor, constant: 16),
                catVaccineTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catVaccineLabel.topAnchor.constraint(equalTo: catVaccineTitleLabel.topAnchor),
                catVaccineLabel.leftAnchor.constraint(equalTo: catVaccineTitleLabel.rightAnchor),
                catMicroChipTitleLabel.topAnchor.constraint(equalTo: catVaccineTitleLabel.bottomAnchor, constant: 16),
                catMicroChipTitleLabel.leftAnchor.constraint(equalTo: catPicture.rightAnchor, constant: 32),
                catMicroChipLabel.topAnchor.constraint(equalTo: catMicroChipTitleLabel.topAnchor),
                catMicroChipLabel.leftAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catContraceptionTitleLabel.topAnchor.constraint(equalTo: catMicroChipTitleLabel.bottomAnchor, constant: 16),
                catContraceptionTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catContraceptionLabel.topAnchor.constraint(equalTo: catContraceptionTitleLabel.topAnchor),
                catContraceptionLabel.leftAnchor.constraint(equalTo: catContraceptionTitleLabel.rightAnchor),
                catSalesPriceTitleLabel.topAnchor.constraint(equalTo: catContraceptionTitleLabel.bottomAnchor, constant: 16),
                catSalesPriceTitleLabel.rightAnchor.constraint(equalTo: catMicroChipTitleLabel.rightAnchor),
                catSalesPriceLabel.topAnchor.constraint(equalTo: catSalesPriceTitleLabel.topAnchor),
                catSalesPriceLabel.leftAnchor.constraint(equalTo: catSalesPriceTitleLabel.rightAnchor)
            ])
        }
    }
}
