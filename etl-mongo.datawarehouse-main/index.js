var express = require('express');
var oracledb = require('oracledb');
var BD = require('./utils/dboracle');
var bodyParser = require('body-parser');
var cors = require('cors');
var database = require('./utils/database');
// var oradatabase = require('./utils/dboracle');

var afiliadosRouter = require('./routers/afiliado-router');
var sucursalesRouter = require('./routers/sucursal-router');
var productosRouter = require('./routers/producto-router');
var pedidosRouter = require('./routers/pedido-router');
var facturasRouter = require('./routers/factura-router');

// var clientesRouter = require('./routers/cliente-router');
// var restaurantesRouter = require('./routers/restaurante-router');
// var ordenesRouter = require('./routers/orden-router');
// var motoristasRouter = require('./routers/motorista-router');
// var administradoresRouter = require('./routers/administrador-router');

var app = express();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));

app.use('/afiliados', afiliadosRouter);
app.use('/sucursales', sucursalesRouter);
app.use('/productos', productosRouter);
app.use('/pedidos', pedidosRouter);
app.use('/facturas', facturasRouter);

// app.use('/clientes', clientesRouter);
// app.use('/restaurantes', restaurantesRouter);
// app.use('/ordenes', ordenesRouter);
// app.use('/motoristas', motoristasRouter);
// app.use('/administradores', administradoresRouter)

app.listen(2024, function(){
    console.log('se levanto el servidor');
});

async function conectarOracle() {
    try {
        // Obtener la conexión
        const connection = await oracledb.getConnection(BD);
        console.log('Conexión exitosa a Oracle');

        // Aquí puedes realizar operaciones en tu base de datos Oracle utilizando la conexión

        // Por ejemplo, puedes ejecutar una consulta
        // const result = await connection.execute('SELECT * FROM tu_tabla');
        // console.log('Resultado de la consulta:', result.rows);

        // Importante: no olvides liberar la conexión cuando hayas terminado
        // await connection.close();
        // console.log('Conexión cerrada');
        return connection;
    } catch (err) {
        console.error('Error al conectar a Oracle:', err);
    }
};

exports.conectarOracle = conectarOracle;

// Llamar a la función para conectar a Oracle
// conectarOracle();

