import Vapor
import FluentSQLite

final class Acronym: Content, SQLiteModel, Migration {
    var id: Int?
    var short: String
    var long: String
    
    init(short: String, long: String) {
        self.short = short
        self.long = long
    }
}

/// extension Acronym: SQLiteModel {}
