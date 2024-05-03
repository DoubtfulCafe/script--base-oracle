var mongoose = require('mongoose');

var esquema = mongoose.Schema({
    id: Number,
    pedido_id: Number,
    id_usuario: Number,
    id_empresa: Number,
    subtotal: Number,
    impuesto: String,
    total: Number,
    fecha: String,
});

module.exports = mongoose.model('facturas', esquema);