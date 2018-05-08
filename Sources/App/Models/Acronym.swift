import Vapor
import FluentPostgreSQL

final class Acronym: Content, PostgreSQLModel, Migration, Parameter {
    var id: Int?
    var short: String
    var long: String
    
    init(short: String, long: String) {
        self.short = short
        self.long = long
    }
}
