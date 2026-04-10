//
//  SalesView.swift
//  wecatspos
//
//  Created by matsumoto on 2026/04/05.
//

import Foundation
import UIKit

protocol SalesDelegate: AnyObject {
    func tapSalesMinus(item: SalesItem)
    func tapSalesPlus(item: SalesItem)
    func tapSalesEdit(item: SalesMasterModel)
    func tapSalesDelete(item: SalesMasterModel)
}

struct SalesItem {
    let id: Int
    var name: String
    var unitPrice: Int
    var count: Int
}

public class SalesView: UIView {

    weak var delegate: SalesDelegate?

    private let screenWidth = UIScreen.main.bounds.width
    private var salesMasterModel: [SalesMasterModel] = []
    private var salesModel: [SalesModel] = []

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let summaryStackView = UIStackView()
    private let totalCountCard = UIView()
    private let totalSalesCard = UIView()

    private let totalCountTitleLabel = UILabel()
    private let totalCountValueLabel = UILabel()
    private let totalCountUnitLabel = UILabel()

    private let totalSalesTitleLabel = UILabel()
    private let totalSalesValueLabel = UILabel()
    private let totalSalesUnitLabel = UILabel()

    private let itemStackView = UIStackView()

    private let baseBackground = UIColor(red: 239/255, green: 236/255, blue: 231/255, alpha: 1.0)
    private let lineColor = UIColor.black
    private let accentColor = UIColor.black
    private let deleteColor = UIColor.black
    private let textColor = UIColor.black

    public init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension SalesView {
    func setItems(salesMasterModel: [SalesMasterModel], salesModel: [SalesModel]) {
        self.salesMasterModel = salesMasterModel
        self.salesModel = salesModel
        reloadItemCards()
        updateSummary()
    }

    func currentItems() -> [SalesMasterModel] {
        return salesMasterModel
    }
}

// MARK: - Setup

private extension SalesView {
    func setupViews() {
        backgroundColor = baseBackground

        setupScroll()
        setupSummary()
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

    func setupSummary() {
        summaryStackView.axis = .horizontal
        summaryStackView.alignment = .fill
        summaryStackView.distribution = .fillEqually
        summaryStackView.spacing = 12

        contentView.addSubview(summaryStackView)
        summaryStackView.translatesAutoresizingMaskIntoConstraints = false

        configureSummaryCard(
            card: totalCountCard,
            titleLabel: totalCountTitleLabel,
            valueLabel: totalCountValueLabel,
            unitLabel: totalCountUnitLabel,
            title: "本日の物販点数",
            unit: "点"
        )

        configureSummaryCard(
            card: totalSalesCard,
            titleLabel: totalSalesTitleLabel,
            valueLabel: totalSalesValueLabel,
            unitLabel: totalSalesUnitLabel,
            title: "本日の物販売上",
            unit: "円"
        )

        summaryStackView.addArrangedSubview(totalCountCard)
        summaryStackView.addArrangedSubview(totalSalesCard)

        let summaryPreferredWidth = summaryStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40)
        summaryPreferredWidth.priority = .defaultHigh

        NSLayoutConstraint.activate([
            summaryStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            summaryStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            summaryPreferredWidth,
            summaryStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 980),
            summaryStackView.heightAnchor.constraint(equalToConstant: screenWidth < 668 ? 84 : 108)
        ])
    }

    func configureSummaryCard(card: UIView, titleLabel: UILabel, valueLabel: UILabel, unitLabel: UILabel, title: String, unit: String) {
        card.backgroundColor = baseBackground
        card.layer.cornerRadius = 18
        card.layer.borderWidth = 0
        card.layer.borderColor = lineColor.cgColor

        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        valueLabel.text = "0"
        valueLabel.textColor = accentColor
        valueLabel.textAlignment = .center

        unitLabel.text = unit
        unitLabel.textColor = .black
        unitLabel.textAlignment = .center

        if screenWidth < 668 {
            titleLabel.font = .systemFont(ofSize: 11, weight: .semibold)
            valueLabel.font = .systemFont(ofSize: 36, weight: .regular)
            unitLabel.font = .systemFont(ofSize: 15, weight: .regular)
        } else {
            titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
            valueLabel.font = .systemFont(ofSize: 52, weight: .regular)
            unitLabel.font = .systemFont(ofSize: 24, weight: .regular)
        }

        let valueUnitStack = UIStackView(arrangedSubviews: [valueLabel, unitLabel])
        valueUnitStack.axis = .horizontal
        valueUnitStack.alignment = .lastBaseline
        valueUnitStack.spacing = 2

        card.addSubview(titleLabel)
        card.addSubview(valueUnitStack)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        valueUnitStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),

            valueUnitStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: screenWidth < 668 ? 2 : 4),
            valueUnitStack.centerXAnchor.constraint(equalTo: card.centerXAnchor)
        ])
    }

    func setupItemStack() {
        itemStackView.axis = .vertical
        itemStackView.spacing = 12
        itemStackView.alignment = .fill
        itemStackView.distribution = .fill

        contentView.addSubview(itemStackView)
        itemStackView.translatesAutoresizingMaskIntoConstraints = false

        let itemPreferredWidth = itemStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40)
        itemPreferredWidth.priority = .defaultHigh

        NSLayoutConstraint.activate([
            itemStackView.topAnchor.constraint(equalTo: summaryStackView.bottomAnchor, constant: 12),
            itemStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            itemPreferredWidth,
            itemStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 980),
            itemStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}

// MARK: - Rendering

private extension SalesView {
    func reloadItemCards() {
        itemStackView.arrangedSubviews.forEach { view in
            itemStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        for (index, master) in salesMasterModel.enumerated() {
            let sales = salesModel.first(where: { $0.salesMasterId == master.id }) ?? SalesModel(date: "", salesMasterId: -1, count: 0)
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
        nameLabel.font = .systemFont(ofSize: screenWidth < 668 ? 18 : 30, weight: .semibold)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let priceLabel = UILabel()
        priceLabel.text = "¥\(commaSeparateThreeDigits(salesMasterModel.price))/個"
        priceLabel.textColor = .black
        priceLabel.font = .systemFont(ofSize: screenWidth < 668 ? 14 : 22, weight: .regular)
        priceLabel.setContentHuggingPriority(.required, for: .horizontal)

        let minusButton = UIButton(type: .system)
        minusButton.setTitle("−", for: .normal)
        minusButton.setTitleColor(accentColor, for: .normal)
        minusButton.titleLabel?.font = .systemFont(ofSize: screenWidth < 668 ? 30 : 40, weight: .medium)
        minusButton.layer.cornerRadius = screenWidth < 668 ? 20 : 26
        minusButton.layer.borderWidth = 2
        minusButton.layer.borderColor = lineColor.cgColor
        minusButton.tag = index
        minusButton.addTarget(self, action: #selector(tapMinus(_:)), for: .touchUpInside)

        let countLabel = UILabel()
        countLabel.text = "\(salesModel.count)"
        countLabel.textColor = accentColor
        countLabel.textAlignment = .center
        countLabel.font = .systemFont(ofSize: screenWidth < 668 ? 28 : 40, weight: .regular)

        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(accentColor, for: .normal)
        plusButton.titleLabel?.font = .systemFont(ofSize: screenWidth < 668 ? 30 : 40, weight: .medium)
        plusButton.layer.cornerRadius = screenWidth < 668 ? 20 : 26
        plusButton.layer.borderWidth = 2
        plusButton.layer.borderColor = lineColor.cgColor
        plusButton.tag = index
        plusButton.addTarget(self, action: #selector(tapPlus(_:)), for: .touchUpInside)

        let editButton = UIButton(type: .system)
        editButton.setTitle("編集", for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: screenWidth < 668 ? 18 : 24, weight: .regular)
        editButton.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        editButton.layer.cornerRadius = 10
        editButton.layer.borderWidth = 1.5
        editButton.layer.borderColor = lineColor.cgColor
        editButton.tag = index
        editButton.addTarget(self, action: #selector(tapEdit(_:)), for: .touchUpInside)

        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("削除", for: .normal)
        deleteButton.setTitleColor(deleteColor, for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: screenWidth < 668 ? 18 : 24, weight: .regular)
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.borderWidth = 1.5
        deleteButton.layer.borderColor = lineColor.cgColor
        deleteButton.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        deleteButton.tag = index
        deleteButton.addTarget(self, action: #selector(tapDelete(_:)), for: .touchUpInside)

        let namePriceStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        namePriceStack.axis = .vertical
        namePriceStack.alignment = .leading
        namePriceStack.spacing = 2

        let qtyStack = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton])
        qtyStack.axis = .horizontal
        qtyStack.alignment = .center
        qtyStack.spacing = 12

        let rightButtonStack = UIStackView(arrangedSubviews: [editButton, deleteButton])
        rightButtonStack.axis = .horizontal
        rightButtonStack.alignment = .center
        rightButtonStack.spacing = screenWidth < 668 ? 8 : 12

        card.addSubview(namePriceStack)
        card.addSubview(qtyStack)
        card.addSubview(rightButtonStack)

        namePriceStack.translatesAutoresizingMaskIntoConstraints = false
        qtyStack.translatesAutoresizingMaskIntoConstraints = false
        rightButtonStack.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        let circleSize: CGFloat = screenWidth < 668 ? 40 : 52
        let rightButtonHeight: CGFloat = screenWidth < 668 ? 34 : 44
        let cardHeight: CGFloat = screenWidth < 668 ? 84 : 108

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: cardHeight),

            namePriceStack.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 16),
            namePriceStack.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            namePriceStack.rightAnchor.constraint(lessThanOrEqualTo: qtyStack.leftAnchor, constant: -8),

            qtyStack.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            qtyStack.centerYAnchor.constraint(equalTo: card.centerYAnchor),

            rightButtonStack.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -16),
            rightButtonStack.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            rightButtonStack.leftAnchor.constraint(greaterThanOrEqualTo: qtyStack.rightAnchor, constant: 8),

            minusButton.widthAnchor.constraint(equalToConstant: circleSize),
            minusButton.heightAnchor.constraint(equalToConstant: circleSize),
            plusButton.widthAnchor.constraint(equalToConstant: circleSize),
            plusButton.heightAnchor.constraint(equalToConstant: circleSize),

            editButton.widthAnchor.constraint(equalToConstant: screenWidth < 668 ? 64 : 86),
            editButton.heightAnchor.constraint(equalToConstant: rightButtonHeight),

            deleteButton.widthAnchor.constraint(equalToConstant: screenWidth < 668 ? 64 : 86),
            deleteButton.heightAnchor.constraint(equalToConstant: rightButtonHeight)
        ])

        return card
    }

    func updateSummary() {
        let totalCount = salesModel.reduce(0) { $0 + $1.count }
        let totalSales = salesModel.reduce(0) { partial, s in
            let price = salesMasterModel.first(where: { $0.id == s.salesMasterId })?.price ?? 0
            return partial + s.count * price
        }

        totalCountValueLabel.text = "\(totalCount)"
        totalSalesValueLabel.text = commaSeparateThreeDigits(totalSales)
    }
}

// MARK: - Actions

private extension SalesView {
    @objc func tapMinus(_ sender: UIButton) {
        let index = sender.tag
        guard salesMasterModel.indices.contains(index) else { return }
        let master = salesMasterModel[index]
        guard let salesIndex = salesModel.firstIndex(where: { $0.salesMasterId == master.id }) else { return }
        if salesModel[salesIndex].count > 0 {
            salesModel[salesIndex].count -= 1
            let item = SalesItem(id: master.id, name: master.name, unitPrice: master.price, count: salesModel[salesIndex].count)
            delegate?.tapSalesMinus(item: item)
            reloadItemCards()
            updateSummary()
        }
    }

    @objc func tapPlus(_ sender: UIButton) {
        let index = sender.tag
        guard salesMasterModel.indices.contains(index) else { return }
        let master = salesMasterModel[index]
        guard let salesIndex = salesModel.firstIndex(where: { $0.salesMasterId == master.id }) else { return }
        salesModel[salesIndex].count += 1
        let item = SalesItem(id: master.id, name: master.name, unitPrice: master.price, count: salesModel[salesIndex].count)
        delegate?.tapSalesPlus(item: item)
        reloadItemCards()
        updateSummary()
    }

    @objc func tapEdit(_ sender: UIButton) {
        let index = sender.tag
        guard salesMasterModel.indices.contains(index) else { return }
        delegate?.tapSalesEdit(item: salesMasterModel[index])
    }

    @objc func tapDelete(_ sender: UIButton) {
        let index = sender.tag
        guard salesMasterModel.indices.contains(index) else { return }
        delegate?.tapSalesDelete(item: salesMasterModel[index])
        salesMasterModel.remove(at: index)
        reloadItemCards()
        updateSummary()
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
