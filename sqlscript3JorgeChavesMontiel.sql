
Use ElectroStore;

-- 1. Crear el procedimiento almacenado “InsertarVenta”

CREATE PROCEDURE InsertarVenta
    @pCodigoProducto INT,
    @pCantidad INT,
    @pIdentificacionCliente VARCHAR(25),
    @pCodigoEmpleado INT,
    @pCodigoTienda INT,
    @pFechaVenta DATETIME,
    @pFechaEntrega DATETIME,
    @pDescuento DECIMAL(10,0)
AS
BEGIN
    DECLARE @stockDisponible INT;
    DECLARE @numFactura INT;  -- Variable para almacenar el número de factura
    
    -- OBTENER EL PRÓXIMO NÚMERO DE FACTURA
    SELECT @numFactura = ISNULL(MAX(NumFactura), 0) + 1 FROM ELEFacturaEnc;
    
    -- Verificar si el producto existe y tiene suficiente cantidad en stock en la tienda indicada
    SELECT @stockDisponible = Saldo 
    FROM ELETiendaProducto
    WHERE CodTienda = @pCodigoTienda AND CodProducto = @pCodigoProducto;
    
    IF @stockDisponible >= @pCantidad
    BEGIN
        BEGIN TRANSACTION;  -- Iniciar transacción
        
        -- Insertar los valores de la factura en ELEFacturaEnc
        INSERT INTO ELEFacturaEnc (NumFactura, FecCompra, CodCliente, CodEmpleado, CodTienda, Total, FecEntrega, Estado)
        VALUES (@numFactura, @pFechaVenta, (SELECT CodCliente FROM ELEClientes WHERE Identificacion = @pIdentificacionCliente), @pCodigoEmpleado, @pCodigoTienda, (SELECT Precio * @pCantidad FROM ELEProductos WHERE CodProducto = @pCodigoProducto) - @pDescuento, @pFechaEntrega, 1);
        
        -- Insertar los detalles de la factura en ELEFacturasDet
        INSERT INTO ELEFacturasDet (NumFactura, CodItem, Cantidad, PrecioUnitario, Descuento, CodProducto)
        VALUES (@numFactura, 1, @pCantidad, (SELECT Precio FROM ELEProductos WHERE CodProducto = @pCodigoProducto), @pDescuento, @pCodigoProducto);
        
        -- Actualizar la cantidad en stock del producto en ELETiendaProducto
        UPDATE ELETiendaProducto
        SET Saldo = Saldo - @pCantidad
        WHERE CodTienda = @pCodigoTienda AND CodProducto = @pCodigoProducto;
        
        COMMIT;  -- Confirmar la transacción
        
        SELECT 'Venta registrada exitosamente.' AS Mensaje;
    END
    ELSE
    BEGIN
        SELECT 'Error: El producto no tiene suficiente stock en la tienda indicada.' AS Mensaje;
    END
END;

-- Ejemplo Venta con suficiente stock en la tienda
EXEC InsertarVenta 1, 2, '103220165', 4, 1, '2024-12-01 08:00:00', '2024-12-03 10:00:00', 0;

-- Ejemplo Venta sin suficiente stock en la tienda
EXEC InsertarVenta 2, 100000, '103220165', 4, 2, '2024-12-02 09:00:00', '2024-12-04 11:00:00', 0;


-- 2. Crear la función “MontoTotalComprasCliente”

CREATE FUNCTION MontoTotalComprasCliente
(
    @pIdentificacionCliente VARCHAR(25),
    @pFechaInicio DATETIME,
    @pFechaFin DATETIME
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @totalCompras DECIMAL(10,2);
    
    SELECT @totalCompras = SUM(Total)
    FROM ELEFacturaEnc
    WHERE CodCliente = (SELECT CodCliente FROM ELEClientes WHERE Identificacion = @pIdentificacionCliente)
    AND FecCompra >= @pFechaInicio
    AND FecCompra <= @pFechaFin;
    
    RETURN @totalCompras;
END;

-- Ejemplo de funcionalidad de la función
SELECT dbo.MontoTotalComprasCliente('103220236', '2018-01-16 00:00:00', '2024-12-01 08:00:00') AS TotalComprasCliente;

-- 3. Crear el procedimiento almacenado “ActualizarProducto”

CREATE PROCEDURE ActualizarProducto
    @p_CodProducto INT,
    @p_Descripcion VARCHAR(100),
    @p_Precio DECIMAL(10,0),
    @p_CodMarca SMALLINT,
    @p_CodCategoria SMALLINT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM ELEProductos WHERE CodProducto = @p_CodProducto)
    BEGIN
        UPDATE ELEProductos
        SET Descripcion = @p_Descripcion,
            Precio = @p_Precio,
            CodMarca = @p_CodMarca,
            CodCategoria = @p_CodCategoria
        WHERE CodProducto = @p_CodProducto;
        
        SELECT 'El producto ha sido actualizado correctamente.' AS Mensaje;
    END
    ELSE
    BEGIN
        SELECT 'El producto no existe en la base de datos.' AS Mensaje;
    END
END;

-- Insertar datos de prueba en la tabla de productos
INSERT INTO ELEProductos (CodProducto, Descripcion, Precio, CodMarca, CodCategoria)
VALUES (301, 'Producto prueba', 10.50, 1, 1);

-- Ejecutar el procedimiento almacenado para actualizar un producto existente
EXEC ActualizarProducto 
    @p_CodProducto = 301,
    @p_Descripcion = 'Producto Prueba Modificado',
    @p_Precio = 15.75,
    @p_CodMarca = 2,
    @p_CodCategoria = 2;

-- Verificar el resultado de la actualización
SELECT * FROM ELEProductos WHERE CodProducto = 301;

-- 4. Crear la función “StockTotalPorProducto”

CREATE FUNCTION StockTotalPorProducto (@p_CodProducto INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalStock INT;

    SELECT @TotalStock = SUM(Saldo)
    FROM ELETiendaProducto
    WHERE CodProducto = @p_CodProducto;

    RETURN @TotalStock;
END;


-- Ejemplo para verificar funcionalidad de la función
SELECT dbo.StockTotalPorProducto(30) AS StockTotalProducto1;