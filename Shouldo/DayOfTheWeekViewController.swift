//
//  DayOfTheWeekViewController.swift
//  Shouldo
//
//  Created by woogie on 22/05/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import UIKit
import CoreData


class DayOfTheWeekViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentLabel: UILabel!
    
    let cellIds = ["MondayCell", "TuesdayCell", "WednesdayCell", "ThursdayCell", "FridayCell", "SaturdayCell", "SundayCell", "EverydayCell"]
    
    let cellSizes = Array(repeatElement(CGSize(width: 180, height: 120), count: 8))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shouldo"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       progressViewUpdate()
    }
    func progressViewUpdate() {
        let total = DataManager.shared.fetchTotalCount()
        let done = DataManager.shared.fetchDoneCount()
        if done != 0 && total != 0 {
            let input = Float(Double(done) / Double(total))
            progressView.progress = input
            let percent = input * 100
            percentLabel.text = "\(floor(percent * 10)/10)%"
        } else {
            progressView.progress = 0
            percentLabel.text = "0%"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShouldoViewController {
            if segue.identifier == "mon" {
                vc.dayOfTheWeek = "mon"
            } else if segue.identifier == "tue"{
                vc.dayOfTheWeek = "tue"
            } else if segue.identifier == "wed"{
                vc.dayOfTheWeek = "wed"
            } else if segue.identifier == "thu"{
                vc.dayOfTheWeek = "thu"
            } else if segue.identifier == "fri"{
                vc.dayOfTheWeek = "fri"
            } else if segue.identifier == "sat"{
                vc.dayOfTheWeek = "sat"
            } else if segue.identifier == "sun"{
                vc.dayOfTheWeek = "sun"
            } else if segue.identifier == "eve"{
                vc.dayOfTheWeek = "eve"
            }
        }
    }
    @IBAction func trashButtonTapped(_ sender: Any) {
        let controller = UIAlertController(title: "Delete", message: "Choose the day", preferredStyle: .actionSheet)
        
        let mondayAction = UIAlertAction(title: "월요일", style: .default) { (_) in
            let mondayShouldos: [ShouldoEntity] = DataManager.shared.fetchShouldo(dayOfTheWeek: "mon")
            DataManager.shared.deleteShouldos(entities: mondayShouldos)
            self.progressViewUpdate()
        }
        controller.addAction(mondayAction)
        
        let tuesdayAction = UIAlertAction(title: "화요일", style: .default) { (_) in
            let tuesdayShouldos: [ShouldoEntity] = DataManager.shared.fetchShouldo(dayOfTheWeek: "tue")
            DataManager.shared.deleteShouldos(entities: tuesdayShouldos)
            self.progressViewUpdate()
        }
        controller.addAction(tuesdayAction)
        
        let wednesdayAction = UIAlertAction(title: "수요일", style: .default) { (_) in
            let wednesdayShouldos: [ShouldoEntity] = DataManager.shared.fetchShouldo(dayOfTheWeek: "wed")
            DataManager.shared.deleteShouldos(entities: wednesdayShouldos)
            self.progressViewUpdate()
        }
        controller.addAction(wednesdayAction)
        
        let thursdayAction = UIAlertAction(title: "목요일", style: .default) { (_) in
            let thursdayShouldos: [ShouldoEntity] = DataManager.shared.fetchShouldo(dayOfTheWeek: "thu")
            DataManager.shared.deleteShouldos(entities: thursdayShouldos)
            self.progressViewUpdate()
        }
        controller.addAction(thursdayAction)
        
        let fridayAction = UIAlertAction(title: "금요일", style: .default) { (_) in
            let fridayShouldos: [ShouldoEntity] = DataManager.shared.fetchShouldo(dayOfTheWeek: "fri")
            DataManager.shared.deleteShouldos(entities: fridayShouldos)
            self.progressViewUpdate()
        }
        controller.addAction(fridayAction)
        
        let saturdayAction = UIAlertAction(title: "토요일", style: .default) { (_) in
            let saturdayShouldos: [ShouldoEntity] = DataManager.shared.fetchShouldo(dayOfTheWeek: "sat")
            DataManager.shared.deleteShouldos(entities: saturdayShouldos)
            self.progressViewUpdate()
        }
        controller.addAction(saturdayAction)
        
        let sundayAction = UIAlertAction(title: "일요일", style: .default) { (_) in
            let sundayShouldos: [ShouldoEntity] = DataManager.shared.fetchShouldo(dayOfTheWeek: "sun")
            DataManager.shared.deleteShouldos(entities: sundayShouldos)
            self.progressViewUpdate()
        }
        controller.addAction(sundayAction)
        
        let deleteAllAction = UIAlertAction(title: "전체 삭제", style: .default) { (_) in
            let allShouldos: [ShouldoEntity] = DataManager.shared.fetchSearchTotal()
            DataManager.shared.deleteShouldos(entities: allShouldos)
            self.progressViewUpdate()
        }
        controller.addAction(deleteAllAction)
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        controller.addAction(cancleAction)
        
        present(controller, animated: true, completion: nil)
    }
}


extension DayOfTheWeekViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return cellIds.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIds[indexPath.item], for: indexPath)
        return cell
    }
}

extension DayOfTheWeekViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
}

