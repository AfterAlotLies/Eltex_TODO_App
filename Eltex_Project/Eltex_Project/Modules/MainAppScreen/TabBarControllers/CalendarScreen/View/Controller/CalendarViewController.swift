//
//  CalendarViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 26.12.2024.
//

import UIKit
import Combine

// MARK: - CalendarViewController
final class CalendarViewController: UIViewController {
    
    private enum Constants {
        static let contollerTitle = "Calendar"
    }
    
    private lazy var calendarView: CalendarView = {
        let view = CalendarView(frame: .zero,
                                viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: CalendarViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
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

// MARK: - Private Methods
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
        
        viewModel.$userNotes
            .sink { [weak self] userNotes in
                guard let self = self else { return }
                self.calendarView.setUserNotes(userNotes)
            }
            .store(in: &subscriptions)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let titleLabel = UILabel()
        titleLabel.text = Constants.contollerTitle
        titleLabel.font = UIFont.systemFont(ofSize: 18,
                                            weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
    }
    
    func setupController() {
        view.addSubview(calendarView)
        setupNavBar()
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
