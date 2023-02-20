import Sh

public enum ShLocalPostgres {
  
  public static func dropDB(name: String) throws {
    try sh(.terminal, "dropdb -U postgres --if-exists \(name)")
  }

  public static func createDB(name: String, owner: String) throws {
    try sh(.terminal, "createdb -U postgres --owner=\(owner) \(name)")
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

  public static func createRole(name: String, password: String) throws {
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
              -U postgres \
              --command="$CREATE_USER_SCRIPT" \
              --command="\du" \
              postgres
            """#,
           environment: ["CREATE_USER_SCRIPT": createUserScript])
  }
  
  public static func destroy(role: String) throws {
    let destroyUserScript = #"""
      psql -U postgres \
        --command="DROP USER IF EXISTS $SH_LOCAL_POSTGRES_ROLE" \
        --command="\du" \
        postgres
    """#
    try sh(.terminal, destroyUserScript,
           environment: ["SH_LOCAL_POSTGRES_ROLE": role])
  }
}
