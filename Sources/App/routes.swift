import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // list all
    router.get("api", "acronyms") { req -> Future<[Acronym]> in
        return Acronym.query(on: req).all()
    }
    // get one by id
    router.get("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        return try req.parameters.next(Acronym.self)
    }
    // create new
    router.post("api","acronyms") { req -> Future<Acronym> in
        return try req.content.decode(Acronym.self).flatMap(to: Acronym.self) { acronym in
            return acronym.save(on: req)
        }
    }
    // Update specifiv Acronym
    router.put("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        return try flatMap(to: Acronym.self, req.parameters.next(Acronym.self), req.content.decode(Acronym.self)) { acronym, updatedAcronym in
            acronym.short = updatedAcronym.short
            acronym.long = updatedAcronym.long
            
            return acronym.save(on: req)
        }
    }
    // Delete ACRONYM
    router.delete("api","acronyms", Acronym.parameter) { req -> Future<HTTPStatus> in
        return try req.parameters.next(Acronym.self).flatMap(to: HTTPStatus.self) { acronym in
            return acronym.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
    // Search
    router.get("api","acronyms","search") { req -> Future<[Acronym]> in
        guard let searchTerm = req.query[String.self, at: "q"] else {
            throw Abort(.badRequest)
        }
        return try Acronym.query(on: req).group(.or) { or in
            try or.filter(\.short == searchTerm)
            try or.filter(\.short == searchTerm.uppercased())
            try or.filter(\.short == searchTerm.lowercased())
            try or.filter(\.long == searchTerm)
        }.all ()
    }
    // Others
    router.get("api","acronyms","first") { req -> Future<Acronym> in
        return Acronym.query(on: req).first().map(to: Acronym.self) { acronym in
            guard let acronym = acronym else {
                throw Abort(.notFound)
            }
            return acronym
        }
    }
    router.get("api", "acronyms","sorted") { req -> Future<[Acronym]> in
        return try Acronym.query(on: req).sort(\.short, QuerySortDirection.ascending).all()
    }
}
