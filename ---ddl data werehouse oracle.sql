---ddl data werehouse oracle

-- Tabla para almacenar información sobre propiedades
CREATE TABLE TBL_PROPIEDAD (
    PropiedadID NUMBER PRIMARY KEY,
    TipoPropiedad VARCHAR2(255),
    Nombre VARCHAR2(255),
    Descripcion VARCHAR2(1000),
    Precio NUMBER,
    Direccion VARCHAR2(1000)
);

-- Tabla para almacenar información sobre usuarios
CREATE TABLE TBL_USUARIO (
    UsuarioID NUMBER PRIMARY KEY,
    DNI NUMBER,
    Nombres VARCHAR2(100),
    Apellidos VARCHAR2(100),
    FechaNacimiento DATE,
    Email VARCHAR2(100),
    Telefono NUMBER,
    Genero VARCHAR2(100)  -- Ajusta el tamaño según tus necesidades
);

-- Tabla para almacenar información sobre empleados
CREATE TABLE TBL_EMPLEADO (
    EmpleadoID NUMBER PRIMARY KEY,
    DNI NUMBER,
    Nombres VARCHAR2(100),
    Apellidos VARCHAR2(100),
    FechaNacimiento DATE,
    Email VARCHAR2(100),
    Telefono NUMBER,
    Genero VARCHAR2(100),
    Rol VARCHAR2(100),
    Puesto VARCHAR2(100),
    Empresa NUMBER
);




-- Tabla para almacenar información sobre reservas
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



