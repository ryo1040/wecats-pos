//
//  SalesView.swift
//  wecatspos
//
//  Created by matsumoto on 2026/04/05.
//

import Foundation
import UIKit

protocol SalesViewDelegate: AnyObject {
    func tapSalesRegisterButton(sales: [SalesModel], totalAmount: Int)
    func tapSalesCancelButton()
    func salesViewWillClose(hasUnsavedChanges: Bool, completion: @escaping (Bool) -> Void)
}

public class SalesView: UIView {

    weak var delegate: SalesViewDelegate?

    private var salesMasterModel: [SalesMasterModel] = []
    private var salesModel: [SalesModel] = []
    var hasUnsavedChanges = false
    private var isShowingTwoColumnLayout = false
    private var itemPreferredWidthConstraint: NSLayoutConstraint?
    private var itemMaxWidthConstraint: NSLayoutConstraint?
    private var itemStackViewTopConstraint: NSLayoutConstraint?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let itemStackView = UIStackView()
    private let columnSeparatorView = UIView()
    private let registerButton = UIButton()
    private let cancelButton = UIButton()

    private let baseBackground = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
    private let lineColor = UIColor.black
    private let accentColor = UIColor.black
    private let textColor = UIColor.black

    var readOnlyFlg: Bool = false
    private var today = ""

    public init() {
        super.init(frame: .zero)
        
        setupViews()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        today = formatter.string(from: Date())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        updateItemStackWidthConstraints()

        let shouldUseTwoColumnLayout = usesTwoColumnLayout
        if shouldUseTwoColumnLayout != isShowingTwoColumnLayout {
            isShowingTwoColumnLayout = shouldUseTwoColumnLayout
            reloadItemCards()
        }
    }
}

// MARK: - Public

extension SalesView {
    func setItems(salesMasterModel: [SalesMasterModel], salesModel: [SalesModel]) {
        self.salesMasterModel = salesMasterModel
        self.salesModel = salesModel
        self.hasUnsavedChanges = false
        reloadItemCards()
        
        if self.readOnlyFlg {
            itemStackViewTopConstraint?.constant = 74  // 24 + 50
        } else {
            itemStackViewTopConstraint?.constant = 24
        }
        self.registerButton.isHidden = self.readOnlyFlg
        self.cancelButton.isHidden = !self.readOnlyFlg
    }

    func closeIfPossible(completion: @escaping (Bool) -> Void) {
        delegate?.salesViewWillClose(hasUnsavedChanges: hasUnsavedChanges, completion: completion)
    }

    func willClose(completion: @escaping (Bool) -> Void) {
        closeIfPossible(completion: completion)
    }

    func discardUnsavedChanges() {
        hasUnsavedChanges = false
    }

    func currentItems() -> [SalesMasterModel] {
        return salesMasterModel
    }
}

// MARK: - Setup

private extension SalesView {
    var currentWidth: CGFloat {
        let width = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width
        let height = bounds.height > 0 ? bounds.height : UIScreen.main.bounds.height
        return min(width, height)
    }

    var isCompactLayout: Bool {
        return LayoutBreakpoint.isCompact(sideLength: currentWidth)
    }

    var usesTwoColumnLayout: Bool {
        return traitCollection.userInterfaceIdiom == .pad && bounds.width > bounds.height
    }

    func setupViews() {
        backgroundColor = baseBackground

        setupScroll()
        setupRegisterButton()
        setupCancelButton()
        setupItemStack()
    }

    func setupScroll() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func setupRegisterButton() {
        registerButton.setTitle("登録", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.backgroundColor = .white
        registerButton.layer.borderColor = UIColor.black.cgColor
        registerButton.layer.borderWidth = 1.0
        registerButton.layer.cornerRadius = 10
        registerButton.titleLabel?.font = .systemFont(ofSize: isCompactLayout ? 16 : 32)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(tapRegisterButton), for: .touchUpInside)

        addSubview(registerButton)

        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            registerButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
            registerButton.widthAnchor.constraint(equalToConstant: isCompactLayout ? 100 : 200),
            registerButton.heightAnchor.constraint(equalToConstant: isCompactLayout ? 32 : 48)
        ])
    }

    func setupCancelButton() {
        cancelButton.setTitle("戻る", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.cornerRadius = 10
        cancelButton.titleLabel?.font = .systemFont(ofSize: isCompactLayout ? 16 : 32)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)

        addSubview(cancelButton)

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            cancelButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            cancelButton.widthAnchor.constraint(equalToConstant: isCompactLayout ? 100 : 200),
            cancelButton.heightAnchor.constraint(equalToConstant: isCompactLayout ? 32 : 48)
        ])
    }
    
    func setupItemStack() {
        itemStackView.axis = .vertical
        itemStackView.spacing = 24
        itemStackView.alignment = .fill
        itemStackView.distribution = .fill

        contentView.addSubview(itemStackView)
        contentView.addSubview(columnSeparatorView)
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        columnSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        columnSeparatorView.backgroundColor = lineColor
        columnSeparatorView.isHidden = true

        let itemPreferredWidth = itemStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -72)
        itemPreferredWidth.priority = .defaultHigh
        itemPreferredWidthConstraint = itemPreferredWidth

        let itemMaxWidth = itemStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 860)
        itemMaxWidthConstraint = itemMaxWidth

        let itemStackViewTop = itemStackView.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 24)
        itemStackViewTopConstraint = itemStackViewTop

        NSLayoutConstraint.activate([
            itemStackViewTop,
            itemStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            itemPreferredWidth,
            itemMaxWidth,
            itemStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            columnSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            columnSeparatorView.topAnchor.constraint(equalTo: itemStackView.topAnchor),
            columnSeparatorView.bottomAnchor.constraint(equalTo: itemStackView.bottomAnchor),
            columnSeparatorView.widthAnchor.constraint(equalToConstant: 1)
        ])

        updateItemStackWidthConstraints()
    }

    func updateItemStackWidthConstraints() {
        if usesTwoColumnLayout {
            itemPreferredWidthConstraint?.constant = -20
            itemMaxWidthConstraint?.constant = 1120
            return
        }

        itemPreferredWidthConstraint?.constant = -72
        itemMaxWidthConstraint?.constant = 860
    }
}

// MARK: - Rendering

private extension SalesView {
    func reloadItemCards() {
        itemStackView.arrangedSubviews.forEach { view in
            itemStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        isShowingTwoColumnLayout = usesTwoColumnLayout
        columnSeparatorView.isHidden = !usesTwoColumnLayout

        if usesTwoColumnLayout {
            for startIndex in stride(from: 0, to: salesMasterModel.count, by: 2) {
                let rowStack = UIStackView()
                rowStack.axis = .horizontal
                rowStack.alignment = .fill
                rowStack.distribution = .fillEqually
                rowStack.spacing = 24

                let leftIndex = startIndex
                let leftMaster = salesMasterModel[leftIndex]
                let leftSales = salesModel.first(where: { $0.salesMasterId == leftMaster.id }) ?? SalesModel(date: "", salesMasterId: -1, branch: 0, count: 0)
                let leftCard = buildItemCard(salesMasterModel: leftMaster, salesModel: leftSales, index: leftIndex)

                let rightView: UIView
                if startIndex + 1 < salesMasterModel.count {
                    let rightIndex = startIndex + 1
                    let rightMaster = salesMasterModel[rightIndex]
                    let rightSales = salesModel.first(where: { $0.salesMasterId == rightMaster.id }) ?? SalesModel(date: "", salesMasterId: -1, branch: 0, count: 0)
                    rightView = buildItemCard(salesMasterModel: rightMaster, salesModel: rightSales, index: rightIndex)
                } else {
                    let spacerView = UIView()
                    spacerView.backgroundColor = .clear
                    rightView = spacerView
                }

                rowStack.addArrangedSubview(leftCard)
                rowStack.addArrangedSubview(rightView)

                itemStackView.addArrangedSubview(rowStack)
            }
            return
        }

        for (index, master) in salesMasterModel.enumerated() {
            let sales = salesModel.first(where: { $0.salesMasterId == master.id }) ?? SalesModel(date: "", salesMasterId: -1, branch: 0, count: 0)
            let card = buildItemCard(salesMasterModel: master, salesModel: sales, index: index)
            itemStackView.addArrangedSubview(card)
        }
    }

    func buildItemCard(salesMasterModel: SalesMasterModel, salesModel: SalesModel, index: Int) -> UIView {
        let card = UIView()
        card.backgroundColor = baseBackground
        card.layer.cornerRadius = 20
        card.layer.borderWidth = 0
        card.layer.borderColor = lineColor.cgColor

        let nameLabel = UILabel()
        nameLabel.text = salesMasterModel.name
        nameLabel.textColor = textColor
        nameLabel.font = .systemFont(ofSize: isCompactLayout ? 18 : 30, weight: .semibold)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.numberOfLines = 1

        let priceLabel = UILabel()
        priceLabel.text = "¥\(commaSeparateThreeDigits(salesMasterModel.price))/個"
        priceLabel.textColor = .black
        priceLabel.font = .systemFont(ofSize: isCompactLayout ? 14 : 22, weight: .regular)
        priceLabel.setContentHuggingPriority(.required, for: .horizontal)

        let minusButton = UIButton(type: .custom)
        minusButton.setTitle("−", for: .normal)
        minusButton.setTitleColor(accentColor, for: .normal)
        minusButton.backgroundColor = .white
        minusButton.titleLabel?.font = .systemFont(ofSize: isCompactLayout ? 30 : 40, weight: .medium)
        minusButton.layer.cornerRadius = isCompactLayout ? 20 : 26
        minusButton.layer.borderWidth = 2
        minusButton.layer.borderColor = lineColor.cgColor
        minusButton.layer.masksToBounds = true
        minusButton.tag = index
        minusButton.addTarget(self, action: #selector(tapMinus(_:)), for: .touchUpInside)

        let countLabel = UILabel()
        countLabel.text = "\(salesModel.count)"
        countLabel.textColor = accentColor
        countLabel.textAlignment = .center
        countLabel.font = .systemFont(ofSize: isCompactLayout ? 28 : 40, weight: .regular)
        countLabel.setContentHuggingPriority(.required, for: .horizontal)
        countLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let plusButton = UIButton(type: .custom)
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(accentColor, for: .normal)
        plusButton.backgroundColor = .white
        plusButton.titleLabel?.font = .systemFont(ofSize: isCompactLayout ? 30 : 40, weight: .medium)
        plusButton.layer.cornerRadius = isCompactLayout ? 20 : 26
        plusButton.layer.borderWidth = 2
        plusButton.layer.borderColor = lineColor.cgColor
        plusButton.layer.masksToBounds = true
        plusButton.tag = index
        plusButton.addTarget(self, action: #selector(tapPlus(_:)), for: .touchUpInside)

        let namePriceStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        namePriceStack.axis = .vertical
        namePriceStack.alignment = .leading
        namePriceStack.spacing = 2

        let qtyStack = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton])
        qtyStack.axis = .horizontal
        qtyStack.alignment = .center
        qtyStack.spacing = isCompactLayout ? 20 : 28
        
        if readOnlyFlg {
            minusButton.isHidden = true
            plusButton.isHidden = true
        }

        card.addSubview(namePriceStack)
        card.addSubview(qtyStack)

        namePriceStack.translatesAutoresizingMaskIntoConstraints = false
        qtyStack.translatesAutoresizingMaskIntoConstraints = false

        let circleSize: CGFloat = isCompactLayout ? 40 : 52
        let cardHeight: CGFloat = isCompactLayout ? 78 : 96
        let countLabelWidth: CGFloat = isCompactLayout ? 56 : 76

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: cardHeight),

            namePriceStack.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 16),
            namePriceStack.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            namePriceStack.rightAnchor.constraint(lessThanOrEqualTo: qtyStack.leftAnchor, constant: -16),

            qtyStack.leftAnchor.constraint(greaterThanOrEqualTo: namePriceStack.rightAnchor, constant: 16),
            qtyStack.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            qtyStack.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -16),

            minusButton.widthAnchor.constraint(equalToConstant: circleSize),
            minusButton.heightAnchor.constraint(equalToConstant: circleSize),
            plusButton.widthAnchor.constraint(equalToConstant: circleSize),
            plusButton.heightAnchor.constraint(equalToConstant: circleSize),
            countLabel.widthAnchor.constraint(equalToConstant: countLabelWidth)
        ])

        return card
    }

}

// MARK: - Actions

private extension SalesView {
    func countLabel(from sender: UIButton) -> UILabel? {
        guard let stackView = sender.superview as? UIStackView,
              stackView.arrangedSubviews.count > 1,
              let countLabel = stackView.arrangedSubviews[1] as? UILabel else {
            return nil
        }

        return countLabel
    }

    @objc func tapMinus(_ sender: UIButton) {
        let index = sender.tag
        guard salesMasterModel.indices.contains(index) else { return }
        let master = salesMasterModel[index]
        guard let salesIndex = salesModel.firstIndex(where: { $0.salesMasterId == master.id }) else { return }

        guard salesModel[salesIndex].count > 0 else { return }
        salesModel[salesIndex].count -= 1
        hasUnsavedChanges = true
        countLabel(from: sender)?.text = "\(salesModel[salesIndex].count)"
    }

    @objc func tapPlus(_ sender: UIButton) {
        let index = sender.tag
        guard salesMasterModel.indices.contains(index) else { return }
        let master = salesMasterModel[index]
        let salesIndex: Int
        if let foundIndex = salesModel.firstIndex(where: { $0.salesMasterId == master.id }) {
            salesIndex = foundIndex
        } else {
            salesModel.append(SalesModel(date: today, salesMasterId: master.id, branch: 0, count: 0))
            salesIndex = salesModel.count - 1
        }

        salesModel[salesIndex].count += 1
        hasUnsavedChanges = true
        countLabel(from: sender)?.text = "\(salesModel[salesIndex].count)"
    }

    @objc func tapRegisterButton() {
        let priceByMasterId = Dictionary(uniqueKeysWithValues: salesMasterModel.map { ($0.id, $0.price) })
        let totalAmount = salesModel.reduce(0) { result, sales in
            let price = priceByMasterId[sales.salesMasterId] ?? 0
            return result + (price * sales.count)
        }
        delegate?.tapSalesRegisterButton(sales: salesModel, totalAmount: totalAmount)
    }
    
    @objc func tapCancelButton() {
        delegate?.tapSalesCancelButton()
    }
}

// MARK: - Helper

private extension SalesView {
    func commaSeparateThreeDigits(_ amount: Int) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.groupingSize = 3
        nf.groupingSeparator = ","
        return nf.string(from: NSNumber(integerLiteral: amount)) ?? "\(amount)"
    }
}
