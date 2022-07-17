//
//  CollectionViewListLayoutCell.swift
//  OpenMarket
//
//  Created by 이원빈 on 2022/07/15.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let verticalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.alignment = .fill
        stackview.distribution = .fill
        return stackview
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .equalSpacing
        return stackview
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.text = "Mac mini"
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "JPY 800"
        return label
    }()
    
    private lazy var indicatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .lightGray
        label.sizeToFit()
        return label
    }()
    
    private var constraintsList: [NSLayoutConstraint]?
    
    func setupAddSubviews(in cell: KindOfCell) {
        if cell == .listCell {
            setupAddSubviewsInListLayout()
        } else {
            setupAddSubviewsInGridLayout()
        }
    }
    
    private func setupAddSubviewsInListLayout() {
        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(verticalStackView)
        
        horizontalStackView.addArrangedSubview(productNameLabel)
        horizontalStackView.addArrangedSubview(indicatorLabel)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(productPriceLabel)
    }
    
    private func setupAddSubviewsInGridLayout() {
        verticalStackView.alignment = .center
        self.contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(productImageView)
        verticalStackView.addArrangedSubview(productNameLabel)
        verticalStackView.addArrangedSubview(productPriceLabel)
        verticalStackView.addArrangedSubview(indicatorLabel)
    }
    
    
    func setupConstraints(in cell: KindOfCell) {
        if cell == .listCell {
            constraintsList = [
                productImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                productImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                productImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
                productImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -10),
                productImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2),
                productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
                
                verticalStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor),
                verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
                verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
                verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
            ]
        } else {
            constraintsList = [
                productImageView.heightAnchor.constraint(equalToConstant: 150),
                productImageView.widthAnchor.constraint(equalToConstant: 150),
                
                verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
                verticalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
            ]
        }
        constraintsList?.forEach { $0.isActive = true }
    }
    
    func setupCellData(with inputData: Product) {
        guard let url = URL(string: inputData.thumbnail) else {
            return
        }
        self.productImageView.loadImage(url: url)
        self.productNameLabel.text = inputData.name
        self.productPriceLabel.text = "\(inputData.currency) \(inputData.price)"
        setupIndicatorLabelData(stock: inputData.stock)
        
    }
    
    private func setupIndicatorLabelData(stock: Int) {
        let attriubutedString: NSMutableAttributedString
        if stock > 0 {
            attriubutedString = NSMutableAttributedString(string: "재고 : \(stock) ")
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
    
    override func prepareForReuse() {
        self.indicatorLabel.textColor = nil
        self.productImageView.image = nil
        self.productNameLabel.text = nil
        self.productPriceLabel.text = nil
    }
}

extension UIImageView {
    
    func loadImage(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            self.image = UIImage(data: data)
        } catch {
            fatalError("error")
        }
    }
}


