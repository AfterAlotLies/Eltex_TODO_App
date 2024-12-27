//
//  OnboardingView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit
import Combine

// MARK: - OnboardingView
final class OnboardingView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "nextImage")
        button.configuration = configuration
        
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        
        button.layer.shadowColor = UIColor.white.withAlphaComponent(0.5).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 5
        
        button.addTarget(self, action: #selector(nextButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var snakePageControl: SnakePageControl = {
        let view = SnakePageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: OnboardingViewModel
    
    private var paginationModel: [Page]?
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        setupBindings()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nextButton.layer.cornerRadius = nextButton.bounds.size.height / 2
    }
    
    func setPagitaionData(_ data: [Page]) {
        paginationModel = data
    }
}

// MARK: - OnboardingView + UICollectionViewDataSource
extension OnboardingView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = paginationModel else { return 0 }
        let count = model.count
        snakePageControl.pageCount = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell,
        let model = paginationModel else {
            return UICollectionViewCell()
        }
        
        let cellData = model[indexPath.item]
        
        cell.configureCell(cellData.imageName, cellData.title)
        
        return cell
    }
}

// MARK: - OnboardingView + UICollectionViewDelegate
extension OnboardingView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let model = paginationModel else { return }
        if indexPath.item == model.count - 1 {
            nextButton.setImage(UIImage(named: "doneImage"), for: .normal)
        } else {
            nextButton.setImage(UIImage(named: "nextImage"), for: .normal)
        }
    }
}

// MARK: - OnboardingView + UIScrollViewDelegate Method
extension OnboardingView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let contentOffsetX = scrollView.contentOffset.x
        viewModel.didChangePaginationScrollProgress(for: pageWidth,
                                                    with: contentOffsetX)
    }
}

// MARK: - OnboardingView + UICollectionViewDelegateFlowLayout
extension OnboardingView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height / 1.5)
    }
}

// MARK: - Private methods
private extension OnboardingView {
    
    @objc
    func nextButtonHandler() {
        guard let model = paginationModel else { return }
        if snakePageControl.currentPage == model.count - 1 {
            viewModel.didFinish()
        }
        viewModel.didChangePaginationButtonHandlerProgress(for: snakePageControl.pageCount,
                                                           with: snakePageControl.progress)
    }
    
    func setupBindings() {
        viewModel.$paginationScrollProgreess
            .sink { [weak self] progress in
                guard let self = self else { return }
                self.snakePageControl.progress = progress
            }
            .store(in: &subscriptions)
        
        viewModel.$paginationButtonHandlerProgress
            .sink { [weak self] progress in
                guard let self = self else { return }
                snakePageControl.progress = progress
                if progress > 0 {
                    let indexPath = IndexPath(item: Int(progress), section: 0)
                    self.collectionView.scrollToItem(at: indexPath,
                                                     at: .centeredHorizontally,
                                                     animated: true)
                }
            }
            .store(in: &subscriptions)
    }
    
    func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = .zero
        collectionViewLayout.sectionInset = .zero
        collectionViewLayout.minimumInteritemSpacing = .zero
        collectionViewLayout.scrollDirection = .horizontal
        return collectionViewLayout
    }
}

// MARK: - Setup View + Setup Constraints
private extension OnboardingView {
    
    func setupView() {
        addSubview(collectionView)
        addSubview(snakePageControl)
        addSubview(nextButton)
        
        backgroundColor = .clear
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: snakePageControl.topAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            snakePageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor, constant: -6),
            snakePageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            snakePageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            nextButton.heightAnchor.constraint(equalToConstant: 70),
            nextButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
