var mongoose = require('mongoose');
// var afiliadosController = require('../controllers/afiliados.controller');
var etlController = require('../controllers/etl.controller');

let bd = 'proyectoairbnb';
let port = '27017';
let host = '127.0.0.1';

class Database{
    constructor(){
        this.conectar();
    }

    conectar(){
        mongoose.connect(`mongodb://${host}:${port}/${bd}`)
        .then(result=>{console.log('Se conecto a mongodb');
            etlController.etl_transferir_datos();
        }).catch(error=>{
            console.log('no se pudo conectar a mongodb');
        });

    }
}

module.exports = new Database();