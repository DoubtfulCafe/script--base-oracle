var mongoose = require('mongoose');

var esquema = new mongoose.Schema({
    id: Number,
    nombre_producto: String,
    categoria: String,
    precio: Number,
    sucursal_id : Number,
});

module.exports = mongoose.model('productos', esquema);