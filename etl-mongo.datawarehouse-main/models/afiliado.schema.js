var mongoose = require('mongoose');

var esquema = new mongoose.Schema({
    id: Number,
    afiliado_name: String,
    email: String,
    telefono: String,
    tipo_afiliado: String,
});

module.exports = mongoose.model('afiliados', esquema);