package ar.edu.unsam.peliculas.controller

import ar.edu.unsam.peliculas.dao.PeliculasRepository
import ar.edu.unsam.peliculas.domain.Pelicula
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

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

	@PutMapping("/pelicula/{id}")
	def updatePelicula(@RequestBody Pelicula pelicula) {
		peliculasRepository.updatePelicula(pelicula)
	}
}
