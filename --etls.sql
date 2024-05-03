--etls
---ETL USUARIO
CREATE SEQUENCE SEQ_ETL_LOG;

CREATE OR REPLACE PROCEDURE P_INSERT_ETL_LOG (
    P_NOMBRE_ETL IN VARCHAR2,
    P_FECHA_HORA_INICIO IN DATE,
    P_ESTATUS IN VARCHAR2,
    P_ERROR IN VARCHAR2
) AS
BEGIN
    INSERT INTO etl_log (id, nombre_etl, fecha_hora_inicio, estatus, error)
    VALUES (SEQ_ETL_LOG.NEXTVAL, P_NOMBRE_ETL, P_FECHA_HORA_INICIO, P_ESTATUS, P_ERROR);
    COMMIT;
END P_INSERT_ETL_LOG;
/
 SELECT 
    U.UsuarioID,
    U.DNI,
    P.Nombres,
    P.Apellidos,
    P.FechaNacimiento,
    P.Email,
    T.Numero AS Telefono,
    G.Tipo AS Genero
FROM 
    TBL_USUARIO@DB_LINK_PROYECTO_PRUEBA2 U
JOIN 
    TBL_PERSONA@DB_LINK_PROYECTO_PRUEBA2 P ON U.DNI = P.DNI
LEFT JOIN 
    TBL_TELEFONO@DB_LINK_PROYECTO_PRUEBA2 T ON P.TelefonoID = T.TelefonoID
JOIN 
    TBL_GENERO@DB_LINK_PROYECTO_PRUEBA2 G ON P.GeneroID = G.GeneroID
WHERE 
    U.UsuarioID = 1;
CREATE OR REPLACE PROCEDURE ETL_USUARIOS AS
    v_total_filas NUMBER;
    v_filas_procesadas NUMBER := 0;
BEGIN
    -- Truncar la tabla en el esquema local
    EXECUTE IMMEDIATE 'TRUNCATE TABLE C##DANIEL.TBL_USUARIO';

    -- Contar el número total de filas a procesar
    SELECT COUNT(*) INTO v_total_filas
    FROM TBL_USUARIO@DB_LINK_PROYECTO_PRUEBA2 U
    JOIN TBL_PERSONA@DB_LINK_PROYECTO_PRUEBA2 P ON U.DNI = P.DNI
    JOIN TBL_GENERO@DB_LINK_PROYECTO_PRUEBA2 G ON P.GeneroID = G.GeneroID;

    -- Procesar las filas una por una
    FOR user_row IN (
        SELECT U.UsuarioID, U.DNI, P.Nombres, P.Apellidos, P.FechaNacimiento, P.Email, T.TelefonoID, G.Tipo AS Genero
        FROM TBL_USUARIO@DB_LINK_PROYECTO_PRUEBA2 U
        JOIN TBL_PERSONA@DB_LINK_PROYECTO_PRUEBA2 P ON U.DNI = P.DNI
        LEFT JOIN TBL_TELEFONO@DB_LINK_PROYECTO_PRUEBA2 T ON P.TelefonoID = T.TelefonoID
        JOIN TBL_GENERO@DB_LINK_PROYECTO_PRUEBA2 G ON P.GeneroID = G.GeneroID
    ) 
    LOOP
        -- Insertar datos en la tabla local
        INSERT INTO C##DANIEL.TBL_USUARIO (UsuarioID, DNI, Nombres, Apellidos, FechaNacimiento, Email, Telefono, Genero)
        VALUES (user_row.UsuarioID, user_row.DNI, user_row.Nombres, user_row.Apellidos, user_row.FechaNacimiento, user_row.Email, user_row.TelefonoID, user_row.Genero);
        
        -- Incrementar contador de filas procesadas
        v_filas_procesadas := v_filas_procesadas + 1;
        
        -- Salir del bucle si todas las filas han sido procesadas
        EXIT WHEN v_filas_procesadas = v_total_filas;
    END LOOP;
    
    -- Registrar el evento en el log de ETL
    P_INSERT_ETL_LOG(
        P_NOMBRE_ETL => 'ETL_USUARIOS',
        P_FECHA_HORA_INICIO => SYSTIMESTAMP,
        P_ESTATUS => 'S',
        P_ERROR => NULL
    );

    -- Confirmar los cambios en la base de datos
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos.');
        -- Agregar al log de errores
        P_INSERT_ETL_LOG(
            P_NOMBRE_ETL => 'ETL_USUARIOS',
            P_FECHA_HORA_INICIO => SYSTIMESTAMP,
            P_ESTATUS => 'F',
            P_ERROR => SQLCODE || ' - ' || SQLERRM
        );
END ETL_USUARIOS;
/
---ETL PROPIEDAD
SELECT 
    P.PropiedadID,
    TP.Nombre AS TipoPropiedad,
    P.Nombre,
    P.Descripcion,
    P.Precio,
    D.NUMERO_CASA AS Direccion
FROM 
    TBL_PROPIEDAD@DB_LINK_PROYECTO_PRUEBA2 P
JOIN 
    TBL_DIRECCIONES@DB_LINK_PROYECTO_PRUEBA2 D ON P.DireccionID = D.DireccionID
JOIN 
    TBL_TIPO_PROPIEDAD@DB_LINK_PROYECTO_PRUEBA2 TP ON P.TipoPropiedadID = TP.TipoPropiedadID
WHERE 
    P.PropiedadID = 1;

CREATE OR REPLACE PROCEDURE ETL_PROPIEDAD AS
    v_total_filas NUMBER;
    v_filas_procesadas NUMBER := 0;
BEGIN
    -- Truncar la tabla en el esquema local
    EXECUTE IMMEDIATE 'TRUNCATE TABLE C##DANIEL.TBL_PROPIEDAD';

    -- Contar el número total de filas a procesar
    SELECT COUNT(*) INTO v_total_filas
    FROM TBL_PROPIEDAD@DB_LINK_PROYECTO_PRUEBA2 P
    JOIN TBL_DIRECCIONES@DB_LINK_PROYECTO_PRUEBA2 D ON P.DireccionID = D.DireccionID
    JOIN TBL_TIPO_PROPIEDAD@DB_LINK_PROYECTO_PRUEBA2 TP ON P.TipoPropiedadID = TP.TipoPropiedadID;

    -- Procesar las filas una por una
    FOR prop_row IN (
        SELECT P.PropiedadID, TP.Nombre AS TipoPropiedad, P.Nombre, P.Descripcion, P.Precio, D.NUMERO_CASA AS Direccion
        FROM TBL_PROPIEDAD@DB_LINK_PROYECTO_PRUEBA2 P
        JOIN TBL_DIRECCIONES@DB_LINK_PROYECTO_PRUEBA2 D ON P.DireccionID = D.DireccionID
        JOIN TBL_TIPO_PROPIEDAD@DB_LINK_PROYECTO_PRUEBA2 TP ON P.TipoPropiedadID = TP.TipoPropiedadID
    ) 
    LOOP
        -- Insertar datos en la tabla local
        INSERT INTO C##DANIEL.TBL_PROPIEDAD (PropiedadID, TipoPropiedad, Nombre, Descripcion, Precio, Direccion)
        VALUES (prop_row.PropiedadID, prop_row.TipoPropiedad, prop_row.Nombre, prop_row.Descripcion, prop_row.Precio, prop_row.Direccion);
        
        -- Incrementar contador de filas procesadas
        v_filas_procesadas := v_filas_procesadas + 1;
        
        -- Salir del bucle si todas las filas han sido procesadas
        EXIT WHEN v_filas_procesadas = v_total_filas;
    END LOOP;
    
    -- Registrar el evento en el log de ETL
    P_INSERT_ETL_LOG(
        P_NOMBRE_ETL => 'ETL_PROPIEDAD',
        P_FECHA_HORA_INICIO => SYSDATE,
        P_ESTATUS => 'S',
        P_ERROR => NULL
    );

    -- Confirmar los cambios en la base de datos
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos.');
        -- Agregar al log de errores
        P_INSERT_ETL_LOG(
            P_NOMBRE_ETL => 'ETL_PROPIEDAD',
            P_FECHA_HORA_INICIO => SYSDATE,
            P_ESTATUS => 'F',
            P_ERROR => SQLCODE || ' - ' || SQLERRM
        );
END ETL_PROPIEDAD;
/

-- Crear el job para ejecutar ETL_PROPIEDAD cada 5 minutos
BEGIN
    -- Crear el job
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'ETL_PROPIEDAD_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN ETL_PROPIEDAD; END;',
        start_date      => SYSDATE,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=5',
        enabled         => TRUE,
        comments        => 'Job para ejecutar el procedimiento ETL_PROPIEDAD cada 5 minutos'
    );
END;
/





   


SELECT 
    E.EmpleadoID,
    P.DNI,
    P.Nombres,
    P.Apellidos,
    P.FechaNacimiento,
    P.Email,
    T.Numero AS Telefono,
    P.GeneroID AS Genero,
    E.Rol,
    E.Puesto,
    EM.Nombre AS Empresa
FROM 
    TBL_EMPLEADO@DB_LINK_PROYECTO_PRUEBA2 E
JOIN 
    TBL_PERSONA@DB_LINK_PROYECTO_PRUEBA2 P ON E.DNI = P.DNI
LEFT JOIN 
    TBL_TELEFONO@DB_LINK_PROYECTO_PRUEBA2 T ON P.TelefonoID = T.TelefonoID
JOIN 
    TBL_EMPRESA@DB_LINK_PROYECTO_PRUEBA2 EM ON E.EmpresaID = EM.EmpresaID
WHERE 
    E.EmpleadoID = 1;


CREATE OR REPLACE PROCEDURE ETL_EMPLEADOS AS
    v_total_filas NUMBER;
    v_filas_procesadas NUMBER := 0;
BEGIN
    -- Truncar la tabla en el esquema local
    EXECUTE IMMEDIATE 'TRUNCATE TABLE C##DANIEL.TBL_EMPLEADO';

    -- Contar el número total de filas a procesar
    SELECT COUNT(*) INTO v_total_filas
    FROM TBL_EMPLEADO@DB_LINK_PROYECTO_PRUEBA2 E
    JOIN TBL_PERSONA@DB_LINK_PROYECTO_PRUEBA2 P ON E.DNI = P.DNI
    JOIN TBL_EMPRESA@DB_LINK_PROYECTO_PRUEBA2 EM ON E.EmpresaID = EM.EmpresaID;

    -- Procesar las filas una por una
    FOR emp_row IN (
        SELECT E.EmpleadoID, P.DNI, P.Nombres, P.Apellidos, P.FechaNacimiento, P.Email, T.Numero AS Telefono, G.Tipo AS Genero, E.Rol, E.Puesto, EM.Nombre AS Empresa
        FROM TBL_EMPLEADO@DB_LINK_PROYECTO_PRUEBA2 E
        JOIN TBL_PERSONA@DB_LINK_PROYECTO_PRUEBA2 P ON E.DNI = P.DNI
        LEFT JOIN TBL_TELEFONO@DB_LINK_PROYECTO_PRUEBA2 T ON P.TelefonoID = T.TelefonoID
        JOIN TBL_EMPRESA@DB_LINK_PROYECTO_PRUEBA2 EM ON E.EmpresaID = EM.EmpresaID
        JOIN TBL_GENERO@DB_LINK_PROYECTO_PRUEBA2 G ON P.GeneroID = G.GeneroID
    ) 
    LOOP
        -- Insertar datos en la tabla local
        INSERT INTO C##DANIEL.TBL_EMPLEADO (EmpleadoID, DNI, Nombres, Apellidos, FechaNacimiento, Email, Telefono, Genero, Rol, Puesto, Empresa)
        VALUES (emp_row.EmpleadoID, emp_row.DNI, emp_row.Nombres, emp_row.Apellidos, emp_row.FechaNacimiento, emp_row.Email, emp_row.Telefono, emp_row.Genero, emp_row.Rol, emp_row.Puesto, emp_row.Empresa);
        
        -- Incrementar contador de filas procesadas
        v_filas_procesadas := v_filas_procesadas + 1;
        
        -- Salir del bucle si todas las filas han sido procesadas
        EXIT WHEN v_filas_procesadas = v_total_filas;
    END LOOP;
    
    -- Registrar el evento en el log de ETL
    P_INSERT_ETL_LOG(
        P_NOMBRE_ETL => 'ETL_EMPLEADOS',
        P_FECHA_HORA_INICIO => SYSDATE,
        P_ESTATUS => 'S',
        P_ERROR => NULL
    );

    -- Confirmar los cambios en la base de datos
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos.');
        -- Agregar al log de errores
        P_INSERT_ETL_LOG(
            P_NOMBRE_ETL => 'ETL_EMPLEADOS',
            P_FECHA_HORA_INICIO => SYSDATE,
            P_ESTATUS => 'F',
            P_ERROR => SQLCODE || ' - ' || SQLERRM
        );
END ETL_EMPLEADOS;
/

BEGIN
    -- Crear el job
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'ETL_EMPLEADOS_JOB_BUENO',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN ETL_EMPLEADOS; END;',
        start_date      => SYSDATE,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=7',
        enabled         => TRUE,
        comments        => 'Job para ejecutar el procedimiento ETL_EMPLEADOS cada 7 minutos'
    );
END;
/



    SELECT 
    ReservaID,
    FechaCheckin,
    FechaCheckout,
    NumeroHuespedes,
    PrecioEstadia,
    MontoImpuesto,
    Adelanto,
    EmpleadoID,
    UsuarioID,
    PropiedadID
FROM 
    TBL_RESERVA@DB_LINK_PROYECTO_PRUEBA2
WHERE 
    ReservaID = 1;

CREATE OR REPLACE PROCEDURE ETL_RESERVAS AS
    v_total_filas NUMBER;
    v_filas_procesadas NUMBER := 0;
BEGIN
    -- Truncar la tabla en el esquema local
    EXECUTE IMMEDIATE 'TRUNCATE TABLE C##DANIEL.TBL_RESERVA';

    -- Contar el número total de filas a procesar
    SELECT COUNT(*) INTO v_total_filas
    FROM TBL_RESERVA@DB_LINK_PROYECTO_PRUEBA2;

    -- Procesar las filas una por una
    FOR reserva_row IN (
        SELECT ReservaID, FechaCheckin, FechaCheckout, NumeroHuespedes, PrecioEstadia, MontoImpuesto, Adelanto, EmpleadoID, UsuarioID, PropiedadID
        FROM TBL_RESERVA@DB_LINK_PROYECTO_PRUEBA2
        WHERE ReservaID = 1
    ) 
    LOOP
        -- Insertar datos en la tabla local
        INSERT INTO C##DANIEL.TBL_RESERVA (ReservaID, FechaCheckin, FechaCheckout, NumeroHuespedes, PrecioEstadia, MontoImpuesto, Adelanto, EmpleadoID, UsuarioID, PropiedadID)
        VALUES (reserva_row.ReservaID, reserva_row.FechaCheckin, reserva_row.FechaCheckout, reserva_row.NumeroHuespedes, reserva_row.PrecioEstadia, reserva_row.MontoImpuesto, reserva_row.Adelanto, reserva_row.EmpleadoID, reserva_row.UsuarioID, reserva_row.PropiedadID);
        
        -- Incrementar contador de filas procesadas
        v_filas_procesadas := v_filas_procesadas + 1;
        
        -- Salir del bucle si todas las filas han sido procesadas
        EXIT WHEN v_filas_procesadas = v_total_filas;
    END LOOP;
    
    -- Registrar el evento en el log de ETL
    P_INSERT_ETL_LOG(
        P_NOMBRE_ETL => 'ETL_RESERVAS',
        P_FECHA_HORA_INICIO => SYSDATE,
        P_ESTATUS => 'S',
        P_ERROR => NULL
    );

    -- Confirmar los cambios en la base de datos
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos.');
        -- Agregar al log de errores
        P_INSERT_ETL_LOG(
            P_NOMBRE_ETL => 'ETL_RESERVAS',
            P_FECHA_HORA_INICIO => SYSDATE,
            P_ESTATUS => 'F',
            P_ERROR => SQLCODE || ' - ' || SQLERRM
        );
END ETL_RESERVAS;
/

BEGIN
    -- Crear el job
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'ETL_RESERVAS_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN ETL_RESERVAS; END;',
        start_date      => SYSDATE,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=3',
        enabled         => TRUE,
        comments        => 'Job para ejecutar el procedimiento ETL_RESERVAS cada 7 minutos'
    );
END;
/
