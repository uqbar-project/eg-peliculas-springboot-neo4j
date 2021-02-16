package ar.edu.unsam.peliculas.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController
import ar.edu.unsam.peliculas.dao.PeliculasRepository

@RestController
@CrossOrigin(origins="*")
class PeliculasController {

	@Autowired
	PeliculasRepository peliculasRepository

	@GetMapping("/peliculas/{titulo}")
	def getPeliculasPorTitulo(@PathVariable String titulo) {
		val tituloABuscar = '''(?i).*«titulo».*'''
		peliculasRepository.peliculasPorTitulo(tituloABuscar)
	}

	@GetMapping("/pelicula/{id}")
	def getPelicula(@PathVariable Long id) {
		peliculasRepository.pelicula(id)
	}
	
}
