var express = require('express');
var facturasController = require('../controllers/facturas.controller');
var router = express.Router();

router.get('/', facturasController.obtenerFacturas);
router.get('/:id', facturasController.obtenerUnaFactura);
// router.post('/', facturasController.crearUnCliente);
// router.put('/:id/ordenes', facturasController.agregardirOrden);
// router.put('/:id/orden', facturasController.eliminarOrden); 
// router.put('/:id/adiosorden',facturasController.eliminarTodaOrden);

module.exports = router;