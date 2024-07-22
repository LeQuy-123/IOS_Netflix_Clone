//
//  DataPersistenceManager.swift
//  Netflix clone
//
//  Created by mac on 16/7/24.
//

import Foundation
import UIKit
import CoreData

enum DatabaseError: Error {
    case FaildToSaveData
    case FaildToGetData
    case FailedToDeleteData
}

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.name = model.name
        item.overview = model.overview
        item.release_date  = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        item.poster_path = model.poster_path
        item.adult = model.adult ?? false
        item.video = model.video ?? false
        item.backdrop_path = model.backdrop_path
        
        do {
           try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.FaildToSaveData))
        
        }
    }
    
    func getTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let request:NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
 
        
        do {
            let titles = try context.fetch(request)
             
            completion(.success(titles))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.FaildToGetData))
        
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>)-> Void) {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            
            
            context.delete(model)
            
            do {
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(DatabaseError.FailedToDeleteData))
            }
            
        }
}
