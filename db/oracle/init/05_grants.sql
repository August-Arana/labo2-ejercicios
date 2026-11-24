-- Executed as SYS on first start. Mirrors the course's Crea_alumno.sql grants
-- (connect, resource, create procedure, create trigger) plus views/sequences.
ALTER SESSION SET CONTAINER = FREEPDB1;
GRANT CONNECT, RESOURCE, CREATE PROCEDURE, CREATE TRIGGER,
      CREATE VIEW, CREATE SEQUENCE, CREATE SYNONYM TO labo;
ALTER USER labo QUOTA UNLIMITED ON users;
