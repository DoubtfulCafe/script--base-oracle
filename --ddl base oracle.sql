--ddl base oracle
BEGIN
    FOR cur_rec IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || cur_rec.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/
-- Tabla para almacenar información sobre países
CREATE TABLE TBL_PAISES (
    PaisID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100)
);

-- Tabla para almacenar información sobre géneros
CREATE TABLE TBL_GENERO (
    GeneroID NUMBER PRIMARY KEY,
    Tipo VARCHAR2(50)
);

-- Tabla para almacenar información sobre tipos de documento
CREATE TABLE TBL_TIPO_DOCUMENTO (
    TipoDocumentoID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100),
    CodigoSAR NUMBER
);

-- Tabla para almacenar información sobre teléfonos
CREATE TABLE TBL_TELEFONO (
    TelefonoID NUMBER PRIMARY KEY,
    Numero NUMBER
);

-- Tabla para almacenar información sobre estados de reservas de propiedades
CREATE TABLE TBL_ESTADO_RESERVA (
    EstadoReservaID NUMBER PRIMARY KEY,
    Descripcion VARCHAR2(255)
);

-- Tabla para almacenar información sobre empresas
CREATE TABLE TBL_EMPRESA (
    EmpresaID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(255),
    RTN NUMBER,
    Email VARCHAR2(100),
    CasaMatriz VARCHAR2(255),
    Telefono NUMBER
);

-- Tabla para almacenar información sobre sucursales
CREATE TABLE TBL_SUCURSAL (
    SucursalID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(255),
    Telefono NUMBER,
    CodigoSAR NUMBER
);

-- Tabla para almacenar valoraciones
CREATE TABLE TBL_VALORACION (
    ValoracionID NUMBER PRIMARY KEY,
    Descripcion VARCHAR2(255),
    Valor NUMBER
);


-- Tabla para almacenar URLs de fotos de propiedades
CREATE TABLE TBL_FOTOS_PROPIEDAD (
    FotoID NUMBER PRIMARY KEY,
    EnlaceFoto VARCHAR2(255)
);

-- Tabla para almacenar información sobre estados/provincias
CREATE TABLE TBL_ESTADOS_PROVINCIAS (
    EstadoProvinciaID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100),
    PaisID NUMBER,
    FOREIGN KEY (PaisID) REFERENCES TBL_PAISES(PaisID)
);

-- Tabla para almacenar información sobre ciudades
CREATE TABLE TBL_CIUDADES (
    CiudadID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100),
    EstadoProvinciaID NUMBER,
    FOREIGN KEY (EstadoProvinciaID) REFERENCES TBL_ESTADOS_PROVINCIAS(EstadoProvinciaID)
);

-- Tabla para almacenar información sobre códigos postales
CREATE TABLE TBL_CODIGOS_POSTALES (
    CodigoPostalID NUMBER PRIMARY KEY,
    CodigoPostal NUMBER,
    CiudadID NUMBER,
    FOREIGN KEY (CiudadID) REFERENCES TBL_CIUDADES(CiudadID)
);

-- Tabla para almacenar información sobre direcciones
CREATE TABLE TBL_DIRECCIONES (
    DireccionID NUMBER PRIMARY KEY,
    NUMERO_CASA VARCHAR2(255),
    CiudadID NUMBER,
    FOREIGN KEY (CiudadID) REFERENCES TBL_CIUDADES(CiudadID)
);


-- Tabla para almacenar información sobre personas
CREATE TABLE TBL_PERSONA (
    DNI NUMBER PRIMARY KEY,
    Nombres VARCHAR2(100),
    Apellidos VARCHAR2(100),
    FechaNacimiento DATE,
    Email VARCHAR2(100),
    TelefonoID NUMBER,
    GeneroID NUMBER,
    FOREIGN KEY (TelefonoID) REFERENCES TBL_TELEFONO(TelefonoID),
    FOREIGN KEY (GeneroID) REFERENCES TBL_GENERO(GeneroID)
);

-- Tabla para almacenar información sobre empleados
CREATE TABLE TBL_EMPLEADO (
    EmpleadoID NUMBER PRIMARY KEY,
    Rol VARCHAR2(100),
    Puesto VARCHAR2(100),
    DNI NUMBER,
    EmpresaID NUMBER,
    FOREIGN KEY (EmpresaID) REFERENCES TBL_EMPRESA(EmpresaID),
    FOREIGN KEY (DNI) REFERENCES TBL_PERSONA(DNI)
);



-- Tabla para almacenar información sobre usuarios
CREATE TABLE TBL_USUARIO (
    UsuarioID NUMBER PRIMARY KEY,
    DNI NUMBER,
    FOREIGN KEY (DNI) REFERENCES TBL_PERSONA(DNI)
);
-- Tabla para almacenar información sobre puntos de emisión
CREATE TABLE TBL_PUNTO_EMISION (
    PuntoEmisionID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(255),
    CodigoSAR NUMBER,
    SucursalID NUMBER,
    FOREIGN KEY (SucursalID) REFERENCES TBL_SUCURSAL(SucursalID)
);

-- Tabla para almacenar información sobre resoluciones
CREATE TABLE TBL_RESOLUCION (
    ResolucionID NUMBER PRIMARY KEY,
    CAI NUMBER,
    InicioRango NUMBER,
    FinRango NUMBER,
    Actual NUMBER,
    FechaLimite DATE,
    TipoDocumentoID NUMBER,
    PuntoEmisionID NUMBER,
    FOREIGN KEY (TipoDocumentoID) REFERENCES TBL_TIPO_DOCUMENTO(TipoDocumentoID),
    FOREIGN KEY (PuntoEmisionID) REFERENCES TBL_PUNTO_EMISION(PuntoEmisionID)
);


-- Tabla para almacenar información sobre tipos de propiedad
CREATE TABLE TBL_TIPO_PROPIEDAD (
    TipoPropiedadID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100)
);

-- Tabla para almacenar información sobre características de propiedades
CREATE TABLE TBL_CARACTERISTICA (
    CaracteristicaID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100)
);


-- Tabla para almacenar información sobre propiedades
CREATE TABLE TBL_PROPIEDAD (
    PropiedadID NUMBER PRIMARY KEY,
    TipoPropiedadID NUMBER,
    EstadoReservaID NUMBER,
    Nombre VARCHAR2(255),
    Descripcion VARCHAR2(1000),
    Precio NUMBER,
    DireccionID NUMBER,
    EmpleadoID NUMBER,
    FOREIGN KEY (EstadoReservaID) REFERENCES TBL_ESTADO_RESERVA(EstadoReservaID),
    FOREIGN KEY (TipoPropiedadID) REFERENCES TBL_TIPO_PROPIEDAD(TipoPropiedadID),
    FOREIGN KEY (DireccionID) REFERENCES TBL_DIRECCIONES(DireccionID),
    FOREIGN KEY (EmpleadoID) REFERENCES TBL_EMPLEADO(EmpleadoID)
);

-- Tabla para relacionar características con propiedades
CREATE TABLE TBL_CARACTERISTICA_X_PROPIEDAD (
    CaracteristicaID NUMBER,
    PropiedadID NUMBER,
    FOREIGN KEY (CaracteristicaID) REFERENCES TBL_CARACTERISTICA(CaracteristicaID),
    FOREIGN KEY (PropiedadID) REFERENCES TBL_PROPIEDAD(PropiedadID)
);


-- Tabla para almacenar información sobre reservas de propiedades
CREATE TABLE TBL_RESERVA (
    ReservaID NUMBER PRIMARY KEY,
    FechaCheckin DATE,
    FechaCheckout DATE,
    NumeroHuespedes NUMBER,
    PrecioEstadia NUMBER,
    MontoImpuesto NUMBER,
    Adelanto NUMBER,
    EmpleadoID NUMBER,
    UsuarioID NUMBER,
    PropiedadID NUMBER,
    FOREIGN KEY (UsuarioID) REFERENCES TBL_USUARIO(UsuarioID),
    FOREIGN KEY (EmpleadoID) REFERENCES TBL_EMPLEADO(EmpleadoID),
    FOREIGN KEY (PropiedadID) REFERENCES TBL_PROPIEDAD(PropiedadID)
);



-- Tabla para almacenar información sobre encabezados de facturas
CREATE TABLE TBL_ENCABEZADO_FACTURA (
    FacturaID NUMBER PRIMARY KEY,
    FechaFactura DATE,
    NumeroFactura NUMBER,
    EmpresaID NUMBER,
    ResolucionID NUMBER,
    ReservaID NUMBER,
    FOREIGN KEY (EmpresaID) REFERENCES TBL_EMPRESA(EmpresaID),
    FOREIGN KEY (ResolucionID) REFERENCES TBL_RESOLUCION(ResolucionID),
    FOREIGN KEY (ReservaID) REFERENCES TBL_RESERVA(ReservaID)
);

-- Tabla para almacenar detalles de facturas
CREATE TABLE TBL_DETALLE_FACTURA (
    DetalleFacturaID NUMBER PRIMARY KEY,
    Subtotal NUMBER(10, 2),
    Impuesto NUMBER(10, 2),
    Descuento NUMBER(10, 2),
    Total NUMBER(10, 2),
    ID_Factura NUMBER,
    FOREIGN KEY (ID_Factura) REFERENCES TBL_ENCABEZADO_FACTURA(FacturaID)
);

-- Tabla para almacenar comentarios de usuarios sobre propiedades
CREATE TABLE TBL_COMENTARIOS_PROPIEDAD (
    ComentarioID NUMBER PRIMARY KEY,
    Comentario VARCHAR2(1000),
    Valoracion NUMBER,
    PropiedadID NUMBER,
    UsuarioID NUMBER,
    ValoracionID NUMBER,
    FOREIGN KEY (ValoracionID) REFERENCES TBL_VALORACION(ValoracionID),
    FOREIGN KEY (PropiedadID) REFERENCES TBL_PROPIEDAD(PropiedadID),
    FOREIGN KEY (UsuarioID) REFERENCES TBL_USUARIO(UsuarioID)
);






-- Insertar datos en TBL_PAISES
INSERT INTO TBL_PAISES (PaisID, Nombre) VALUES (1, 'Estados Unidos');
INSERT INTO TBL_PAISES (PaisID, Nombre) VALUES (2, 'Canadá');
INSERT INTO TBL_PAISES (PaisID, Nombre) VALUES (3, 'España');
INSERT INTO TBL_PAISES (PaisID, Nombre) VALUES (4, 'Italia');
INSERT INTO TBL_PAISES (PaisID, Nombre) VALUES (5, 'Francia');



-- Insertar datos en TBL_CARACTERISTICA
INSERT INTO TBL_CARACTERISTICA (CaracteristicaID, Nombre) VALUES (1, 'Piscina');
INSERT INTO TBL_CARACTERISTICA (CaracteristicaID, Nombre) VALUES (2, 'Terraza');
INSERT INTO TBL_CARACTERISTICA (CaracteristicaID, Nombre) VALUES (3, 'Jardín');
INSERT INTO TBL_CARACTERISTICA (CaracteristicaID, Nombre) VALUES (4, 'Cocina Equipada');
INSERT INTO TBL_CARACTERISTICA (CaracteristicaID, Nombre) VALUES (5, 'Vista al mar');


-- Insertar datos en TBL_TELEFONO
INSERT INTO TBL_TELEFONO (TelefonoID, Numero) VALUES (1, 1234567890);
INSERT INTO TBL_TELEFONO (TelefonoID, Numero) VALUES (2, 2345678901);
INSERT INTO TBL_TELEFONO (TelefonoID, Numero) VALUES (3, 3456789012);
INSERT INTO TBL_TELEFONO (TelefonoID, Numero) VALUES (4, 4567890123);
INSERT INTO TBL_TELEFONO (TelefonoID, Numero) VALUES (5, 5678901234);

-- Insertar datos en TBL_EMPRESA
INSERT INTO TBL_EMPRESA (EmpresaID, Nombre, RTN, Email, CasaMatriz, Telefono) VALUES (1, 'Empresa A', 123456789, 'empresaA@example.com', 'Dirección Casa Matriz A', 1);
INSERT INTO TBL_EMPRESA (EmpresaID, Nombre, RTN, Email, CasaMatriz, Telefono) VALUES (2, 'Empresa B', 234567890, 'empresaB@example.com', 'Dirección Casa Matriz B', 2);
INSERT INTO TBL_EMPRESA (EmpresaID, Nombre, RTN, Email, CasaMatriz, Telefono) VALUES (3, 'Empresa C', 345678901, 'empresaC@example.com', 'Dirección Casa Matriz C', 3);
INSERT INTO TBL_EMPRESA (EmpresaID, Nombre, RTN, Email, CasaMatriz, Telefono) VALUES (4, 'Empresa D', 456789012, 'empresaD@example.com', 'Dirección Casa Matriz D', 4);
INSERT INTO TBL_EMPRESA (EmpresaID, Nombre, RTN, Email, CasaMatriz, Telefono) VALUES (5, 'Empresa E', 567890123, 'empresaE@example.com', 'Dirección Casa Matriz E', 5);

-- Insertar datos en TBL_SUCURSAL
INSERT INTO TBL_SUCURSAL (SucursalID, Nombre, Telefono, CodigoSAR) VALUES (1, 'Sucursal A', 1234567890, 1);
INSERT INTO TBL_SUCURSAL (SucursalID, Nombre, Telefono, CodigoSAR) VALUES (2, 'Sucursal B', 2345678901, 2);
INSERT INTO TBL_SUCURSAL (SucursalID, Nombre, Telefono, CodigoSAR) VALUES (3, 'Sucursal C', 3456789012, 3);
INSERT INTO TBL_SUCURSAL (SucursalID, Nombre, Telefono, CodigoSAR) VALUES (4, 'Sucursal D', 4567890123, 4);
INSERT INTO TBL_SUCURSAL (SucursalID, Nombre, Telefono, CodigoSAR) VALUES (5, 'Sucursal E', 5678901234, 5);



-- Insertar datos en TBL_ESTADOS_PROVINCIAS
INSERT INTO TBL_ESTADOS_PROVINCIAS (EstadoProvinciaID, Nombre, PaisID) VALUES (6, 'California', 1);
INSERT INTO TBL_ESTADOS_PROVINCIAS (EstadoProvinciaID, Nombre, PaisID) VALUES (7, 'Illinois', 1);
INSERT INTO TBL_ESTADOS_PROVINCIAS (EstadoProvinciaID, Nombre, PaisID) VALUES (8, 'British Columbia', 2);
INSERT INTO TBL_ESTADOS_PROVINCIAS (EstadoProvinciaID, Nombre, PaisID) VALUES (9, 'Cataluña', 3);
INSERT INTO TBL_ESTADOS_PROVINCIAS (EstadoProvinciaID, Nombre, PaisID) VALUES (10, 'Lombardía', 4);


-- Insertar datos en TBL_CIUDADES
INSERT INTO TBL_CIUDADES (CiudadID, Nombre, EstadoProvinciaID) VALUES (1, 'Los Angeles', 1);
INSERT INTO TBL_CIUDADES (CiudadID, Nombre, EstadoProvinciaID) VALUES (2, 'Chicago', 1);
INSERT INTO TBL_CIUDADES (CiudadID, Nombre, EstadoProvinciaID) VALUES (3, 'Vancouver', 2);
INSERT INTO TBL_CIUDADES (CiudadID, Nombre, EstadoProvinciaID) VALUES (4, 'Barcelona', 3);
INSERT INTO TBL_CIUDADES (CiudadID, Nombre, EstadoProvinciaID) VALUES (5, 'Milan', 4);



-- Insertar datos en TBL_DIRECCIONES
INSERT INTO TBL_DIRECCIONES (DireccionID, NUMERO_CASA, CiudadID) VALUES (1, 'Dirección 1', 1);
INSERT INTO TBL_DIRECCIONES (DireccionID, NUMERO_CASA, CiudadID) VALUES (2, 'Dirección 2', 2);
INSERT INTO TBL_DIRECCIONES (DireccionID, NUMERO_CASA, CiudadID) VALUES (3, 'Dirección 3', 3);
INSERT INTO TBL_DIRECCIONES (DireccionID, NUMERO_CASA, CiudadID) VALUES (4, 'Dirección 4', 4);
INSERT INTO TBL_DIRECCIONES (DireccionID, NUMERO_CASA, CiudadID) VALUES (5, 'Dirección 5', 5);



INSERT INTO TBL_PUNTO_EMISION (PuntoEmisionID, Nombre, CodigoSAR, SucursalID)
VALUES (1, 'Punto Emisión A', 123456, 1);

INSERT INTO TBL_PUNTO_EMISION (PuntoEmisionID, Nombre, CodigoSAR, SucursalID)
VALUES (2, 'Punto Emisión B', 654321, 2);

INSERT INTO TBL_PUNTO_EMISION (PuntoEmisionID, Nombre, CodigoSAR, SucursalID)
VALUES (3, 'Punto Emisión C', 987654, 1);


INSERT INTO TBL_RESOLUCION (ResolucionID, CAI, InicioRango, FinRango, Actual, FechaLimite, TipoDocumentoID, PuntoEmisionID)
VALUES (1, 123456789, 1000, 2000, 1500, TO_DATE('2024-06-30', 'YYYY-MM-DD'), 1, 1);

INSERT INTO TBL_RESOLUCION (ResolucionID, CAI, InicioRango, FinRango, Actual, FechaLimite, TipoDocumentoID, PuntoEmisionID)
VALUES (2, 987654321, 3000, 4000, 3500, TO_DATE('2024-07-31', 'YYYY-MM-DD'), 2, 2);

INSERT INTO TBL_RESOLUCION (ResolucionID, CAI, InicioRango, FinRango, Actual, FechaLimite, TipoDocumentoID, PuntoEmisionID)
VALUES (3, 456789123, 5000, 6000, 5500, TO_DATE('2024-08-31', 'YYYY-MM-DD'), 1, 1);

   








