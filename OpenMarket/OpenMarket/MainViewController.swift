//
//  MainViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/14.
//
/*
 1. 세그
 2. 테이블뷰컨트롤러 설정
 3. 콜렉션뷰 설정
 */
import UIKit

@available(iOS 14.0, *)
class MainViewController: UIViewController {
    
    var productList: [Product]?
    var manager = Manager()
    
    enum Section {
        case main
    }
    
    private let segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["Table", "Grid"])
        segmentController.translatesAutoresizingMaskIntoConstraints = true
        segmentController.selectedSegmentIndex = 0
        return segmentController
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.dataTask { result in
            self.productList = result.pages
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
//        guard let filePath = NSDataAsset.init(name: "MockData") else { return }
//        guard let result = decode(from: filePath.data, to: ProductPage.self) else { return }
//        productList = result.pages
        self.navigationItem.titleView = segmentController
        
        self.segmentController.addTarget(self, action: #selector(layout), for: .valueChanged)
        self.segmentController.addTarget(self, action: #selector(dataSouce), for: .valueChanged)
        configureHierarchy()
        configureDataSource()
    }
}

@available(iOS 14.0, *)
extension MainViewController {
    /// - Tag: List
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 19, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

@available(iOS 14.0, *)
extension MainViewController {
    
    @objc private func layout() {
        if segmentController.selectedSegmentIndex == 0 {
            view.subviews.forEach { $0.removeFromSuperview() ; $0.isHidden = true }
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(collectionView)
            collectionView.delegate = self
            
        } else {
            view.subviews.forEach { $0.removeFromSuperview() ; $0.isHidden = true }
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridLayout())
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(collectionView)
            collectionView.delegate = self
        }
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    @objc private func dataSouce() {
        configureDataSource()
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<CustomCell, Int> { (cell, indexPath, item) in
            if let productList = self.productList {
                let selectedProduct = productList[indexPath.row]
                cell.setupCellData(with: selectedProduct)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<50)) // 이부분 어떻게 처리 .? 일단 받아오는 product 갯수만큼 임의지정 해주었다.
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

@available(iOS 14.0, *)
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
