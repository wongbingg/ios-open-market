//
//  ProductSetupViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/28.
//

import UIKit

class ProductSetupViewController: UIViewController , UITextFieldDelegate {
    // MARK: - Properties
    private let manager = NetworkManager.shared
    private var productSetupView: ProductSetupView?
    private var imagePicker = UIImagePickerController()
    var productId: Int?
    var viewControllerTitle: String?
    let fakeView = PickerImageView(frame: CGRect())
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        navigationItem.title = self.viewControllerTitle
        productSetupView = ProductSetupView(self)
        setupKeyboard()
        setupPickerViewController()
        productSetupView?.currencySegmentControl.addTarget(self, action: #selector(changeKeyboardType), for: .valueChanged)
        changeKeyboardType()
        fakeView.setFrame(at: 200)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productSetupView?.productStockTextField.delegate = self
        productSetupView?.productPriceTextField.delegate = self
        productSetupView?.productNameTextField.delegate = self
        productSetupView?.productDiscountedPriceTextField.delegate = self
        guard let productId = productId else {
            productSetupView?.horizontalStackView.addArrangedSubview(productSetupView?.addImageButton ?? UIButton())
            return // 등록인 경우
        }
        manager.requestProductDetail(at: productId) { detail in
            DispatchQueue.main.async { [weak self] in
                self?.updateSetup(with: detail)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: - @objc method
    @objc func keyboardWillAppear(_ sender: Notification) {
        print("keyboard up")
        productSetupView?.horizontalStackView.addArrangedSubview(fakeView)
    }
    @objc func keyboardWillDisappear(_ sender: Notification){
        print("keyboard down")
        productSetupView?.subviews.forEach({ view in
            let imageView = view as! UIImageView
            if imageView == fakeView {
                imageView.isHidden = true
            }
        })
    }
    @objc func cancelButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func doneButtonDidTapped() {
        guard let productRegistration = createProductRegistration(),
              let images = createImages()
        else {
            return
        }
        manager.requestProductRegistration(with: productRegistration, images: images) { detail in
            print("SUCCESS POST - \(detail.id), \(detail.name)")
            DispatchQueue.main.async {
                self.showAlert(title: "알림", message: "게시 완료!!") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc func pickImage() {
        if productSetupView?.horizontalStackView.subviews.count == 6 {
            showAlert(title: "추가할 수 없습니다", message: "5장 이상은 추가 할 수 없습니다.")
            return
        }
        self.present(imagePicker, animated: true)
    }
    
    @objc func changeKeyboardType() {
        if productSetupView?.currencySegmentControl.selectedSegmentIndex == 0 {
            productSetupView?.productPriceTextField.resignFirstResponder()
            productSetupView?.productDiscountedPriceTextField.resignFirstResponder()
            productSetupView?.productPriceTextField.keyboardType = .numberPad
            productSetupView?.productDiscountedPriceTextField.keyboardType = .numberPad
            
        } else {
            productSetupView?.productPriceTextField.resignFirstResponder()
            productSetupView?.productDiscountedPriceTextField.resignFirstResponder()
            productSetupView?.productPriceTextField.keyboardType = .decimalPad
            productSetupView?.productDiscountedPriceTextField.keyboardType = .decimalPad
        }
    }
    // MARK: - ProductSetupVC - Private method
    private func createProductRegistration() -> ProductRegistration? {
        guard let productSetupView = productSetupView,
              let productName = productSetupView.productNameTextField.text,
              let price = Double(productSetupView.productPriceTextField.text ?? ""),
              let discountedPrice = Double(productSetupView.productDiscountedPriceTextField.text ?? ""),
              let stock = Int(productSetupView.productStockTextField.text ?? "")
        else {
            showAlert(title: "알림", message: "텍스트필드에 값을 넣어주세요")
            return nil
        }
        let currency = productSetupView.currencySegmentControl.selectedSegmentIndex == 0 ? Currency.krw : Currency.usd
        let productRegistration = ProductRegistration(name: productName,
                                                      descriptions: productSetupView.descriptionTextView.text,
                                                      price: price,
                                                      currency: currency,
                                                      discountedPrice: discountedPrice,
                                                      stock: stock,
                                                      secret: URLData.secret
        )
        return productRegistration
    }
    
    private func createImages() -> [UIImage]? {
        guard let productSetupView = productSetupView else {
            return nil
        }
        var subviews = productSetupView.horizontalStackView.subviews
        subviews.removeFirst()
        if subviews.count == 0 {
            showAlert(title: "알림", message: "최소 한장의 이미지를 추가 해주세요.")
            return nil
        }
        let images = subviews.map { (subview) -> UIImage in
            let uiimage = subview as? UIImageView
            return uiimage?.image ?? UIImage()
        }
        return images
    }
    
    private func setupKeyboard() {
        
        productSetupView?.productStockTextField.keyboardType = .numberPad // 위치
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTapped))// 위치
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTapped)) // 위치
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    private func setupPickerViewController() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        productSetupView?.addImageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
    }
    
    private func updateSetup(with detail: ProductDetail) {
        detail.images.forEach { image in
            let imageView = PickerImageView(frame: CGRect())
            imageView.setImageUrl(image.url)
            productSetupView?.horizontalStackView.addArrangedSubview(imageView)
        }
        productSetupView?.productNameTextField.text = detail.name
        productSetupView?.productPriceTextField.text = String(detail.price)
        productSetupView?.productDiscountedPriceTextField.text = String(detail.discountedPrice)
        productSetupView?.productStockTextField.text = String(detail.stock)
        productSetupView?.descriptionTextView.text = detail.description
        productSetupView?.currencySegmentControl.selectedSegmentIndex = detail.currency == Currency.krw.rawValue ? 0 : 1
    }
    
    private func showAlert(title: String, message: String, _ completion: (() -> Void)? = nil) {
        let failureAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let completion = completion else { return }
            completion()
        }
        failureAlert.addAction(confirmAction)
        present(failureAlert, animated: true)
    }
    
}

extension ProductSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImge = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImge
        }
        let newImageView = PickerImageView(frame: CGRect())
        newImageView.image = newImage
        productSetupView?.horizontalStackView.addArrangedSubview(newImageView)
        picker.dismiss(animated: true)
    }
}
