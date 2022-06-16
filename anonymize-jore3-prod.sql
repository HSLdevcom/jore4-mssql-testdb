
USE [master] RESTORE DATABASE [jore3]
FROM DISK = N'/data/input-file.bak'
WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 10,
MOVE 'joretuot' TO '/var/opt/mssql/data/joretuot.mdf',
MOVE 'joretuot_log' TO '/var/opt/mssql/data/joretuot_log.ldf';

DROP TABLE jore3.dbo.jr_kayttaja;

DROP TABLE jore3.dbo.jr_kayttajan_viestit;

DROP TABLE jore3.dbo.jrs_kayttaja;

DROP TABLE jore3.dbo.jr_liikennoitsija;

USE [master] BACKUP DATABASE [jore3]
TO DISK = N'/data/output-file.bak'
WITH COMPRESSION;

