public struct LocalPostgres {
  public let superuser: String
  public let superuserPassword: String
  public let role: String
  public let password: String
  public let databaseStem: String
  public let databaseTails: [String]

  public init(superuser: String = "postgres",
              superuserPassword: String = "postgres",
              role: String,
              password: String,
              databaseStem: String,
              databaseTails: [String] = ["dev", "test"]) {
    self.superuser = superuser
    self.superuserPassword = superuserPassword
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
      try ShLocalPostgres.dropDB(superuser: self.superuser,
                                 superuserPassword: self.superuserPassword,
                                 name: name)
    }
    
    try ShLocalPostgres.destroy(superuser: self.superuser,
                                superuserPassword: self.superuserPassword,
                                role: self.role)
  }
  
  public func createAll() throws {
    try ShLocalPostgres.createRole(superuser: self.superuser,
                                   superuserPassword: self.superuserPassword,
                                   name: self.role,
                                   password: self.password)
    
    for name in self.databaseNames {
      try ShLocalPostgres.createDB(superuser: self.superuser,
                                   superuserPassword: self.superuserPassword,
                                   name: name, owner: self.role)
      try ShLocalPostgres.ensureDBConnection(name: name,
                                             owner: self.role,
                                             password: self.password)
    }
  }
}
