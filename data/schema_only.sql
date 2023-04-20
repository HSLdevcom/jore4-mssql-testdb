CREATE DATABASE jore3testdb;
GO
-- Jore uses Microsoft SQL Server 2012 (SP4) (KB4018073) - 11.0.7001.0 (X64),
-- so let's set the  compatibility for SQL Server 2012 (11.x) => 110
-- See: https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql-compatibility-level
ALTER DATABASE jore3testdb SET COMPATIBILITY_LEVEL = 110
GO
USE jore3testdb;
GO
--
-- Create jr_solmu
--
CREATE TABLE jr_solmu
(
    soltunnus    CHAR(7) NOT NULL,
    soltyyppi    CHAR(1) NOT NULL,
    sollistunnus VARCHAR(4),
    solmapiste   VARCHAR(1),
    solx         NUMERIC(7, 0),
    soly         NUMERIC(7, 0),
    solmx        NUMERIC(8, 6),
    solmy        NUMERIC(8, 6),
    solkuka      VARCHAR(20),
    solviimpvm   DATETIME2(3),
    solstx       NUMERIC(7, 0),
    solsty       NUMERIC(7, 0),
    solx3        NUMERIC(7, 0),
    soly3        NUMERIC(7, 0),
    solstx3      NUMERIC(7, 0),
    solsty3      NUMERIC(7, 0),
    solstmx      NUMERIC(8, 6),
    solstmy      NUMERIC(8, 6),
    solkirjain   VARCHAR(2),
    solhis       VARCHAR(1),
    solox        NUMERIC(7, 0),
    soloy        NUMERIC(7, 0),
    solomx       NUMERIC(8, 6),
    solomy       NUMERIC(8, 6),
    solotapa     VARCHAR(1),
    mittpvm      DATETIME2(3),
    mkjmx        NUMERIC(8, 6),
    mkjmy        NUMERIC(8, 6)
)
GO
CREATE UNIQUE CLUSTERED INDEX jr_solmu_cind ON jr_solmu (soltunnus)
GO
--
-- Create jr_linkki
--
CREATE TABLE jr_linkki
(
    lnkverkko     CHAR(1) NOT NULL,
    lnkalkusolmu  CHAR(7) NOT NULL,
    lnkloppusolmu CHAR(7) NOT NULL,
    lnkmitpituus  INT,
    lnkpituus     INT,
    lnkstid       INT,
    katkunta      CHAR(3),
    katnimi       VARCHAR(40),
    kaoosnro      SMALLINT,
    lnksuunta     CHAR(1),
    lnkosnro      SMALLINT,
    lnkostrk      VARCHAR(1),
    lnkkuka       VARCHAR(20),
    lnkviimpvm    DATETIME2(3),
    lnkhis        VARCHAR(1)
)
GO
CREATE UNIQUE CLUSTERED INDEX jr_linkki_cind ON jr_linkki (lnkverkko, lnkalkusolmu, lnkloppusolmu)
GO
--
-- Create jr_piste
--
CREATE TABLE jr_piste
(
    lnkverkko     CHAR(1) NOT NULL,
    lnkalkusolmu  CHAR(7) NOT NULL,
    lnkloppusolmu CHAR(7) NOT NULL,
    pisjarjnro    INT     NOT NULL,
    pisid         INT     NOT NULL,
    pisx          NUMERIC(7, 0),
    pisy          NUMERIC(7, 0),
    pismx         NUMERIC(8, 6),
    pismy         NUMERIC(8, 6),
    piskuka       VARCHAR(20),
    pisviimpvm    DATETIME2(3)
)
GO
CREATE CLUSTERED INDEX jr_piste_cind ON jr_piste (lnkverkko, lnkalkusolmu, lnkloppusolmu, pisjarjnro)
GO
CREATE UNIQUE INDEX jr_piste_uind ON jr_piste (pisid)
GO
--
-- Create jr_linja
--
CREATE TABLE jr_linja
(
    lintunnus      VARCHAR(6) NOT NULL,
    linperusreitti VARCHAR(6),
    linvoimast     DATETIME2(3),
    linvoimviimpvm DATETIME2(3),
    linjoukkollaji VARCHAR(2),
    lintilorg      VARCHAR(3),
    linverkko      VARCHAR(1),
    linryhma       VARCHAR(3),
    linkuka        VARCHAR(20),
    linviimpvm     DATETIME2(3),
    linjlkohde     VARCHAR(6),
    id             VARCHAR(4),
    vaihtoaika     INT,
    linkorvtyyppi  VARCHAR(2),
    puhelinnumero  VARCHAR(20)
)
GO
CREATE UNIQUE CLUSTERED INDEX jr_linja_cind ON jr_linja (lintunnus)
GO
--
-- Create jr_linjannimet
--
CREATE TABLE jr_linjannimet
(
    lintunnus   VARCHAR(6)   NOT NULL,
    linalkupvm  DATETIME2(3) NOT NULL,
    linloppupvm DATETIME2(3),
    linnimi     VARCHAR(60)  NOT NULL,
    linnimilyh  VARCHAR(20),
    linnimir    VARCHAR(60),
    linnimilyhr VARCHAR(20),
    linlahtop1  VARCHAR(30),
    linlahtop1r VARCHAR(30),
    linlahtop2  VARCHAR(30),
    linlahtop2r VARCHAR(30),
    linkuka     VARCHAR(20),
    linviimpvm  DATETIME2(3),
    linlijpvm   DATETIME2(3)
)
GO
CREATE UNIQUE CLUSTERED INDEX jr_linjannimet_cind ON jr_linjannimet (lintunnus, linalkupvm)
GO
CREATE INDEX jr_linjannimet_mind1 ON jr_linjannimet (linnimi, linalkupvm)
GO
CREATE TABLE jr_reitti
(
    reitunnus   VARCHAR(6) NOT NULL,
    reinimi     VARCHAR(60),
    reinimilyh  VARCHAR(20),
    reinimir    VARCHAR(60),
    reinimilyhr VARCHAR(20),
    lintunnus   VARCHAR(6) NOT NULL,
    reikuka     VARCHAR(20),
    reiviimpvm  DATETIME2(3)
)
GO
CREATE UNIQUE CLUSTERED INDEX jr_reitti_cind ON jr_reitti (reitunnus)
GO
CREATE TABLE jr_reitinsuunta
(
    reitunnus      VARCHAR(6)   NOT NULL,
    suusuunta      CHAR(1)      NOT NULL,
    suuvoimast     DATETIME2(3) NOT NULL,
    suuvoimviimpvm DATETIME2(3) NOT NULL,
    suulahpaik     VARCHAR(20),
    suulahpaikr    VARCHAR(20),
    suupaapaik     VARCHAR(20),
    suupaapaikr    VARCHAR(20),
    suuensppy      CHAR(7),
    suupituus      INT,
    suukuka        VARCHAR(20),
    suuviimpvm     DATETIME2(3),
    suunimilyh     VARCHAR(20),
    suunimilyhr    VARCHAR(20),
    suunimi        VARCHAR(60),
    suunimir       VARCHAR(60),
    suuhis         VARCHAR(1),
    pyssade        INT,
    kirjaan        VARCHAR(1),
    nettiin        VARCHAR(1),
    kirjasarake    INT,
    nettisarake    INT,
    poikkeusreitti CHAR(1)
)
GO
CREATE UNIQUE CLUSTERED INDEX jr_reitinsuunta_cind ON jr_reitinsuunta (reitunnus, suusuunta, suuvoimast)
GO

CREATE TABLE jr_reitinlinkki
(
    reitunnus      VARCHAR(6)   NOT NULL,
    suusuunta      CHAR(1)      NOT NULL,
    suuvoimast     DATETIME2(3) NOT NULL,
    reljarjnro     SMALLINT     NOT NULL,
    relid          INT          NOT NULL,
    relmatkaik     VARCHAR(1),
    relohaikpys    VARCHAR(1),
    relvpistaikpys VARCHAR(1),
    relpysakki     VARCHAR(1),
    lnkverkko      CHAR(1)      NOT NULL,
    lnkalkusolmu   CHAR(7)      NOT NULL,
    lnkloppusolmu  CHAR(7)      NOT NULL,
    relkuka        CHAR(20),
    relviimpvm     DATETIME2(3),
    pyssade        INT,
    ajantaspys     VARCHAR(1),
    liityntapys    VARCHAR(1),
    paikka         VARCHAR(1),
    kirjaan        VARCHAR(1),
    nettiin        VARCHAR(1),
    kirjasarake    INT,
    nettisarake    INT
)
GO
CREATE CLUSTERED INDEX jr_reitinlinkki_cind ON jr_reitinlinkki (reitunnus, suusuunta, suuvoimast, reljarjnro)
GO
CREATE INDEX jr_reitinlinkki_mind1 ON jr_reitinlinkki (lnkalkusolmu)
GO
CREATE UNIQUE INDEX jr_reitinlinkki_uind ON jr_reitinlinkki (relid)
GO

CREATE TABLE jr_pysakki
(
    soltunnus      CHAR(7)       NOT NULL,
    pyskunta       CHAR(3)       NOT NULL,
    pysnimi        VARCHAR(20)   NOT NULL,
    pysnimir       VARCHAR(20),
    pyspaikannimi  VARCHAR(20),
    pyspaikannimir VARCHAR(20),
    pysosoite      VARCHAR(20),
    pysosoiter     VARCHAR(20),
    pysvaihtopys   VARCHAR(1),
    pyskuka        VARCHAR(20),
    pysviimpvm     DATETIME2(3),
    pyslaituri     VARCHAR(15),
    pyskatos       VARCHAR(2),
    pystyyppi      VARCHAR(2),
    pyssade        INT,
    pyssuunta      VARCHAR(20),
    paitunnus      VARCHAR(6),
    terminaali     VARCHAR(10),
    kutsuplus      VARCHAR(1),
    kutsuplusvyo   VARCHAR(2),
    kulkusuunta    VARCHAR(20),
    kutsuplusprior VARCHAR(2),
    id             INT,
    pysalueid      VARCHAR(6),
    tariffi        VARCHAR(3),
    elynumero      VARCHAR(10),
    pysnimipitka   VARCHAR(60),
    pysnimipitkar  VARCHAR(60),
    nimiviimpvm    DATETIME2(3),
    vyohyke        VARCHAR(6),
    postinro       VARCHAR(5)
)
GO
CREATE UNIQUE CLUSTERED INDEX jr_pysakki_cind ON jr_pysakki (soltunnus)
GO

CREATE TABLE jr_via_nimet
(
    relid           INT          NOT NULL,
    viasuomi        VARCHAR(30),
    viaruotsi       VARCHAR(30),
    maaranpaa1      VARCHAR(30),
    maaranpaa1r     VARCHAR(30),
    maaranpaa2      VARCHAR(30),
    maaranpaa2r     VARCHAR(30)
)

GO
CREATE UNIQUE CLUSTERED INDEX jr_via_nimet_cind ON jr_via_nimet (relid)
GO

CREATE TABLE jr_linja_vaatimus (
	lintunnus varchar(12) COLLATE Finnish_Swedish_CS_AS NOT NULL,
	kookoodi varchar(20) COLLATE Finnish_Swedish_CS_AS NOT NULL,
	kooselite varchar(100) COLLATE Finnish_Swedish_CS_AS NOT NULL
)
GO
