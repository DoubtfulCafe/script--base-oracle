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




CREATE OR REPLACE TRIGGER TRG_VERIFICAR_DISPONIBILIDAD_RESERVA
BEFORE INSERT ON TBL_RESERVA
FOR EACH ROW
DECLARE
    v_estado_reserva NUMBER;
    v_subtotal NUMBER;
    v_impuesto NUMBER;
    v_total NUMBER;
BEGIN
    -- Obtener el estado de reserva de la propiedad
    SELECT EstadoReservaID INTO v_estado_reserva
    FROM TBL_PROPIEDAD
    WHERE PropiedadID = :NEW.PropiedadID;

    -- Verificar si la propiedad está libre para ser reservada (EstadoReservaID = 2)
    IF v_estado_reserva = 2 THEN
        -- Actualizar el estado de reserva de la propiedad a ocupado (EstadoReservaID = 1)
        UPDATE TBL_PROPIEDAD
        SET EstadoReservaID = 1
        WHERE PropiedadID = :NEW.PropiedadID;

        -- Calcular el subtotal como la suma de precio estadia y adelanto de la reserva
        v_subtotal := :NEW.PRECIOESTADIA + :NEW.ADELANTO;

        -- Obtener el monto de impuesto de la reserva
        v_impuesto := :NEW.MONTOIMPUESTO;

        -- Calcular el total como la suma del subtotal más el impuesto
        v_total := v_subtotal + v_impuesto;

        -- Permitir la inserción de la reserva
        NULL;

        -- Insertar datos en la tabla TBL_ENCABEZADO_FACTURA
        INSERT INTO TBL_ENCABEZADO_FACTURA (FacturaID, FechaFactura, NumeroFactura, EmpresaID, ReservaID)
        VALUES (SEQ_ENCABEZADO_FACTURA.NEXTVAL, :NEW.FECHACHECKIN, SEQ_NUMERO_FACTURA.NEXTVAL, 1, :NEW.ReservaID);

        -- Obtener el ID de la factura recién insertada
        DECLARE
            v_factura_id NUMBER;
        BEGIN
            SELECT FacturaID INTO v_factura_id
            FROM TBL_ENCABEZADO_FACTURA
            WHERE ReservaID = :NEW.ReservaID;

            -- Insertar datos en la tabla TBL_DETALLE_FACTURA
            INSERT INTO TBL_DETALLE_FACTURA (DetalleFacturaID, Subtotal, Impuesto, Descuento, Total, ID_Factura)
            VALUES (SEQ_DETALLE_FACTURA.NEXTVAL, v_subtotal, v_impuesto, 0, v_total, v_factura_id);
        END;
    ELSE
        -- Si la propiedad está ocupada, cancelar la inserción de la reserva
        RAISE_APPLICATION_ERROR(-20001, 'La propiedad no está disponible para reserva.');
    END IF;
END;
/
