import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // MARK: Controllers
    let acronymsController = AcronymsController()
    
    try router.register(collection: acronymsController)
    try router.register(collection: UsersController())
}
