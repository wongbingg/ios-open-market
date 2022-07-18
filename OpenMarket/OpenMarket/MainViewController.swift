//
//  MainViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/14.
//
import UIKit

class MainViewController: UIViewController {
    // MARK: - Instance Properties
    private let manager = NetworkManager()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>?
    
    enum Section {
        case main
    }
    
    // MARK: - UI Properties
    private var shouldHideListLayout: Bool? {
        didSet {
            guard let shouldHideListLayout = shouldHideListLayout else { return }
            print("DID TAPPED SEGMENT CONTROLLER")
            if shouldHideListLayout {
                configureDataSource()
                dataSource?.apply(snapshot, animatingDifferences: true)
                collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
            } else {
                configureDataSource()
                dataSource?.apply(snapshot, animatingDifferences: true)
                collectionView.setCollectionViewLayout(createListLayout(), animated: true)
            }
        }
    }
    
    private let segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["Table", "Grid"])
        segmentController.translatesAutoresizingMaskIntoConstraints = true
        segmentController.selectedSegmentIndex = 0
        return segmentController
    }()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addUIComponents()
        setupSegment()
        configureHierarchy()
        configureDataSource()
        manager.dataTask { [weak self] productList in
            self?.snapshot.appendSections([.main])
            self?.snapshot.appendItems(productList)
            self?.dataSource?.apply(self!.snapshot, animatingDifferences: true)
        }
    }
    
    private func addUIComponents() {
        self.navigationItem.titleView = segmentController
    }
    
    private func setupSegment() {
        didChangeValue(segment: self.segmentController)
        self.segmentController.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        segmentController.layer.shadowPath = .none
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideListLayout = segment.selectedSegmentIndex != 0
    }
}

extension MainViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension MainViewController {
    
    private func configureHierarchy(){
        collectionView.frame = view.bounds
        collectionView.setCollectionViewLayout(createListLayout(), animated: true)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        guard let isGrid = shouldHideListLayout else { return }
        let cellRegistration = UICollectionView.CellRegistration<CustomCell, Product> { (cell, indexPath, product) in
            if isGrid {
                cell.setupAddSubviews(in: .gridCell)
                cell.setupConstraints(in: .gridCell)
                cell.setupCellData(with: product)
                cell.layer.borderColor = UIColor.lightGray.cgColor
                cell.layer.borderWidth = 2
                cell.layer.cornerRadius = 16
            } else {
                cell.setupAddSubviews(in: .listCell)
                cell.setupConstraints(in: .listCell)
                cell.setupCellData(with: product)
            }
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
