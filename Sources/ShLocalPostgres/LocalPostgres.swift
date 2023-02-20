public struct LocalPostgres {
  public let role: String
  public let password: String
  public let databaseStem: String
  public let databaseTails: [String]

  public init(role: String,
              password: String,
              databaseStem: String,
              databaseTails: [String] = ["dev", "test"]) {
    self.role = role
    self.password = password
    self.databaseStem = databaseStem
    self.databaseTails = databaseTails
  }
  
  public var databaseNames: [String] {
    self.databaseTails.map { tail in
      "\(self.databaseStem)_\(tail)"
    }
  }
  
  public func destroyAll() throws {
    for name in self.databaseNames {
      try ShLocalPostgres.dropDB(name: name)
    }
    
    try ShLocalPostgres.destroy(role: self.role)
  }
  
  public func createAll() throws {
    try ShLocalPostgres.createRole(name: self.role, password: self.password)
    
    for name in self.databaseNames {
      try ShLocalPostgres.createDB(name: name, owner: self.role)
      try ShLocalPostgres.ensureDBConnection(name: name,
                                             owner: self.role,
                                             password: self.password)
    }
  }
}
