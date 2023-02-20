@testable import ShLocalPostgres
import Foundation
import XCTest

final class ShLocalPostgresTests: XCTestCase {
  
  let config = LocalPostgres(
    superuser: "postgres",
    superuserPassword: "postgres",
    role: "tomato",
    password: "fresh_password",
    databaseStem: "supermarket",
    databaseTails: ["development", "testing"])
  
  func testCreateAndDestroy() throws {
    
    let beforeStatus = try ShLocalPostgres.currentStatus()
    XCTAssertFalse(beforeStatus.contains("tomato"))
    
    try config.createAll()
    
    let afterCreateStatus = try ShLocalPostgres.currentStatus()
    XCTAssertTrue(afterCreateStatus.contains("tomato"))
    
    XCTAssertNoThrow(try ShLocalPostgres.ensureDBConnection(
      name: "supermarket_development",
      owner: "tomato",
      password: "fresh_password"))
    
    try config.destroyAll()
    
    let afterDestroyStatus = try ShLocalPostgres.currentStatus()
    XCTAssertFalse(afterDestroyStatus.contains("tomato"))
    
    XCTAssertThrowsError(try ShLocalPostgres.ensureDBConnection(
      name: "supermarket_development",
      owner: "tomato",
      password: "fresh_password"))
  }
}
