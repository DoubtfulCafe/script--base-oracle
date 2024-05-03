
// Configuración de la conexión a Oracle
const config = {
    user: 'C##SAUL',
    password: 'oracle',
    connectString: 'localhost/xe'
};

module.exports = config;

// Realizar la conexión
// const oraConectar = ()=>{
//     oracledb.getConnection(config, (err, connection) => {
//         if (err) {
//             console.error('Error al conectar a Oracle:', err);
//             return;
//         }

//         console.log('Conectado exitosamente a Oracle');

//         // Aquí puedes realizar operaciones en tu base de datos Oracle
//     });
// }

