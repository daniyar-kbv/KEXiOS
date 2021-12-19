//
//  NotificationsResponse.swift
//  SalamBro
//
//  Created by Dan on 7/17/21.
//

import Foundation

struct FCMTokenSaveResponse: Decodable {
    let data: FCMTokenSaveDTO?
    let error: ErrorResponse?
}

struct FCMTokenUpdateResponse: Decodable {
    let data: FCMTokenUpdateDTO?
    let error: ErrorResponse?
}
