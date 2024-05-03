var express = require('express');
var productosController = require('../controllers/productos.controller');
var router = express.Router();

router.get('/', productosController.obtenerProductos);
router.get('/:id', productosController.obtenerUnProducto);
router.post('/', productosController.crearUnCliente);
router.put('/:id/ordenes', productosController.agregardirOrden);
router.put('/:id/orden', productosController.eliminarOrden); 
router.put('/:id/adiosorden',productosController.eliminarTodaOrden);

module.exports = router;