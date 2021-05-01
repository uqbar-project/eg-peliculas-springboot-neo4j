package ar.edu.unsam.peliculas.controller

import ar.edu.unsam.peliculas.service.ActorService
import io.swagger.annotations.ApiOperation
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin(origins="*")
class ActorController {

	@Autowired
	ActorService actorService
	
	@GetMapping("/actores/{filtroBusqueda}")
	@ApiOperation("Devuelve una lista de actores cuyo nombre esté contenido en un valor de búsqueda, sin distinguir mayúsculas de minúsculas. Si por ejemplo se busca 'IT', puede devolver actores como 'Brad Pitt'.")
	def getActores(@PathVariable String filtroBusqueda) {
		actorService.buscarActores(filtroBusqueda)
	}

}
