
-- sqlserver_init/01_create_database_and_schemas.sql
-- Script d'initialisation de la base de données DataWarehouse et des schémas.
-- Utilisé par Docker Compose pour configurer SQL Server au démarrage.

-- Créer la base de données
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = '\$(MSSQL_DB_NAME)')
BEGIN
    CREATE DATABASE $(MSSQL_DB_NAME);
END;
GO

USE $(MSSQL_DB_NAME);
GO

-- Créer les schémas Medallion
IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze;');
END;
GO

IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver;');
END;
GO

IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold;');
END;
GO

-- Créer les schémas opérationnels
IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'dbt_temp')
BEGIN
    EXEC('CREATE SCHEMA dbt_temp;'); -- Schéma temporaire pour dbt
END;
GO

IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'tests')
BEGIN
    EXEC('CREATE SCHEMA tests;');
END;
GO

IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'utils')
BEGIN
    EXEC('CREATE SCHEMA utils;');
END;
GO

IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'orchestration')
BEGIN
    EXEC('CREATE SCHEMA orchestration;');
END;
GO

-- Créer l'utilisateur dbt et lui donner les permissions
-- C'est l'utilisateur que dbt utilisera pour se connecter à la base de données.
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = '\$(MSSQL_USER)')
BEGIN
    CREATE USER \$(MSSQL_USER) WITH PASSWORD = '\$(MSSQL_PASSWORD)';
END;
GO

-- Donner les permissions nécessaires
-- Pour simplifier le démarrage, nous allons donner le rôle db_owner.
-- En production, des permissions plus granulaires seraient configurées.
ALTER ROLE db_owner ADD MEMBER \$(MSSQL_USER);
GO

-- Créer la table de logs ETL (dbt n'utilisera pas ça directement, mais c'est pour votre suivi global)
USE \$(MSSQL_DB_NAME);
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'etl_log' AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    CREATE TABLE dbo.etl_log (
        id                INT IDENTITY(1,1) PRIMARY KEY,
        run_id            UNIQUEIDENTIFIER DEFAULT NEWID(),
        layer             NVARCHAR(50),      -- bronze / silver / gold
        schema_name       NVARCHAR(100),
        table_name        NVARCHAR(200),
        procedure_name    NVARCHAR(200),     -- Nom de la procédure ou de l'opération dbt
        file_path         NVARCHAR(500),     -- (Optionnel)
        status            NVARCHAR(20),      -- Success / Failed / Warning / Skipped
        rows_loaded       INT NULL,
        start_time        DATETIME NOT NULL,
        end_time          DATETIME NULL,
        duration_sec      AS DATEDIFF(SECOND, start_time, end_time) PERSISTED,
        message           NVARCHAR(MAX),
        created_at        DATETIME DEFAULT GETDATE()
    );
END;
GO
