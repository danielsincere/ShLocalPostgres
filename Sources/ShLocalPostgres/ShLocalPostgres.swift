import Sh

public enum ShLocalPostgres {
  
  static func currentStatus(superuser: String = "postgres",
                            superuserPassword: String = "") throws -> String {
    try sh(#"psql -U $SH_LOCAL_POSTGRES_SUPERUSER --command="\du" postgres"#,
           environment: [
            "SH_LOCAL_POSTGRES_SUPERUSER": superuser,
            "PGPASSWORD": superuserPassword
           ])!
  }
  
  public static func dropDB(superuser: String = "postgres",
                            superuserPassword: String = "",
                            name: String) throws {
    try sh(.terminal,
           "dropdb -U $SH_LOCAL_POSTGRES_SUPERUSER --if-exists \(name)",
           environment: [
            "SH_LOCAL_POSTGRES_SUPERUSER": superuser,
            "PGPASSWORD": superuserPassword
           ])
  }

  public static func createDB(superuser: String = "postgres",
                              superuserPassword: String = "",
                              name: String, owner: String) throws {
    try sh(.terminal,
           "createdb -U $SH_LOCAL_POSTGRES_SUPERUSER --owner=\(owner) \(name)",
           environment: [
            "SH_LOCAL_POSTGRES_SUPERUSER": superuser,
            "PGPASSWORD": superuserPassword
           ])
  }

  public static func ensureDBConnection(name: String, owner: String, password: String) throws {
    try sh(.terminal,
           """
           psql \
             --username=\(owner) \
             --host=localhost \(name) \
             -c "select version()"
           """,
           environment: ["PGPASSWORD": password])
  }

  public static func createRole(superuser: String = "postgres",
                                superuserPassword: String = "",
                                name: String, password: String) throws {
    let createUserScript =
      """
      DO
      $do$
      BEGIN
        IF EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '\(name)') THEN
          RAISE NOTICE 'User "\(name)" already exists. Skipping.';
        ELSE
          CREATE ROLE \(name) LOGIN PASSWORD '\(password)';
        END IF;
      END
      $do$;
      """

    try sh(.terminal,
            #"""
            psql \
              -U $SH_LOCAL_POSTGRES_SUPERUSER \
              --command="$CREATE_USER_SCRIPT" \
              --command="\du" \
              postgres
            """#,
           environment: [
            "CREATE_USER_SCRIPT": createUserScript,
            "SH_LOCAL_POSTGRES_SUPERUSER": superuser,
            "PGPASSWORD": superuserPassword
           ])
  }
  
  public static func destroy(superuser: String = "postgres",
                             superuserPassword: String = "",
                             role: String) throws {
    let destroyUserScript = #"""
      psql -U $SH_LOCAL_POSTGRES_SUPERUSER \
        --command="DROP USER IF EXISTS $SH_LOCAL_POSTGRES_ROLE" \
        --command="\du" \
        postgres
    """#
    try sh(.terminal, destroyUserScript,
           environment: [
            "SH_LOCAL_POSTGRES_ROLE": role,
            "SH_LOCAL_POSTGRES_SUPERUSER": superuser,
            "PGPASSWORD": superuserPassword
           ])
  }
}
