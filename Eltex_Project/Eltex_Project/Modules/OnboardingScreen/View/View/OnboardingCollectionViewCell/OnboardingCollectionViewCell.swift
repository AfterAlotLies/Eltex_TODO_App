//
//  OnboardingCollectionViewCell.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit

// MARK: - OnboardingCollectionViewCell
final class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: OnboardingCollectionViewCell.self)
    
    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var previewTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        previewImageView.image = nil
        previewTextLabel.text = nil
    }
    
    func configureCell(_ imageName: String, _ title: String) {
        previewImageView.image = UIImage(named: imageName)
        previewImageView.contentMode = .scaleAspectFit
        previewTextLabel.text = title
    }
    
}

// MARK: - Setup Cell + Setup Constraints
private extension OnboardingCollectionViewCell {
    
    func setupCell() {
        contentView.addSubview(previewImageView)
        contentView.addSubview(previewTextLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            previewImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            previewImageView.heightAnchor.constraint(equalToConstant: 250),
        ])

        NSLayoutConstraint.activate([
            previewTextLabel.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: 16),
            previewTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            previewTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
    }
}
