//
//  Firebase+ReactiveKit.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import FirebaseDatabase
import ReactiveKit

extension DatabaseReference {
    
    func signalForEvent(event: DataEventType) -> Signal<DataSnapshot, NSError> {
        return Signal { observer in
            let handle = self.observe(event, with: { snapshot in
                observer.next(snapshot)
            }, withCancel: { err in
                observer.failed(err as NSError)
            })
            
            return BlockDisposable {
                self.removeObserver(withHandle: handle)
            }
        }
    }
    
    func signalForSingleEvent(event: DataEventType) -> Signal<DataSnapshot, NSError> {
        return Signal { observer in
            self.observeSingleEvent(of: event, with: { snapshot in
                observer.next(snapshot)
                observer.completed()
            })
            
            return NonDisposable.instance
        }
    }
}
