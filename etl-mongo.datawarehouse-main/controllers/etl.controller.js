var express = require('express');

//modelos que se requieren para el etl
var afiliadoEsquema = require('../models/afiliado.schema');
var sucursalEsquema = require('../models/sucursal.shcema');
var productoEsquema = require('../models/producto.shcema');
var pedidoEsquema = require('../models/pedido.shema');

const { default: mongoose } = require('mongoose');
var oraConecxion = require('../index')
// const { default: mongoose } = require('mongoose');


// este es el etl que transferira los datos de mongo a data wareouse
const etl_transferir_datos = async (req, res) => {
    try{
        const oradb = await oraConecxion.conectarOracle();

        
        // id: {"$gt": 990}
        
        const pedidosArray = await pedidoEsquema.find();

        const sql = `INSERT INTO servicio_comidas_ventas (
                        id_ser_com_ven,
                        id_pedido,
                        id_reserva,
                        id_producto,
                        nombre_producto,
                        precio,
                        categoria,
                        cantidad,
                        id_sucursal,
                        ciudad,
                        departamento,
                        id_afiliado,
                        nombre_afiliado,
                        tipo_afiliado,
                        fecha_registro
                    ) VALUES (
                        sqc_ID_SER_COM_VEN.NEXTVAL,
                        :id_pedido,
                        :id_reserva,
                        :id_producto,
                        :nombre_producto,
                        :precio,
                        :categoria,
                        :cantidad,
                        :id_sucursal,
                        :ciudad,
                        :departamento,
                        :id_afiliado,
                        :nombre_afiliado,
                        :tipo_afiliado,
                        sysdate
                    )`;

                    


                    // fecha_pedido,
                    // :fecha_pedido,
        for(const pedido of pedidosArray){
            
            for(const productoPedido of pedido.prductos){

                const unProducto = await productoEsquema.find({id: productoPedido.producto_id});
                const unaSucursal = await sucursalEsquema.find({id: unProducto[0].sucursal_id});
                const unAfiliado = await afiliadoEsquema.find({id: unaSucursal[0].afiliado_id});

                const values = {
                    id_pedido: pedido.id,
                    id_reserva: pedido.id_reserva,
                    id_producto: productoPedido.producto_id,
                    nombre_producto: unProducto[0].nombre_producto,
                    precio: unProducto[0].precio,
                    categoria: unProducto[0].categoria,
                    cantidad: productoPedido.cantidad,
                    id_sucursal: unProducto[0].sucursal_id,
                    ciudad: unaSucursal[0].ciudad,
                    departamento: unaSucursal[0].departamento,
                    id_afiliado: unaSucursal[0].afiliado_id,
                    nombre_afiliado: unAfiliado[0].afiliado_name,
                    tipo_afiliado: unAfiliado[0].tipo_afiliado
                };

                // console.log(values);

                const result = await oradb.execute(sql, values);
                console.log(result);
                
                await oradb.commit();

            }


            
            // // console.log(result);
            
            

        };

        await oradb.close();
    } catch (error) {
        console.error('Error:', error);

        // if (oradb) {
        //     await oradb.rollback();
        //     console.log('Transacción deshecha');
        // }
    } finally{
        // if (oradb) {
        //     await oradb.close();
        //     console.log('Conexión cerrada');
        // }
    }
};

exports.etl_transferir_datos = etl_transferir_datos;



// const obtenerAfiliados = (req, res) => {
//     afiliadoEsquema.find().then((result) => {
//         res.send(result);
//         res.end();
//     }).catch((error) =>{
//         res.send(error);
//         res.end();
//     });
// };

// exports.obtenerAfiliados = obtenerAfiliados;

// const obtenerUnAfiliado = (req, res) => {
//     afiliadoEsquema.find({id:req.params.id}).then((result) => {
//         res.send(result[0]);
//         res.end();
//     }).catch((error) =>{
//         res.send(error);
//         res.end();
//     });
// };

// exports.obtenerUnAfiliado = obtenerUnAfiliado;

// const crearUnCliente = (req, res) => {
//     let c = new afiliadoEsquema(
//         {
//             nombre: req.body.nombre,
//             apellido: req.body.apellido,
//             correo: req.body.correo,
//             contraseña: req.body.contraseña,
//             ordenes: req.body.ordenes
//         }
//     );
//     c.save().then((result)=>{
//         res.send(result);
//         res.end();
//     }).catch((error)=>{
//         res.send(error);
//         res.end();
//     });
// }

// exports.crearUnCliente = crearUnCliente;

// const agregardirOrden=(req, res)=>{
//     afiliadoEsquema.updateOne({_id:req.params.id},
//         {$push :{ ordenes: {
//                 _id:  new mongoose.Types.ObjectId(req.body.id),
//                 nombreE: req.body.nombreE,
//                 nombreP: req.body.nombreP, 
//                 valor: req.body.valor,
//                 cantidad: req.body.cantidad
//         },
//     }
//         }).then((result)=>{
//             res.send(result);
//             res.end();
//         }).catch((error)=>{
//             res.send(error);
//             res.end();
//         });
// }

// exports.agregardirOrden = agregardirOrden;

// const eliminarOrden=(req, res)=>{
//     afiliadoEsquema.updateOne({_id:req.params.id},
//         {$pull :{ ordenes: {
//                 _id:  new mongoose.Types.ObjectId(req.body.id),
//                 // nombreE: req.body.nombreE,
//                 // nombreP: req.body.nombreP, 
//                 // valor: req.body.valor,
//                 // cantidad: req.body.cantidad
//         },
//     }
//         }).then((result)=>{
//             res.send(result);
//             res.end();
//         }).catch((error)=>{
//             res.send(error);
//             res.end();
//         });
// }

// exports.eliminarOrden = eliminarOrden;

// const eliminarTodaOrden=(req, res)=>{
//     afiliadoEsquema.updateOne({_id:req.params.id},
//         {$unset :{ ordenes: ""}
        
//         }).then((result)=>{
//             res.send(result);
//             res.end();
//         }).catch((error)=>{
//             res.send(error);
//             res.end();
//         });
// }

// exports.eliminarTodaOrden = eliminarTodaOrden;