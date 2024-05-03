var express = require('express');
var sucursalesController = require('../controllers/sucursales.controller');
var router = express.Router();

router.get('/', sucursalesController.obtenerSucursales);
router.get('/:id', sucursalesController.obtenerUnaSucursal);
router.post('/', sucursalesController.crearUnCliente);
router.put('/:id/ordenes', sucursalesController.agregardirOrden);
router.put('/:id/orden', sucursalesController.eliminarOrden); 
router.put('/:id/adiosorden',sucursalesController.eliminarTodaOrden);

module.exports = router;