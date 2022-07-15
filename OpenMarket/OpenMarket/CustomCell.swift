//
//  CustomCell.swift
//  OpenMarket
//
//  Created by 이원빈 on 2022/07/14.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.image = UIImage(named: "loading")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.alignment = .fill
        stackview.distribution = .fill
        return stackview
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(verticalStackView)
        self.contentView.addSubview(indicatorLabel)
        
        verticalStackView.addArrangedSubview(productNameLabel)
        verticalStackView.addArrangedSubview(productPriceLabel)
        
        productImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        productImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -10).isActive = true
        productImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2).isActive = true
        productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor).isActive = true
        
        verticalStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: self.indicatorLabel.leadingAnchor).isActive = true
        
        
        indicatorLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        indicatorLabel.bottomAnchor.constraint(equalTo: productNameLabel.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.indicatorLabel.textColor = .lightGray
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

class CustomCell2: CustomCell {
    
}
