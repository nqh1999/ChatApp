//
//  ListPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation
import Firebase

protocol ListProtocol: AnyObject {
    func didGetUser()
}

class ListPresenter {
    
    // MARK: - Properties
    private weak var view: ListProtocol?
    private var db = Firestore.firestore()
    private var userDetails = [UserDetail]()
    private var searchData = [UserDetail]()
    private var currentId: Int = 0
    
    // MARK: - Init
    init(view: ListProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func setCurrentId(id: Int) {
        self.currentId = id
    }
    
    func getCurrentId() -> Int {
        return self.currentId
    }
    
    func getNumberOfUser() -> Int {
        return self.searchData.count
    }
    
    func getUserByIndex(index: Int) -> UserDetail? {
        return self.searchData[index]
    }
    
    // MARK: - Handler Methods
    // fetch user
    func fetchUserDetail() {
        self.db.collection("userDetail").getDocuments() { querySnapshot, err in
            guard let querySnapshot = querySnapshot else { return }
            if err != nil { return }
            querySnapshot.documents.forEach { document in
                let userDetail = document.data() as [String: Any]
                let value = UserDetail(userDetail: userDetail)
                if value.id != self.currentId {
                    self.userDetails.append(value)
                    self.searchData = self.userDetails
                    self.view?.didGetUser()
                }
            }
        }
    }
    
    // fill data after search
    func filterData(text: String) {
        self.searchData = text.isEmpty ? userDetails : userDetails.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
}
