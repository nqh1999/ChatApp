//
//  ToastUlti.swift
//  ChatApp
//
//  Created by Nguyen Quang Huy on 12/06/2023.
//

import Foundation
import Toaster

struct ToastUtil {
    static func show(_ msg: String) {
        if msg != "" {
            ToastCenter.default.cancelAll()
            Toast(text: msg).show()
        }
    }
}
