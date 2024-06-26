--USUARIO
-- USER SQL
CREATE USER "C##DANIEL" IDENTIFIED BY "oracle"  
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS
ALTER USER "C##DANIEL" QUOTA UNLIMITED ON "SYSTEM";
ALTER USER "C##DANIEL" QUOTA UNLIMITED ON "SYSAUX";
ALTER USER "C##DANIEL" QUOTA UNLIMITED ON "USERS";

-- ROLES

-- SYSTEM PRIVILEGES
GRANT CREATE JOB TO "C##DANIEL" ;
GRANT CREATE TRIGGER TO "C##DANIEL" ;
GRANT CREATE MATERIALIZED VIEW TO "C##DANIEL" ;
GRANT CREATE VIEW TO "C##DANIEL" ;
GRANT CREATE SESSION TO "C##DANIEL" ;
GRANT CREATE EXTERNAL JOB TO "C##DANIEL" ;
GRANT CREATE TABLE TO "C##DANIEL" ;
GRANT CREATE TYPE TO "C##DANIEL" ;
GRANT CREATE PUBLIC DATABASE LINK TO "C##DANIEL" ;
GRANT CREATE SEQUENCE TO "C##DANIEL" ;
GRANT CREATE DATABASE LINK TO "C##DANIEL" ;
GRANT CREATE PROCEDURE TO "C##DANIEL" ;