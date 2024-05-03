var mongoose = require('mongoose');

var esquema = new mongoose.Schema({
    id: Number,
    calle: String,
    departamento: String,
    ciudad: String,
    afiliado_id: Number,
});

module.exports = mongoose.model('sucursales', esquema);