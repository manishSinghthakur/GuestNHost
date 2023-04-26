//
//  NetworkCoreDataManager.swift
//  NisumNetwork
//
//  Created by nisum on 12/10/21.
//

import CoreData

// A NSPersistentContainer property to perform coredata action
internal var persistentContainer: NSPersistentContainer? = {
    guard let modelURL = Bundle.module.url(forResource:"NisumNetwork", withExtension: "momd") else { return  nil }
    guard let model = NSManagedObjectModel(contentsOf: modelURL) else { return nil }
    let container = NSPersistentContainer(name:"NisumNetwork",managedObjectModel:model)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

public class NetworkCoreDataManager: ObservableObject {
    
   // @Published var recordLimit: RecordRange = .all
    
    // A singleton for our entire app to use
    public static let shared = NetworkCoreDataManager()
}


extension NetworkCoreDataManager {
    
    internal func maintaneNetworkLog(_ screenName: String, action: String?,
                                     result: String, notes: String) {
        guard let container = persistentContainer else { return }
        let networkLog = NetworkLog(context: container.viewContext)
        networkLog.screenname = screenName
        networkLog.result = result
        networkLog.action = (action != nil) ? action : ""
        networkLog.notes = notes
        networkLog.time = Date()
        do {
            try container.viewContext.save()
            print("Log saved succesfuly")
        } catch let error {
            print("Failed to store log: \(error.localizedDescription)")
        }
    }
    
    public func fetchNetworkLog(_ daysRecord: RecordRange,
                                completion: @escaping ([NetworkLog]) -> Void) {
        var networkLogs = [NetworkLog]()
        guard let beginDate = Calendar.current.date(byAdding: .day, value: -(daysRecord.code), to: Date()), let container = persistentContainer else {return}
        let fetchRequest: NSFetchRequest<NetworkLog> = NetworkLog.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "time <= %@", beginDate as CVarArg)
        do {
            networkLogs = try container.viewContext.fetch(fetchRequest)
            completion(networkLogs)
        } catch let errore {
            print("error FetchRequest \(errore)")
        }
        completion(networkLogs)
    }
    
    public func viewNetworkLogs(_ daysRecord: RecordRange) -> NetworkLogView {
        return NetworkLogView(numberOfDaysRecord: daysRecord)
    }
}

