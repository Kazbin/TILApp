import Vapor
import FluentPostgreSQL

final class Category: Content, PostgreSQLModel, Migration, Parameter{
    var id: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}


extension Category {
    var acronyms: Siblings<Category, Acronym, AcronymCategoryPivot> {
        return siblings()
    }
}
