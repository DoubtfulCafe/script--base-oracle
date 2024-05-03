var express = require('express');
var afiliadosController = require('../controllers/afiliados.controller');
var router = express.Router();

router.get('/', afiliadosController.obtenerAfiliados);
router.get('/:id', afiliadosController.obtenerUnAfiliado);
router.post('/', afiliadosController.crearUnCliente);
router.put('/:id/ordenes', afiliadosController.agregardirOrden);
router.put('/:id/orden', afiliadosController.eliminarOrden); 
router.put('/:id/adiosorden',afiliadosController.eliminarTodaOrden);

module.exports = router;