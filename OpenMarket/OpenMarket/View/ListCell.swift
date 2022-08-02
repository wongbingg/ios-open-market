//
//  CollectionViewListLayoutCell.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/15.
//

import UIKit

final class ListCell: UICollectionViewCell {
    // MARK: - Cell UIComponents
    private let mainStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        return stackview
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        return stackview
    }()
    
    private let upperStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        return stackview
    }()
    
    private let priceStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.setContentCompressionResistancePriority(UILayoutPriority(800), for: .vertical)
        return stackview
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.text = "Mac mini"
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        return label
    }()
    
    private let productBargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "JPY 300"
        label.sizeToFit()
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "JPY 800"
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        return label
    }()
    
    private lazy var indicatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .lightGray
        label.setContentCompressionResistancePriority(UILayoutPriority(800), for: .vertical)
        label.sizeToFit()
        return label
    }()
    
    lazy var listCellAutoLayoutConstraints: [NSLayoutConstraint] = [
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        mainStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//        productImageView.centerYAnchor.constraint(equalTo: mainStackView.centerYAnchor),
        productImageView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.2),
        productImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
//        firstStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
//        firstStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 5),
//        firstStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -5),
//        firstStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -10)
    ]
    
    lazy var gridCellAutoLayoutConstraints: [NSLayoutConstraint] = [
        productImageView.heightAnchor.constraint(equalTo:self.contentView.heightAnchor, multiplier: 0.5),
//        productImageView.heightAnchor.constraint(equalTo: self.productImageView.widthAnchor),
        mainStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
        mainStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
        mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        mainStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
    ]
    // MARK: - Cell Initailize
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(mainStackView)
        setupAddSubviewsList()
        setupConstraints(style: .list)
        setupLayer(style: .list)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Cell Setup Method
    private func setupAddSubviewsList() {
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(upperStackView)
        verticalStackView.addArrangedSubview(priceStackView)
        
        upperStackView.addArrangedSubview(productNameLabel)
        upperStackView.addArrangedSubview(indicatorLabel)
        
        priceStackView.addArrangedSubview(productPriceLabel)
        priceStackView.addArrangedSubview(productBargainPriceLabel)
    }
    
    private func setupAddSubviewsGrid() {
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(productNameLabel)
        mainStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(indicatorLabel)
    }
    
    private func setupConstraints(style: CellStyle) {
        switch style  {
        case .list:
            NSLayoutConstraint.deactivate(gridCellAutoLayoutConstraints)
            NSLayoutConstraint.activate(listCellAutoLayoutConstraints)
            mainStackView.distribution = .fill
        case .grid:
            NSLayoutConstraint.deactivate(listCellAutoLayoutConstraints)
            NSLayoutConstraint.activate(gridCellAutoLayoutConstraints)
            mainStackView.distribution = .equalSpacing
        }
    }
    
    private func setupLayer(style: CellStyle) {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = .nan
        self.layer.cornerRadius = .nan
        switch style {
        case .list:
            self.layer.borderWidth = 0.5
        case .grid:
            self.layer.borderWidth = 2
            self.layer.cornerRadius = 12
        }
    }
    
    func setup(with inputData: Product) {
        self.productImageView.setImageUrl(inputData.thumbnail)
        self.productNameLabel.text = inputData.name
        setupPriceLabel(currency: inputData.currency,
                        price: inputData.price,
                        bargainPrice: inputData.bargainPrice
        )
        setupIndicatorLabelData(stock: inputData.stock)
    }
    
    func changeStyle(to cellStyle: CellStyle) {
        switch cellStyle {
        case .list:
            mainStackView.axis = .horizontal
            priceStackView.axis = .horizontal
            mainStackView.arrangedSubviews.forEach { view in
                view.removeFromSuperview()
            }
            setupAddSubviewsList()
            setupConstraints(style: .list)
            setupLayer(style: .list)
        case .grid:
            mainStackView.axis = .vertical
            mainStackView.alignment = .center

            priceStackView.axis = .vertical
            mainStackView.arrangedSubviews.forEach { view in
                view.removeFromSuperview()
            }
            setupAddSubviewsGrid()
            setupConstraints(style: .grid)
            setupLayer(style: .grid)
        }
    }
    
    override func prepareForReuse() {
        self.indicatorLabel.textColor = nil
        self.productImageView.image = nil
        self.productPriceLabel.textColor = .lightGray
        self.productPriceLabel.attributedText = nil
        self.productBargainPriceLabel.isHidden = false
        self.mainStackView.alignment = .fill
    }
}

extension ListCell {
    private func setupPriceLabel(currency: Currency, price: Double, bargainPrice: Double) {
        let upperCurreny = currency.rawValue.uppercased()
        if price == bargainPrice {
            let price = price.adoptDecimalStyle()
            self.productBargainPriceLabel.isHidden = true
            self.productPriceLabel.text = "\(upperCurreny) " + price
        } else {
            let price = price.adoptDecimalStyle()
            let bargainPrice = bargainPrice.adoptDecimalStyle()
            self.productPriceLabel.strikethrough(from: "\(upperCurreny) " + price)
            self.productBargainPriceLabel.text = " \(upperCurreny) " + bargainPrice
            self.productPriceLabel.textColor = .red
        }
    }
    
    private func setupIndicatorLabelData(stock: Int) {
        let attriubutedString: NSMutableAttributedString
        if stock > 0 {
            attriubutedString = NSMutableAttributedString(string: "잔여수량 : \(stock) ")
            self.indicatorLabel.textColor = .lightGray
        } else {
            attriubutedString = NSMutableAttributedString(string: "품절 ")
            self.indicatorLabel.textColor = .orange
        }
        let chevronAttachment = NSTextAttachment()
        let chevronImage = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 13,weight: .semibold))?.withTintColor(.lightGray)
        chevronAttachment.image = chevronImage
        let imageWidth = chevronImage?.size.width ?? 0
        let imageHeight = chevronImage?.size.height ?? 0
        chevronAttachment.bounds = CGRect(x: 0, y: -1, width: imageWidth,  height: imageHeight)
        attriubutedString.append(NSAttributedString(attachment: chevronAttachment))
        
        self.indicatorLabel.attributedText = attriubutedString
    }
}
