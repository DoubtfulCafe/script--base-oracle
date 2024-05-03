var express = require('express');
var sucursalEsquema = require('../models/sucursal.shcema');
const { default: mongoose } = require('mongoose');
// const { default: mongoose } = require('mongoose');

const obtenerSucursales = (req, res) => {
    sucursalEsquema.find().then((result) => {
        res.send(result);
        res.end();
    }).catch((error) =>{
        res.send(error);
        res.end();
    });
};

exports.obtenerSucursales = obtenerSucursales;

const obtenerUnaSucursal = (req, res) => {
    sucursalEsquema.find({id:req.params.id}).then((result) => {
        res.send(result[0]);
        res.end();
    }).catch((error) =>{
        res.send(error);
        res.end();
    });
};

exports.obtenerUnaSucursal = obtenerUnaSucursal;

const crearUnCliente = (req, res) => {
    let c = new sucursalEsquema(
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
    sucursalEsquema.updateOne({_id:req.params.id},
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
    sucursalEsquema.updateOne({_id:req.params.id},
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
    sucursalEsquema.updateOne({_id:req.params.id},
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