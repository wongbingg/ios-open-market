//
//  PickerImageVIew.swift
//  OpenMarket
//
//  Created by 유한석 on 2022/07/28.
//

import UIKit

class PickerImageView: UIImageView {

    init(frame: CGRect, eachSide: Int) {
        super.init(frame: frame)
        setupImageView(at: eachSide)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(at line: Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setFrame(at: line)
    }
}
