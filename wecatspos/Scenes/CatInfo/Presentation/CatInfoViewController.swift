//
//  CatInfoViewController.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/29.
//

import Foundation
import UIKit
import RxSwift

protocol CatInfoViewControllerProtocol {}

final class CatInfoViewController: UIViewController, CatInfoViewControllerProtocol {
    
    var presenter: CatInfoPresenterProtocol!
    
    // TitleView
    let titleView = TitleView()
    
    // main
    let mainLabel = UILabel()
    let catSelectLabel = UILabel()
    let catInfoButton = UIButton()
    let medicationBotton = UIButton()
    let healthManagementButton = UIButton()
    var stackView = UIStackView()
    
    // Views
    let catInfoView = CatInfoView()
    let medicalHistoryView = MedicalHistoryView()
    let editMedicalHistoryView = EditMedicalHistoryView()

    let catSelectButton = UIButton(type: .system)
    let catSelectPickerView = UIPickerView()
    var displayCatList: [CatInfoModel] = []
    var selectCatRowNo = 0
    
    var medicalHistory: [MedicalHistoryModel] = []
    
    var selectCatId: Int = 0
    var pickerBackgroundView: UIView!
    var pickerViewTextField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView!
    var overlayView: UIView!
    
    private let disposeBag = DisposeBag()
        
    public func inject(presenter: CatInfoPresenterProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setSubscribe()
        setupActivityIndicator()
        presenter.load()
        // タップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPickerView))
        tapGesture.cancelsTouchesInView = false // 他のビューのタップイベントも処理する
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissPickerView() {
        pickerViewTextField.resignFirstResponder() // ドラムロールを閉じる
        pickerBackgroundView.isHidden = true // 背景を非表示
    }
    
    @objc func tapCatSelectButton() {
        pickerBackgroundView.isHidden = false // 背景を表示
        pickerViewTextField.becomeFirstResponder() // ドラムロールを表示

        // 初期値として選択されている猫の行を設定
        if let selectedIndex = displayCatList.firstIndex(where: { $0.id == selectCatId }) {
            catSelectPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
            selectCatRowNo = selectedIndex
        } else if displayCatList.count > 0 {
            // 初期値がない場合は0番目を選択
            catSelectPickerView.selectRow(0, inComponent: 0, animated: false)
            selectCatRowNo = 0
        }
    }
    
    @objc func donePicker() {
        // 現在選択されている行を取得
        let selectedRow = catSelectPickerView.selectedRow(inComponent: 0)
        let selectedCat = displayCatList[selectedRow]
        
        // ボタンに名称を表示
        catSelectButton.setTitle(selectedCat.name, for: .normal)
        
        // 選択された猫のIDでフィルタリング
        let selectCatMedicalHistory = medicalHistory.filter { $0.catId == selectedCat.id }
        catInfoView.setCatInfoData(catInfo: selectedCat)
        medicalHistoryView.setMedicalHistory(medicalHistory: selectCatMedicalHistory)
        
        // 通院履歴データ取得
        presenter.getMedicalHistory(catId: selectedCat.id)
        
        selectCatId = selectedCat.id
        medicalHistoryView.changeAddButtonEnabled(selectCatId: self.selectCatId)
        
        // ピッカーを閉じる
        pickerViewTextField.resignFirstResponder()
        pickerBackgroundView.isHidden = true
    }
    
    @objc func cancelPicker() {
        // ピッカーを閉じる
        pickerViewTextField.resignFirstResponder()
        pickerBackgroundView.isHidden = true // 背景を非表示
    }
}

// MARK: - 外観の調整

private extension CatInfoViewController {

    func setupViews() {
        // TitleViewの追加
        titleView.delegate = self
        self.view.addSubview(titleView)
        
        mainLabel.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        mainLabel.isUserInteractionEnabled = true
        
        self.view.addSubview(mainLabel)
        
        catSelectLabel.text = "選択中のネコ："
        catSelectLabel.textColor = UIColor.black
        mainLabel.addSubview(catSelectLabel)
        
        catSelectButton.backgroundColor = UIColor.white
        catSelectButton.layer.borderWidth = 1
        catSelectButton.layer.borderColor = UIColor.black.cgColor
        catSelectButton.setTitle("選択してください", for: .normal)
        catSelectButton.setTitleColor(UIColor.black, for: .normal)
        catSelectButton.layer.borderWidth = 1.0
        catSelectButton.layer.cornerRadius = 10
        catSelectButton.addTarget(self, action: #selector(tapCatSelectButton), for: .touchUpInside)
        mainLabel.addSubview(catSelectButton)

        catInfoButton.backgroundColor = UIColor.lightGray
        catInfoButton.setTitle("猫情報", for: .normal)
        catInfoButton.setTitleColor(UIColor.white, for: .normal)
//        catInfoButton.layer.borderWidth = 0.5
        catInfoButton.addTarget(self, action: #selector(self.tapCatInfoButton(_:)), for: UIControl.Event.touchUpInside)
        
        medicationBotton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        medicationBotton.setTitle("通院情報", for: .normal)
        medicationBotton.setTitleColor(.black, for: .normal)
//        medicationBotton.layer.borderWidth = 0.5
        medicationBotton.addTarget(self, action: #selector(self.tapMedicalButton(_:)), for: UIControl.Event.touchUpInside)
        
        healthManagementButton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        healthManagementButton.setTitle("健康管理表", for: .normal)
        healthManagementButton.setTitleColor(.gray, for: .normal)
//        healthManagementButton.layer.borderWidth = 0.5
        
        stackView.backgroundColor = UIColor.red
        stackView = UIStackView(arrangedSubviews: [self.catInfoButton, self.medicationBotton, self.healthManagementButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        mainLabel.addSubview(stackView)
        
        catInfoView.isHidden = false
        mainLabel.addSubview(catInfoView)
        medicalHistoryView.isHidden = true
        medicalHistoryView.delegate = self
        mainLabel.addSubview(medicalHistoryView)
        
        editMedicalHistoryView.isHidden = true
        editMedicalHistoryView.delegate = self
        mainLabel.addSubview(editMedicalHistoryView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        catSelectLabel.translatesAutoresizingMaskIntoConstraints = false
        catSelectButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        catInfoView.translatesAutoresizingMaskIntoConstraints = false
        medicalHistoryView.translatesAutoresizingMaskIntoConstraints = false
        editMedicalHistoryView.translatesAutoresizingMaskIntoConstraints = false
        
        // レスポンシブルデザイン対応
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 668 { // 小さい画面の場合
            catSelectLabel.font = UIFont.systemFont(ofSize: 16)
            catSelectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            catInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            medicationBotton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            healthManagementButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                titleView.heightAnchor.constraint(equalToConstant: 50),
                mainLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                mainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                mainLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                mainLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                catSelectLabel.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: 16),
                catSelectLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor, constant: 16),
                catSelectButton.topAnchor.constraint(equalTo: catSelectLabel.topAnchor),
                catSelectButton.bottomAnchor.constraint(equalTo: catSelectLabel.bottomAnchor),
                catSelectButton.leftAnchor.constraint(equalTo: catSelectLabel.rightAnchor, constant: 8),
                catSelectButton.widthAnchor.constraint(equalToConstant: 200),
                catSelectButton.heightAnchor.constraint(equalToConstant: 32),
                stackView.topAnchor.constraint(equalTo: catSelectLabel.bottomAnchor, constant: 16),
                stackView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                stackView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                stackView.heightAnchor.constraint(equalToConstant: 40),

                catInfoView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                catInfoView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                catInfoView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                catInfoView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                medicalHistoryView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                medicalHistoryView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                medicalHistoryView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                medicalHistoryView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                
                editMedicalHistoryView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                editMedicalHistoryView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                editMedicalHistoryView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                editMedicalHistoryView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor)
            ])
        } else { // 通常の画面の場合
            catSelectLabel.font = UIFont.systemFont(ofSize: 32)
            catSelectButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            catInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            medicationBotton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            healthManagementButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                titleView.heightAnchor.constraint(equalToConstant: 100),
                mainLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                mainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                mainLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                mainLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                catSelectLabel.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: 32),
                catSelectLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor, constant: 32),
                catSelectButton.topAnchor.constraint(equalTo: catSelectLabel.topAnchor),
                catSelectButton.bottomAnchor.constraint(equalTo: catSelectLabel.bottomAnchor),
                catSelectButton.leftAnchor.constraint(equalTo: catSelectLabel.rightAnchor, constant: 16),
                catSelectButton.widthAnchor.constraint(equalToConstant: 400),
                catSelectButton.heightAnchor.constraint(equalToConstant: 40),
                stackView.topAnchor.constraint(equalTo: catSelectLabel.bottomAnchor, constant: 32),
                stackView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                stackView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                stackView.heightAnchor.constraint(equalToConstant: 80),

                catInfoView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                catInfoView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                catInfoView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                catInfoView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                medicalHistoryView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
                medicalHistoryView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                medicalHistoryView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                medicalHistoryView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
                
                editMedicalHistoryView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
                editMedicalHistoryView.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor),
                editMedicalHistoryView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor),
                editMedicalHistoryView.rightAnchor.constraint(equalTo: mainLabel.rightAnchor)
            ])
        }
        
        setupPickerView()
    }
    
    func setSubscribe() {
        // 猫情報の取得
        presenter.viewCatInfoData
            .subscribe(onNext: { [unowned self] model in
                print("Received cat info data: \(model)")
                self.displayCatList = model
                self.catSelectPickerView.reloadAllComponents()
            }).disposed(by: disposeBag)
        
        // 通院履歴の取得
        presenter.viewMedicalHistoryData
            .subscribe(onNext: { [unowned self] model in
                medicalHistoryView.medicalHistory = model.sorted(by: { $0.date > $1.date })                
                medicalHistoryView.tableView.reloadData()
                stopLoading()
            }).disposed(by: disposeBag)
    }

    @objc func tapCatInfoButton(_ sender: UIButton){
        catInfoView.isHidden = false
        medicalHistoryView.isHidden = true
        catInfoButton.backgroundColor = UIColor.lightGray
        medicationBotton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        catInfoButton.setTitleColor(UIColor.white, for: .normal)
        medicationBotton.setTitleColor(UIColor.black, for: .normal)
        catInfoView.setCatInfoData(catInfo: nil)
    }
    
    @objc func tapMedicalButton(_ sender: UIButton){
        catInfoView.isHidden = true
        medicalHistoryView.isHidden = false
        catInfoButton.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
        medicationBotton.backgroundColor = UIColor.lightGray
        catInfoButton.setTitleColor(UIColor.black, for: .normal)
        medicationBotton.setTitleColor(UIColor.white, for: .normal)
        medicalHistoryView.changeAddButtonEnabled(selectCatId: self.selectCatId)
    }
    
    private func setupPickerView() {
        // 背景ビューを作成
        pickerBackgroundView = UIView(frame: self.view.bounds)
        pickerBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 半透明のグレー
        pickerBackgroundView.isHidden = true
        self.view.addSubview(pickerBackgroundView)
        
        // UITextFieldを作成（キーボードを置き換えるため）
        pickerViewTextField = UITextField(frame: .zero)
        pickerViewTextField.delegate = self
        self.view.addSubview(pickerViewTextField)
        pickerViewTextField.isHidden = true

        // UIPickerViewの設定
        catSelectPickerView.delegate = self
        catSelectPickerView.dataSource = self

        // ツールバーを追加（完了ボタン付き）
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelPicker))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(donePicker))
        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: true)

        // UITextFieldにUIPickerViewとツールバーを設定
        pickerViewTextField.inputView = catSelectPickerView
        pickerViewTextField.inputAccessoryView = toolbar
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
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension CatInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // 列数
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return displayCatList.count // 猫の名前の数
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return displayCatList[row].name // 各行のタイトル
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCatRowNo = row // 選択された行を保存
        let selectedCatID = displayCatList[row].id // IDを取得
        print("選択された猫のID: \(selectedCatID), 名前: \(displayCatList[row].name)")
    }
}
    
extension CatInfoViewController: UITextFieldDelegate {
    func dismissKeyboard() {
        //他の場所をタップした時にキーボードを非表示にする
        self.view.endEditing(true)
        
        pickerBackgroundView.isHidden = true
    }
}

extension CatInfoViewController: UIGestureRecognizerDelegate {
    @objc func tapViewController() {
        //他の場所をタップした時にキーボードを非表示にする
        self.dismissKeyboard()
    }
}

extension CatInfoViewController: TitleDelegate {
    func tapMenuButton() {
        presenter.didTapMenuButton()
    }
}
extension CatInfoViewController: MedicalHistoryDelegate {
    func tapAddButton() {
//        presenter.didTapAddButton()
        editMedicalHistoryView.id = -1
        editMedicalHistoryView.clear()
        editMedicalHistoryView.isHidden = false
    }
    
    func didSelectMedicalHistory(id: Int, date: String, overview: String, detail: String?) {
        // 選択されたデータを`EditMedicalHistoryView`に設定
        editMedicalHistoryView.id = id
        editMedicalHistoryView.dateTextField.text = date
        editMedicalHistoryView.overviewTextField.text = overview
        editMedicalHistoryView.detailTextView.text = detail ?? ""
        
        // `EditMedicalHistoryView`を表示
        editMedicalHistoryView.isHidden = false
    }
}

extension CatInfoViewController: EditMedicalHistoryDelegate {
    func tapCancelButton() {
        editMedicalHistoryView.isHidden = true
    }
    
    func tapSubmitButton(id: Int, date: String, overview: String, detail: String?) {
        startLoading()
        presenter.didTapEditMedicalHistorySubmitButton(id: id, catId: selectCatId, date: date, overview: overview, detail: detail ?? "")
        
        editMedicalHistoryView.isHidden = true
    }
}
