var express = require('express');
var pedidosController = require('../controllers/pedidos.controller');
var router = express.Router();

router.get('/', pedidosController.obtenerPedidos);
router.get('/:id', pedidosController.obtenerUnPedido);
router.post('/', pedidosController.crearUnCliente);
router.put('/:id/ordenes', pedidosController.agregardirOrden);
router.put('/:id/orden', pedidosController.eliminarOrden); 
router.put('/:id/adiosorden',pedidosController.eliminarTodaOrden);

module.exports = router;