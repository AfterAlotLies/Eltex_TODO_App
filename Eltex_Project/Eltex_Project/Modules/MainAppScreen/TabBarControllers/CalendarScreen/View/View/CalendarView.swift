//
//  CalendarView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 26.12.2024.
//

import UIKit
import FSCalendar

final class CalendarView: UIView {
    
    private lazy var calendarView: FSCalendar = {
        let calendarView = FSCalendar()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.appearance.selectionColor = UIColor(red: 23/255, green: 161/255, blue: 250/255, alpha: 0.4)
        calendarView.appearance.todayColor = UIColor(red: 23/255, green: 161/255, blue: 250/255, alpha: 1)
        calendarView.appearance.titleFont = .systemFont(ofSize: 11)
        calendarView.appearance.weekdayFont = .systemFont(ofSize: 11)
        calendarView.appearance.headerDateFormat = "MMMM"
        calendarView.firstWeekday = 2
        calendarView.appearance.weekdayTextColor = UIColor.white
        calendarView.appearance.headerTitleColor = UIColor.white
        calendarView.appearance.titleDefaultColor = UIColor.white
        calendarView.appearance.titleWeekendColor = UIColor.systemBlue
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.appearance.headerTitleColor = .clear
        calendarView.headerHeight = 50
        return calendarView
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(red: 99/255, green: 217/255, blue: 243/255, alpha: 1)
        button.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = UIColor(red: 99/255, green: 217/255, blue: 243/255, alpha: 1)
        button.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        return button
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var visibleUserNotesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        return tableView
    }()
    
    private let viewModel: CalendarViewModel
    private var visibleNotesModel: [Note]?
    
    init(frame: CGRect, viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCalendarBackground(for: calendarView)
    }
    
    func setVisibleNotes(_ data: [Note]) {
        visibleNotesModel = data
        visibleUserNotesTableView.reloadData()
    }
}

extension CalendarView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = visibleNotesModel else { return 0 }
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as? NotesTableViewCell,
              let model = visibleNotesModel else {
            return UITableViewCell()
        }
        
        let cellData = model[indexPath.row]
        
        cell.configureCell(cellData.noteName,
                           cellData.noteDate,
                           cellData.noteTime,
                           isCompleted: cellData.isCompleted)
        
        return cell
    }
}

extension CalendarView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = visibleNotesModel else { return }
        let selectedNote = model[indexPath.row]
        viewModel.showDetailNote(with: selectedNote)
    }
}

extension CalendarView: FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let currentCalendar = Calendar.current
        
        let displayedMonth = currentCalendar.component(.month, from: calendar.currentPage)
        let displayedYear = currentCalendar.component(.year, from: calendar.currentPage)
        let dateMonth = currentCalendar.component(.month, from: date)
        let dateYear = currentCalendar.component(.year, from: date)
        
        if dateMonth != displayedMonth || dateYear != displayedYear {
            if currentCalendar.isDateInWeekend(date) {
                return UIColor.systemBlue
            } else {
                return UIColor.white
            }
        }
        return nil
    }
    
}

extension CalendarView: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarView.currentPage = calendar.currentPage
        updateHeaderTitle()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = TimeZone.current
        viewModel.filterNote(with: date)
    }
}

private extension CalendarView {
    
    @objc
    func previousMonth() {
        guard let previousMonth = Calendar.current.date(byAdding: .month,
                                                        value: -1,
                                                        to: calendarView.currentPage) else {
            return
        }
        calendarView.setCurrentPage(previousMonth, animated: true)
        calendarView.currentPage = previousMonth
        updateHeaderTitle()
    }
    
    @objc
    func nextMonth() {
        guard let nextMonth = Calendar.current.date(byAdding: .month,
                                                    value: 1,
                                                    to: calendarView.currentPage) else {
            return
        }
        calendarView.setCurrentPage(nextMonth, animated: true)
        calendarView.currentPage = nextMonth
        updateHeaderTitle()
    }
    
    func updateHeaderTitle() {
        titleLabel.text = dateFormatter.string(from: calendarView.currentPage)
    }
    
    func setupCalendarBackground(for calendar: FSCalendar) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 26/255, green: 66/255, blue: 130/255, alpha: 1).cgColor,
            UIColor(red: 43/255, green: 86/255, blue: 161/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = calendar.bounds
        
        let backgroundView = UIView(frame: calendar.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = calendar.bounds
        blurView.alpha = 0.4
        
        backgroundView.addSubview(blurView)
        backgroundView.layer.cornerRadius = 12
        backgroundView.clipsToBounds = true
        
        calendar.insertSubview(backgroundView, at: 0)
    }
    
    func setupView() {
        addSubview(calendarView)
        addSubview(headerView)
        addSubview(visibleUserNotesTableView)
        
        headerView.addSubview(previousButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(nextButton)
        
        updateHeaderTitle()
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            calendarView.heightAnchor.constraint(equalToConstant: 285),
            calendarView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            calendarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            previousButton.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -16),
            previousButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            nextButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            nextButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            visibleUserNotesTableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 36),
            visibleUserNotesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            visibleUserNotesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            visibleUserNotesTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
}
