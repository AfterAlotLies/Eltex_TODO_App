//
//  CalendarViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 26.12.2024.
//

import UIKit
import Combine

final class CalendarViewController: UIViewController {
    
    private lazy var calendarView: CalendarView = {
        let view = CalendarView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: CalendarViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
    }
}

private extension CalendarViewController {
    
    func setupBindings() {
        viewModel.$visibleUserNote
            .sink { [weak self] visibleUserNote in
                guard let self = self else { return }
                if let visibleUserNote {
                    self.calendarView.setVisibleNotes(visibleUserNote)
                }
            }
            .store(in: &subscriptions)
    }
    
    func setupController() {
        view.addSubview(calendarView)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Calendar"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
