var express = require('express');
var afiliadoEsquema = require('../models/afiliado.schema');
const { default: mongoose } = require('mongoose');
var oraConecxion = require('../index')
// const { default: mongoose } = require('mongoose');

const tranferirAfiliados = async (req, res) => {
    try{
        const oradb = await oraConecxion.conectarOracle();

        const afiliadosArray = await afiliadoEsquema.find();

        const sql = `INSERT INTO afiliados(
                    id,
                    nombre_afiliado,
                    email,
                    telefono,
                    tipo_afiliado
                ) VALUES (
                    :id,
                    :nombre_afiliado,
                    :email,
                    :telefono,
                    :tipo_afiliado
                )`;

        
        for(const afiliado of afiliadosArray){


            const values = {
                id: afiliado.id,
                nombre_afiliado: afiliado.afiliado_name,
                email: afiliado.email,
                telefono: afiliado.telefono,
                tipo_afiliado: afiliado.tipo_afiliado
            }

            const result = await oradb.execute(sql, values);
            // console.log(result);
            await oradb.commit();
            await oradb.close();

            // if (result.rowsAffected && result.rowsAffected === 1) {
            //     console.log({ exito: true, mensaje: "Se pudo insertar" });
            // } else {
            //     console.log({ exito: false, mensaje: "No se pudo insertar" });
            // }
        };
    } catch (error) {
        console.error('Error:', error);

        if (oradb) {
            await oradb.rollback();
            console.log('Transacción deshecha');
        }
    } finally{
        // if (oradb) {
        //     await oradb.close();
        //     console.log('Conexión cerrada');
        // }
    }
};

exports.tranferirAfiliados = tranferirAfiliados;



const obtenerAfiliados = (req, res) => {
    afiliadoEsquema.find().then((result) => {
        res.send(result);
        res.end();
    }).catch((error) =>{
        res.send(error);
        res.end();
    });
};

exports.obtenerAfiliados = obtenerAfiliados;

const obtenerUnAfiliado = (req, res) => {
    afiliadoEsquema.find({id:req.params.id}).then((result) => {
        res.send(result[0]);
        res.end();
    }).catch((error) =>{
        res.send(error);
        res.end();
    });
};

exports.obtenerUnAfiliado = obtenerUnAfiliado;

const crearUnCliente = (req, res) => {
    let c = new afiliadoEsquema(
        {
            nombre: req.body.nombre,
            apellido: req.body.apellido,
            correo: req.body.correo,
            contraseña: req.body.contraseña,
            ordenes: req.body.ordenes
        }
    );
    c.save().then((result)=>{
        res.send(result);
        res.end();
    }).catch((error)=>{
        res.send(error);
        res.end();
    });
}

exports.crearUnCliente = crearUnCliente;

const agregardirOrden=(req, res)=>{
    afiliadoEsquema.updateOne({_id:req.params.id},
        {$push :{ ordenes: {
                _id:  new mongoose.Types.ObjectId(req.body.id),
                nombreE: req.body.nombreE,
                nombreP: req.body.nombreP, 
                valor: req.body.valor,
                cantidad: req.body.cantidad
        },
    }
        }).then((result)=>{
            res.send(result);
            res.end();
        }).catch((error)=>{
            res.send(error);
            res.end();
        });
}

exports.agregardirOrden = agregardirOrden;

const eliminarOrden=(req, res)=>{
    afiliadoEsquema.updateOne({_id:req.params.id},
        {$pull :{ ordenes: {
                _id:  new mongoose.Types.ObjectId(req.body.id),
                // nombreE: req.body.nombreE,
                // nombreP: req.body.nombreP, 
                // valor: req.body.valor,
                // cantidad: req.body.cantidad
        },
    }
        }).then((result)=>{
            res.send(result);
            res.end();
        }).catch((error)=>{
            res.send(error);
            res.end();
        });
}

exports.eliminarOrden = eliminarOrden;

const eliminarTodaOrden=(req, res)=>{
    afiliadoEsquema.updateOne({_id:req.params.id},
        {$unset :{ ordenes: ""}
        
        }).then((result)=>{
            res.send(result);
            res.end();
        }).catch((error)=>{
            res.send(error);
            res.end();
        });
}

exports.eliminarTodaOrden = eliminarTodaOrden;