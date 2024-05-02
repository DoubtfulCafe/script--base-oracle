procedimientos y triggers interesantes 

-- Secuencia para el número de factura
CREATE SEQUENCE SEQ_NUMERO_FACTURA
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Secuencia para el encabezado de factura
CREATE SEQUENCE SEQ_ENCABEZADO_FACTURA
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Secuencia para el detalle de factura
CREATE SEQUENCE SEQ_DETALLE_FACTURA
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;



CREATE OR REPLACE TRIGGER TRG_VERIFICAR_ESTADO_PROP
BEFORE INSERT ON TBL_RESERVA
FOR EACH ROW
DECLARE
    v_estado_reserva NUMBER;
BEGIN
    -- Obtener el estado de reserva de la propiedad
    SELECT EstadoReservaID INTO v_estado_reserva
    FROM TBL_PROPIEDAD
    WHERE PropiedadID = :NEW.PropiedadID;

    -- Verificar si la propiedad está disponible para ser reservada (EstadoReservaID = 2)
    IF v_estado_reserva = 2 THEN
        -- Cambiar el estado de reserva de la propiedad a ocupado (EstadoReservaID = 1)
        UPDATE TBL_PROPIEDAD
        SET EstadoReservaID = 1
        WHERE PropiedadID = :NEW.PropiedadID;
    ELSE
        -- Si la propiedad no está disponible, cancelar la inserción de la reserva
        RAISE_APPLICATION_ERROR(-20001, 'La propiedad no está disponible para reserva.');
    END IF;
END;
/

