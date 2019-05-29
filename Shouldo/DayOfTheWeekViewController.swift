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
        Formatter.shared.dateStyle = .long
        Formatter.shared.dateFormat = "EEE MMM dd"
        self.title = Formatter.shared.string(from: Date())
        
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

