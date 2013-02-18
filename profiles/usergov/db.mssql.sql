USE [master]
GO
:on error exit
GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL
    AND DATABASEPROPERTYEX(N'$(DatabaseName)','Status') <> N'ONLINE')
BEGIN
    RAISERROR(N'The state of the target database, %s, is not set to ONLINE. To deploy to this database, its state must be set to ONLINE.', 16, 127,N'$(DatabaseName)') WITH NOWAIT
    RETURN
END
GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

--if exists (select * from sys.server_principals where name = N'$(LoginName)')
--begin
--	drop login [$(LoginName)];
--end

declare
	@DbPath		nvarchar(max),
	@SqlCmd		nvarchar(max) = '';
	
if isnull(N'$(DatabasePath)', N'') != N''
begin
	set @DbPath = N'$(DatabasePath)';
end
else
begin
	select @DbPath = substring(physical_name, 1, charindex(name, physical_name) - 2) from master.sys.database_files where name = 'master'
end	
	

set @SqlCmd = 
	'create database [$(DatabaseName)]'
	+ ' on primary (name = N''$(DatabaseName)'', filename = N''' + @DbPath + '\$(DatabaseName).mdf'', SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )'
	+ ' log on (name = N''$(DatabaseName)_log'', filename = N''' + @DbPath + '\$(DatabaseName).log'', SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)';
exec sp_executesql @SqlCmd;
go

ALTER DATABASE [$(DatabaseName)] SET COMPATIBILITY_LEVEL = 100
GO

if NOT exists (select * from sys.server_principals where name = N'$(LoginName)')
	CREATE LOGIN [$(LoginName)] WITH PASSWORD = '$(LoginPassword)',DEFAULT_DATABASE = [$(DatabaseName)];
GO


IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [$(DatabaseName)].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [$(DatabaseName)] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET ARITHABORT OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [$(DatabaseName)] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [$(DatabaseName)] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [$(DatabaseName)] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET  DISABLE_BROKER 
GO

ALTER DATABASE [$(DatabaseName)] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [$(DatabaseName)] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [$(DatabaseName)] SET  READ_WRITE 
GO

ALTER DATABASE [$(DatabaseName)] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [$(DatabaseName)] SET  MULTI_USER 
GO

ALTER DATABASE [$(DatabaseName)] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [$(DatabaseName)] SET DB_CHAINING OFF 
GO

USE [$(DatabaseName)]

--IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'$(LoginName)')
--DROP USER [workspace_admin]
--GO

IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'$(LoginName)')
	CREATE USER workspace_admin FOR LOGIN $(LoginName)
GO

EXEC sp_addrolemember 'db_owner', workspace_admin
GO