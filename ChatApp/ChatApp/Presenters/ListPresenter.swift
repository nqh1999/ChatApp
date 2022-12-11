//
//  ListPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation
import Firebase

protocol ListProtocol: AnyObject {
    
}

class ListPresenter {
    
    // MARK: - Properties
    private weak var view: ListProtocol?
    private var db = Firestore.firestore()
    private var receivers = [User]()
    private var sender: User?
    private var searchData = [User]()
    
    // MARK: - Init
    init(view: ListProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func getNumberOfUser() -> Int {
        return self.searchData.count
    }
    
    func getUserByIndex(index: Int) -> User? {
        return self.searchData[index]
    }
    
    func setData(sender: User, receivers: [User]) {
        self.sender = sender
        self.receivers = receivers
        self.searchData = receivers
    }
    
    func getSender() -> User? {
        return self.sender
    }
    
    // MARK: - Handler Methods
    // fill data after search
    func filterData(text: String) {
        self.searchData = text.isEmpty ? receivers : receivers.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
}
