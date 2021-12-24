//
//  CalendarViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import FSCalendar

class CalendarViewController: BaseViewController {
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var calendarViewHeight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var lblEmpty: UILabel!
    
    private let disposeBag = DisposeBag()
    
    private var events = [Date]()
    private var todayDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapEvent()
        loadEvent()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "먹계부"
        setupDate()
    }
    
    private func setupDate() {
        if let todayDate = calendarView.today {
            CalendarViewModel.shared.loadCalendarData(todayDate)
            self.todayDate = todayDate
        }
    }
    
    private func setupUI() {
        setupCalendar()
        
        btnPlus.backgroundColor = .themeColor
        btnPlus.layer.cornerRadius = btnPlus.frame.width / 2
        btnPlus.layer.shadowColor = UIColor.gray.cgColor
        btnPlus.layer.shadowOpacity = 1.0
        btnPlus.layer.shadowOffset = CGSize(width: 2, height: 2)
        btnPlus.layer.shadowRadius = 2
        btnPlus.setTitle("", for: .normal)
        
        emptyView.backgroundColor = .bgColor
        
        lblEmpty.text = "저장된 내용이 없어요."
        lblEmpty.textColor = .themeColor
        lblEmpty.font = UIFont(name: "EliceDigitalBaeumOTF", size: 16)
    }
    
    private func setupCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        // 전체 사이즈의 절반
        calendarViewHeight.constant = self.view.frame.height / 2
        // 배경색
        calendarView.backgroundColor = .bgColor
        // 상단 헤더 타이틀
        calendarView.appearance.headerTitleFont = UIFont(name: "EliceDigitalBaeumOTF-Bd", size: 17)
        calendarView.appearance.headerTitleColor = .themeColor
        calendarView.appearance.headerDateFormat = "YYYY년 M월"
        // 요일
        calendarView.appearance.weekdayFont = UIFont(name: "EliceDigitalBaeumOTF-Bd", size: 14)
        calendarView.appearance.weekdayTextColor = .themeColor
        // 달력 내부 숫자
        calendarView.appearance.titleFont = UIFont(name: "EliceDigitalBaeumOTF", size: 14)
        calendarView.appearance.titleDefaultColor = .themeColor
        // 선택된 날짜 색상
        calendarView.appearance.selectionColor = .themeColor
        // 오늘 날짜 색상
        calendarView.appearance.todayColor = .themeColor
        // event (dot) 색상
        calendarView.appearance.eventDefaultColor = .themeColor
        calendarView.appearance.eventSelectionColor = .themeColor
        
        CoreDataManager.shared.isSuccess.subscribe { _ in
            self.loadEvent()
        }.disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "CalendarCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CalendarCell")
        tableView.rowHeight = 50
        
        tableView.backgroundColor = .bgColor
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCalendarData> { dataSource, tableview, indexPath, item in
            let cell = tableview.dequeueReusableCell(withIdentifier: "CalendarCell") as! CalendarCell
            cell.backgroundColor = .bgColor
            cell.selectionStyle = .none
            
            cell.lblTitle.text = item.title
            
            if item.memo == "" {
                cell.lblMemo.text = "입력한 메모가 없어요."
            } else {
                cell.lblMemo.text = item.memo
            }
            
            self.emptyView.isHidden = !CalendarViewModel.shared.calendarData.value.isEmpty
            
            return cell
        }
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        CalendarViewModel.shared.calendarData
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(CalendarItem.self)
            .subscribe(onNext: { item in
                self.goToSaveAlert(type: .calendarEdit, item: item)
            }).disposed(by: disposeBag)
        
        tableView.rx
            .modelDeleted(CalendarItem.self)
            .subscribe(onNext: { item in
                CalendarViewModel.shared.deleteCalendarData(date: item.date, title: item.title, memo: item.memo)
                self.emptyView.isHidden = !CalendarViewModel.shared.calendarData.value.isEmpty
            }).disposed(by: disposeBag)
    }
    
    private func loadEvent() {
        events.removeAll()
        let calendarData = CoreDataManager.shared.loadAllCalendarData()
        calendarData.forEach { data in
            guard let date = data.date else { return }
            
            let formatDate = CalendarViewModel.shared.formatDate(date)
            events.append(formatDate!)
        }
        
        calendarView.reloadData()
    }
    
    private func setupTapEvent() {
        btnPlus.rx.tap
            .subscribe(onNext: {
                CalendarViewModel.shared.date = self.todayDate
                self.goToSaveAlert(type: .calendar, item: nil)
            }).disposed(by: disposeBag)
    }
    
    private func goToSaveAlert(type: AlertType, item: CalendarItem?) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaveAlertViewController") as? SaveAlertViewController else { return }
        vc.alertType = type
        
        if let item = item {
            vc.editItem = item
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        self.present(alert, animated: true)
    }
}

extension CalendarViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarView.today = nil
        todayDate = CalendarViewModel.shared.formatDate(date)!
        CalendarViewModel.shared.loadCalendarData(todayDate)
        emptyView.isHidden = !CalendarViewModel.shared.calendarData.value.isEmpty
    }
    
    // 이벤트 표시
    // return = 이벤트 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if events.contains(date) {
            return 1
        }
        return 0
    }
}
