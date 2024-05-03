var express = require('express');
var clientesController = require('../controllers/clientes.controller');
var router = express.Router();

router.get('/', clientesController.obtenerClientes);
router.get('/:id', clientesController.obtenerUnCliente);
router.post('/', clientesController.crearUnCliente);
router.put('/:id/ordenes', clientesController.agregardirOrden);
router.put('/:id/orden', clientesController.eliminarOrden); 
router.put('/:id/adiosorden',clientesController.eliminarTodaOrden);

module.exports = router;