import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Serve the app on 0.0.0.0 to make it accessible on other computers in the same network.
    if env == .development {
        services.register(Server.self) { container -> NIOServer in
            var serverConfig = try container.make() as NIOServerConfig
            serverConfig.port = 8080
            serverConfig.hostname = "0.0.0.0"
            let server = NIOServer(config: serverConfig, container: container)
            return server
        }
    }
    
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Config PostgreSQL
    var databases = DatabasesConfig()
    
    // Environment Variables that default to local settings
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "vapor"
    let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"
    
    let databaseConfig = PostgreSQLDatabaseConfig(hostname: hostname, username: username, database: databaseName, password: password)
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Acronym.self, database: .psql)
    services.register(migrations)

}
