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
    private weak var view: ListProtocol?
    private var db = Firestore.firestore()
    private var userDetails = [UserDetail]()
    private var currentId: Int = 0
    private var searchData = [UserDetail]()
    init(view: ListProtocol) {
        self.view = view
    }
    
    func fetchUserDetail() {
        db.collection("userDetail").getDocuments() { querySnapshot, err in
            if err != nil {
                print("err")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    let dict = document.data() as [String: Any]
                    let value = UserDetail(dict: dict)
                    if value.id != self.currentId {
                        self.userDetails.append(value)
                        self.searchData = self.userDetails
                        self.view?.didGetUser()
                    }
                }
            }
        }
    }
    
    func setCurrentId(id: Int) {
        self.currentId = id
    }
    
    func getCurrentId() -> Int {
        return currentId
    }
    
    func getNumberOfFriend() -> Int {
        return searchData.count
    }
    
    func getFriendByIndex(index: Int) -> UserDetail? {
        return searchData[index]
    }
    
    func filterData(text: String) {
        self.searchData = text.isEmpty ? userDetails : userDetails.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
}
