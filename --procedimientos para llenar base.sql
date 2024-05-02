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


CREATE OR REPLACE PROCEDURE P_Llenar_Tabla_Codigos_Postales AS
BEGIN
    FOR i IN 1..1000 LOOP
        BEGIN
            INSERT INTO TBL_CODIGOS_POSTALES (CodigoPostalID, CodigoPostal, CiudadID)
            VALUES (i, 10000 + i, MOD(i,1000) + 1); -- Asigna cada código postal a una de las 1000 ciudades existentes
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    P_Llenar_Tabla_Codigos_Postales;
END;
/


CREATE OR REPLACE PROCEDURE P_Llenar_Tabla_Direcciones AS
BEGIN
    FOR i IN 1..1000 LOOP
        BEGIN
            INSERT INTO TBL_DIRECCIONES (DireccionID, NUMERO_CASA, CiudadID)
            VALUES (i, 'Direccion_' || i, MOD(i,100) + 1); -- Asigna cada dirección a una de las 100 ciudades existentes
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    P_Llenar_Tabla_Direcciones;
END;
/


CREATE OR REPLACE PROCEDURE P_Llenar_Tabla_Persona AS
BEGIN
    FOR i IN 1..1000 LOOP
        DECLARE
            v_FechaAleatoria DATE;
        BEGIN
            -- Calcular una fecha de nacimiento aleatoria dentro del rango de 1940 a 2002
            v_FechaAleatoria := TO_DATE('01-01-1940', 'DD-MM-YYYY') + DBMS_RANDOM.VALUE(0, TO_DATE('01-01-2002', 'DD-MM-YYYY') - TO_DATE('01-01-1940', 'DD-MM-YYYY'));
            
            INSERT INTO TBL_PERSONA (DNI, Nombres, Apellidos, FechaNacimiento, Email, TelefonoID, GeneroID)
            VALUES (i, 'Nombre_' || i, 'Apellido_' || i, v_FechaAleatoria, 'correo_' || i || '@example.com', MOD(i,100) + 1, MOD(i,2) + 1); -- Asigna valores ficticios para Nombres, Apellidos, FechaNacimiento, Email, TelefonoID, y GeneroID
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    P_Llenar_Tabla_Persona;
END;
/



CREATE OR REPLACE PROCEDURE P_LLENAR_TABLA_EMPLEADO AS
    v_Rol VARCHAR2(100);
    v_Puesto VARCHAR2(100);
    v_DNI NUMBER;
    v_EmpresaID NUMBER;
BEGIN
    FOR i IN 1..1000 LOOP
        -- Asignar valores ficticios para Rol y Puesto
        v_Rol := CASE MOD(i, 2)
                    WHEN 0 THEN 'Gerente'
                    ELSE 'Empleado'
                END;
        v_Puesto := CASE MOD(i, 3)
                        WHEN 0 THEN 'Administrativo'
                        WHEN 1 THEN 'Técnico'
                        ELSE 'Operario'
                    END;
        
        -- Obtener un DNI aleatorio de las personas ya insertadas
        SELECT DNI INTO v_DNI FROM TBL_PERSONA WHERE ROWNUM = 1 ORDER BY DBMS_RANDOM.VALUE;
        
        -- Obtener un ID de empresa aleatorio de las empresas ya insertadas
        SELECT EmpresaID INTO v_EmpresaID FROM TBL_EMPRESA WHERE ROWNUM = 1 ORDER BY DBMS_RANDOM.VALUE;
        
        INSERT INTO TBL_EMPLEADO (EmpleadoID, Rol, Puesto, DNI, EmpresaID)
        VALUES (i, v_Rol, v_Puesto, v_DNI, v_EmpresaID);
    END LOOP;
END;
/
BEGIN
    P_LLENAR_TABLA_EMPLEADO;
END;
/


CREATE OR REPLACE PROCEDURE P_LLENAR_TABLA_USUARIO AS
BEGIN
    FOR i IN 1..1000 LOOP
        DECLARE
            v_DNI NUMBER;
        BEGIN
            -- Obtener un DNI aleatorio de las personas ya insertadas
            SELECT DNI INTO v_DNI FROM TBL_PERSONA WHERE ROWNUM = 1 ORDER BY DBMS_RANDOM.VALUE;
            
            INSERT INTO TBL_USUARIO (UsuarioID, DNI)
            VALUES (i, v_DNI);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/

BEGIN
    P_LLENAR_TABLA_USUARIO;
END;
/



CREATE OR REPLACE PROCEDURE P_LLENAR_TABLA_PROPIEDAD AS
    v_TipoPropiedadID NUMBER;
    v_EstadoReservaID NUMBER;
    v_Nombre VARCHAR2(255);
    v_Descripcion VARCHAR2(1000);
    v_Precio NUMBER;
    v_DireccionID NUMBER;
    v_EmpleadoID NUMBER;
BEGIN
    FOR i IN 1..1000 LOOP
        -- Obtener un TipoPropiedadID aleatorio entre 1 y 5
        v_TipoPropiedadID := ROUND(DBMS_RANDOM.VALUE(1, 5));
        
        -- Obtener un EstadoReservaID aleatorio entre 1 y 2
        v_EstadoReservaID := ROUND(DBMS_RANDOM.VALUE(1, 2));
        
        -- Asignar valores ficticios para Nombre, Descripcion y Precio
        v_Nombre := 'Propiedad_' || i;
        v_Descripcion := 'Descripción de la propiedad ' || i;
        v_Precio := ROUND(DBMS_RANDOM.VALUE(50000, 500000), 2); -- Precio aleatorio entre 50000 y 500000
        
        -- Obtener un DireccionID aleatorio entre 1 y 500
        v_DireccionID := ROUND(DBMS_RANDOM.VALUE(1, 500));
        
        -- Obtener un EmpleadoID aleatorio entre 1 y 500
        v_EmpleadoID := ROUND(DBMS_RANDOM.VALUE(1, 500));
        
        BEGIN
            INSERT INTO TBL_PROPIEDAD (PropiedadID, TipoPropiedadID, EstadoReservaID, Nombre, Descripcion, Precio, DireccionID, EmpleadoID)
            VALUES (i, v_TipoPropiedadID, v_EstadoReservaID, v_Nombre, v_Descripcion, v_Precio, v_DireccionID, v_EmpleadoID);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL; -- Ignorar intentos de inserción de claves duplicadas
        END;
    END LOOP;
END;
/
BEGIN
    P_LLENAR_TABLA_PROPIEDAD;
END;
/