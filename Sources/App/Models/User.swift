//
//  User.swift
//  App
//
//  Created by Malte Klaumann on 08.05.18.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class User: Content, PostgreSQLUUIDModel, Migration, Parameter{
    var id: UUID?
    var name: String
    var username: String
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}

extension User {
    var acronyms: Children<User, Acronym> {
        return children(\.userID)
    }
}
