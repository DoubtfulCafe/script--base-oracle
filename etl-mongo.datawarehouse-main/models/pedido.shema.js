var mongoose = require('mongoose');

var esquema = new mongoose.Schema({
    id: Number,
    id_reserva: Number,
    fecha_pedido: String,
    prductos: Array,
});

module.exports = mongoose.model('pedidos', esquema);