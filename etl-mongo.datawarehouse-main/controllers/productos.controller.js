var express = require('express');
var productoEsquema = require('../models/producto.shcema');
const { default: mongoose } = require('mongoose');
// const { default: mongoose } = require('mongoose');

const obtenerProductos = (req, res) => {
    productoEsquema.find().then((result) => {
        res.send(result);
        res.end();
    }).catch((error) =>{
        res.send(error);
        res.end();
    });
};

exports.obtenerProductos = obtenerProductos;

const obtenerUnProducto = (req, res) => {
    productoEsquema.find({id:req.params.id}).then((result) => {
        res.send(result[0]);
        res.end();
    }).catch((error) =>{
        res.send(error);
        res.end();
    });
};

exports.obtenerUnProducto = obtenerUnProducto;

const crearUnCliente = (req, res) => {
    let c = new productoEsquema(
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
    productoEsquema.updateOne({_id:req.params.id},
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
    productoEsquema.updateOne({_id:req.params.id},
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
    productoEsquema.updateOne({_id:req.params.id},
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