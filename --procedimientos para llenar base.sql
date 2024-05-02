--procedimientos para llenar base

CREATE OR REPLACE PROCEDURE LlenarTablaCaracteristicas AS
BEGIN
    FOR i IN 1..100 LOOP
        BEGIN
            INSERT INTO TBL_CARACTERISTICA (CaracteristicaID, Nombre)
            VALUES (i, 'Caracteristica_' || i);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    LlenarTablaCaracteristicaS;
END;
/



CREATE OR REPLACE PROCEDURE P_Llenar_Tabla_Telefonos AS
BEGIN
    FOR i IN 1..100 LOOP
        BEGIN
            INSERT INTO TBL_TELEFONO (TelefonoID, Numero)
            VALUES (i, TRUNC(DBMS_RANDOM.VALUE(1000000000, 9999999999)));
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    P_Llenar_Tabla_Telefonos;
END;
/



CREATE OR REPLACE PROCEDURE LlenarTablaEmpresas AS
BEGIN
    FOR i IN 1..100 LOOP
        BEGIN
            INSERT INTO TBL_EMPRESA (EmpresaID, Nombre, RTN, Email, CasaMatriz, Telefono)
            VALUES (i, 'Empresa_' || i, i*1000000, 'empresa_' || i || '@example.com', 'Dirección Casa Matriz_' || i, i);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    LlenarTablaEmpresas;
END;
/


CREATE OR REPLACE PROCEDURE P_Llenar_Tabla_Sucursales AS
BEGIN
    FOR i IN 1..100 LOOP
        BEGIN
            INSERT INTO TBL_SUCURSAL (SucursalID, Nombre, Telefono, CodigoSAR)
            VALUES (i, 'Sucursal_' || i, i*1000000000, i);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    P_Llenar_Tabla_Sucursales;
END;
/



CREATE OR REPLACE PROCEDURE P_Llenar_Tabla_Paises AS
BEGIN
    FOR i IN 1..100 LOOP
        BEGIN
            INSERT INTO TBL_PAISES (PaisID, Nombre)
            VALUES (i, 'Pais_' || i);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    P_Llenar_Tabla_Paises;
END;
/



CREATE OR REPLACE PROCEDURE P_Llenar_Tabla_Estados_Provincias AS
BEGIN
    DECLARE
        v_PaisID INT;
    BEGIN
        FOR i IN 1..100 LOOP
            v_PaisID := TRUNC((i - 1) / 10) + 1; -- Asigna cada estado/provincia a uno de los 10 países ya insertados
            INSERT INTO TBL_ESTADOS_PROVINCIAS (EstadoProvinciaID, Nombre, PaisID)
            VALUES (i, 'EstadoProvincia_' || i, v_PaisID);
        END LOOP;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            NULL; -- Ignorar intentos de inserción de claves duplicadas
    END;
END;
/

BEGIN
    P_Llenar_Tabla_Estados_Provincias;
END;
/


CREATE OR REPLACE PROCEDURE P_Llenar_Tabla_Estados_Provincias AS
BEGIN
    FOR i IN 1..100 LOOP
        BEGIN
            INSERT INTO TBL_ESTADOS_PROVINCIAS (EstadoProvinciaID, Nombre, PaisID)
            VALUES (i, 'EstadoProvincia_' || i, MOD(i,10) + 1); -- La función MOD se utiliza para asignar aleatoriamente un ID de país entre 1 y 10
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    P_Llenar_Tabla_Estados_Provincias;
END;
/


CREATE OR REPLACE PROCEDURE P_Llenar_Tabla_Ciudades AS
BEGIN
    FOR i IN 1..1000 LOOP
        BEGIN
            INSERT INTO TBL_CIUDADES (CiudadID, Nombre, EstadoProvinciaID)
            VALUES (i, 'Ciudad_' || i, MOD(i,100) + 1); -- Asigna cada ciudad a uno de los 100 estados o provincias existentes
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    P_Llenar_Tabla_Ciudades;
END;
/