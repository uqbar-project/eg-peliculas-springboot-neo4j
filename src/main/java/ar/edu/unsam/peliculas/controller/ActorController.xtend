package ar.edu.unsam.peliculas.controller

import ar.edu.unsam.peliculas.dao.ActoresRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin(origins="*")
class ActorController {

	@Autowired
	ActoresRepository actoresRepository

	@GetMapping("/actores/{filtroBusqueda}")
	def getActores(@PathVariable String filtroBusqueda) {
		val nombreABuscar = '''(?i).*«filtroBusqueda».*'''
		actoresRepository.actores(nombreABuscar)
	}

}
