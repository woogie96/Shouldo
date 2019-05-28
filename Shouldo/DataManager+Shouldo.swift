//
//  DataManager+Shouldo.swift
//  Shouldo
//
//  Created by woogie on 21/05/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import Foundation
import CoreData

extension DataManager {
    func createShouldo(task: String, isFinished: String, dayOfTheWeek: String, completion: (()->())? = nil) {
        mainContext.perform {
            let newShouldo = ShouldoEntity(context: self.mainContext)
            if dayOfTheWeek == "eve" {
                newShouldo.task = "~  \(task)"
            } else {
                newShouldo.task = "•  \(task)"
            }
            newShouldo.isFinished = isFinished
            newShouldo.dayOfTheWeek = dayOfTheWeek
            self.saveMainContext()
            completion?()
        }
    }
    
    func fetchShouldo(dayOfTheWeek: String) -> [ShouldoEntity] {
        var list = [ShouldoEntity]()
        
        mainContext.performAndWait {
            let request: NSFetchRequest<ShouldoEntity> = ShouldoEntity.fetchRequest()
            if dayOfTheWeek == "eve"{
                request.predicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", dayOfTheWeek)
            } else {
                let everyPredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", "eve")
                let dayPredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", dayOfTheWeek)
                let orPredicate = NSCompoundPredicate(type: .or, subpredicates: [everyPredicate, dayPredicate])
                request.predicate = orPredicate
            }
            let sortByDay = NSSortDescriptor(key: #keyPath(ShouldoEntity.dayOfTheWeek), ascending: true)
            let sortByTask = NSSortDescriptor(key: #keyPath(ShouldoEntity.task), ascending: true)
            request.sortDescriptors = [sortByDay, sortByTask]
            do {
                list = try mainContext.fetch(request)
            } catch {
                print(error)
            }
        }
        
        return list
    }
    
    func fetchSearchTotal() -> [ShouldoEntity] {
        var total = [ShouldoEntity]()
        mainContext.performAndWait {
            let request: NSFetchRequest<ShouldoEntity> = ShouldoEntity.fetchRequest()
            let monPredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", "mon")
            let tuePredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", "tue")
            let wedPredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", "wed")
            let thuPredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", "thu")
            let friPredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", "fri")
            let satPredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", "sat")
            let sunPredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", "sun")
            let totalPredicate = NSCompoundPredicate(type: .or, subpredicates: [monPredicate, tuePredicate, wedPredicate, thuPredicate, friPredicate, satPredicate, sunPredicate])
            request.predicate = totalPredicate
            let sortByTask = NSSortDescriptor(key: #keyPath(ShouldoEntity.task), ascending: true)
            request.sortDescriptors = [sortByTask]
            do {
                total = try mainContext.fetch(request)
            } catch {
                fatalError()
            }
        }
        return total
    }
    
    func fetchTotalCount() -> Int {
        var total: Int = 0
        var eve: Int = 0
        mainContext.performAndWait {
            let totalRequest: NSFetchRequest<ShouldoEntity> = ShouldoEntity.fetchRequest()
            let eveRequest: NSFetchRequest<ShouldoEntity> = ShouldoEntity.fetchRequest()
            
            let evePredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", "eve")
            
            eveRequest.predicate = evePredicate
            
            do {
                total = try mainContext.count(for: totalRequest)
                eve = try mainContext.count(for: eveRequest)
            } catch {
                fatalError()
            }
        }
        return total - eve
    }
    
    func fetchDoneCount() -> Int {
        var done: Int = 0
        mainContext.performAndWait {
            let request: NSFetchRequest<ShouldoEntity> = ShouldoEntity.fetchRequest()
            let donePredicate = NSPredicate(format: "isFinished CONTAINS %@", "done")
            request.predicate = donePredicate
            do{
                done = try mainContext.count(for: request)
            } catch {
                fatalError()
            }
        }
        return done
    }
    
    func fetchNotDoneCount(dayOfTheWeek: String) -> Int {
        var dayTotal: Int = 0
        var dayDone: Int = 0
        
        mainContext.performAndWait {
            let dayTotalRequest: NSFetchRequest<ShouldoEntity> = ShouldoEntity.fetchRequest()
            let dayDoneRequest: NSFetchRequest<ShouldoEntity> = ShouldoEntity.fetchRequest()
            
            let dayPredicate = NSPredicate(format: "dayOfTheWeek CONTAINS %@", dayOfTheWeek)
            let donePredicate = NSPredicate(format: "isFinished CONTAINS %@", "done")
            let dayDonePredicate = NSCompoundPredicate(type: .and, subpredicates: [dayPredicate, donePredicate])
            
            dayTotalRequest.predicate = dayPredicate
            dayDoneRequest.predicate = dayDonePredicate
            do {
                dayTotal = try mainContext.count(for: dayTotalRequest)
                dayDone = try mainContext.count(for: dayDoneRequest)
            } catch {
                fatalError()
            }
        }
        return dayTotal - dayDone
    }
    
    func updateShouldo(entity: ShouldoEntity, isFinished: String?) {
        mainContext.perform {
            entity.isFinished = isFinished
            self.saveMainContext()
        }
    }
    
    func deleteShouldo(entity: ShouldoEntity) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveMainContext()
        }
    }
    
    func deleteShouldos(entities: [ShouldoEntity]) {
        mainContext.performAndWait {
            for entity in entities {
                self.mainContext.delete(entity)
            }
            self.saveMainContext()
        }
    }
}
