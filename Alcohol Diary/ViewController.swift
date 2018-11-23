//
//  ViewController.swift
//  Alcohol Diary
//
//  Created by Simon Sawert on 2018-11-17.
//  Copyright © 2018 Simon Sawert. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    @IBOutlet weak var calendarYear: UILabel!
    @IBOutlet weak var calendarMonth: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendar()
    }

    func setupCalendar() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0

        calendarView.visibleDates { (visibleDates) in
            self.updateCalendarLabels(from: visibleDates)
        }
    }

    func updateCalendarLabels(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date

        formatter.dateFormat = "yyyy"
        calendarYear.text = formatter.string(from: date)

        formatter.dateFormat = "MMMM"
        calendarMonth.text = formatter.string(from: date)
    }
}

extension ViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // TODO
    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale

        let startDate = formatter.date(from: "2018-01-01")
        let endDate = formatter.date(from: "2018-12-31")

        let parameters = ConfigurationParameters(
            startDate: startDate!,
            endDate: endDate!,
            numberOfRows: 6,
            firstDayOfWeek: .monday
        )

        return parameters
    }
}

extension ViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell

        cell.dateLabel.text = cellState.text
        cell.selectedView.isHidden = cellState.isSelected ? false : true

        cell.dateLabel.textColor = cellState.dateBelongsTo == .thisMonth ? UIColor.white : #colorLiteral(red: 0.8956849093, green: 0.354319842, blue: 0.2783220272, alpha: 1)

        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }

        validCell.selectedView.isHidden = false
        validCell.dateLabel.textColor = UIColor.black
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateCalendarLabels(from: visibleDates)
    }
}
