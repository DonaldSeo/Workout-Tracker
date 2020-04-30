//
//  ProgressViewController.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-28.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RealmSwift


class ProgressViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var exercisePicker: UIPickerView!
    @IBOutlet weak var barChartView: BarChartView!
    lazy var realm = try! Realm()
    var selectedExercise: String?
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exercisePicker.dataSource = self
        exercisePicker.delegate = self
        axisFormatDelegate = self
        
        exercisePicker.selectRow(0, inComponent: 0, animated: true)
        
//        updateChartWithData()
        
    }
    
    func updateChartWithData() {
         var dataEntries: [BarChartDataEntry] = []
        let finishedSessionExerciseArray = getFinishedExerciseSetsfromDB(selectedExercise: self.selectedExercise!)
        
        for i in 0..<finishedSessionExerciseArray.count {
            let dateInterval: TimeInterval = finishedSessionExerciseArray[i].dateCreated!.timeIntervalSince1970
            let dataEntry = BarChartDataEntry(x: Double(dateInterval), y: finishedSessionExerciseArray[i].weight)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Weight")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        
        let xAxis = barChartView.xAxis
        xAxis.valueFormatter = axisFormatDelegate
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false

        
        barChartView.data = chartData
        
    }
    
// MARK: - pickerview Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let exerciseArray = getExerciseArrayFromDB()
        return exerciseArray.count
        
    }
// MARK: - pickerview delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let exerciseArray = getExerciseArrayFromDB()
        return exerciseArray[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let exerciseArray = getExerciseArrayFromDB()
        self.selectedExercise = exerciseArray[row].name
        print(getFinishedExerciseSetsfromDB(selectedExercise: self.selectedExercise!))
        updateChartWithData()

        
    }
    
    func getExerciseArrayFromDB() -> Results<SessionExercise> {
        do {
            return realm.objects(SessionExercise.self)
        } catch let error as NSError {
          fatalError(error.localizedDescription)
        }
    }
    func getFinishedExerciseSetsfromDB(selectedExercise name: String) -> Results<FinishedExerciseSets> {
        print(name)
        do {
            var initialObjectResults = realm.objects(FinishedExerciseSets.self).filter("exerciseName = '\(name)'")
            return initialObjectResults
        }catch let error as NSError {
          fatalError(error.localizedDescription)
        }
    }
    
}
// MARK: - axisFormate Delegate
extension ProgressViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
    
    
}
