//
//  SettingsTableViewCell.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 25.12.2024.
//

import UIKit

// MARK: - SettingsTableViewCell
final class SettingsTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let cellInfoImage = UIImage(named: "cellInfoImage")
    }
    
    static let identifier: String = String(describing: SettingsTableViewCell.self)
    
    private lazy var settingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var settingNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var moreInformationCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constants.cellInfoImage
        return imageView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.5)
        return view
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configureCell(with settings: Settings) {
        settingImageView.image = UIImage(named: settings.image)
        settingNameLabel.text = settings.title
    }
}

// MARK: - Private Methods
private extension SettingsTableViewCell {
    
    func setupCell() {
        contentView.addSubview(containerView)
        containerView.addSubview(settingImageView)
        containerView.addSubview(settingNameLabel)
        containerView.addSubview(moreInformationCell)
        contentView.addSubview(separatorView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -4),
        ])
        
        NSLayoutConstraint.activate([
            settingImageView.heightAnchor.constraint(equalToConstant: 24),
            settingImageView.widthAnchor.constraint(equalToConstant: 24),
            settingImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            settingImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4)
        ])
        
        NSLayoutConstraint.activate([
            settingNameLabel.centerYAnchor.constraint(equalTo: settingImageView.centerYAnchor),
            settingNameLabel.leadingAnchor.constraint(equalTo: settingImageView.trailingAnchor, constant: 16),
            settingNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            moreInformationCell.widthAnchor.constraint(equalToConstant: 9),
            moreInformationCell.heightAnchor.constraint(equalToConstant: 16),
            moreInformationCell.centerYAnchor.constraint(equalTo: settingImageView.centerYAnchor),
            moreInformationCell.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
}
