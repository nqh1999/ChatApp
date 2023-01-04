//
//  Service.swift
//  ChatApp
//
//  Created by BeeTech on 03/01/2023.
//

import Firebase
import FirebaseAuth
import RxSwift

class Service {

    // MARK: - Properties
    static let shared = Service()
    private var db = Firestore.firestore()
    private var storage = Storage.storage().reference()
    
    func fetchUsers() -> Observable<[User]> {
        return Observable.create { observer in
            let listener = self.db.collection(Constant.DB_USER).addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    observer.onError(error!)
                    return
                }
                let users = snapshot.documents.map { User(user: $0.data())}
                observer.onNext(users)
            }
            
            return Disposables.create {
                listener.remove()
            }
        }
    }
    
    func fetchAvtUrl(img: UIImage) -> Observable<String> {
        return Observable.create { [weak self] observer in
            let img = img.jpegData(compressionQuality: 0.5)!
            let keyImg = NSUUID().uuidString
            let imgFolder = self?.storage.child(Constant.DB_IMAGE_AVATAR).child(keyImg)
            self?.storage.child(Constant.DB_IMAGE_AVATAR).child(keyImg).putData(img) { _ , err in
                guard err == nil else { return }
                imgFolder?.downloadURL { url, err in
                    guard err == nil, let url = url else { return }
                    observer.onNext(url.absoluteString)
                }
            }
            return Disposables.create()
        }
    }
    
    func register(_ name: String,_ username: String,_ password: String,_ imgUrl: String) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            self?.db.collection(Constant.DB_USER).document(username).setData([
                "id": username,
                "username": username,
                "password": password,
                "name": name,
                "imgUrl": imgUrl
            ]) { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func setStateIsActive(_ id: String, _ isActive: Bool) {
        self.db.collection(Constant.DB_USER).document(id).updateData(["isActive" : isActive])
    }
}
