package ar.edu.unsam.peliculas.controller

import ar.edu.unsam.peliculas.dao.PeliculasRepository
import ar.edu.unsam.peliculas.domain.Pelicula
import io.swagger.annotations.ApiOperation
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin(origins="*")
class PeliculasController {

	@Autowired
	PeliculasRepository peliculasRepository

	@GetMapping("/peliculas/{titulo}")
	@ApiOperation("Permite conocer películas cuyo título contiene un valor a buscar, sin considerar mayúsculas o minúsculas. Por ejemplo, si se busca 'MATR' puede devolver películas como 'Matrix', 'Matrix 2', 'Matrix 3'.")
	def getPeliculasPorTitulo(@PathVariable String titulo) {
		val tituloABuscar = '''(?i).*«titulo».*'''
		peliculasRepository.peliculasPorTitulo(tituloABuscar)
	}

	@GetMapping("/pelicula/{id}")
	@ApiOperation("Dado un identificador de película, devuelve la información de una película con sus personajes (y actores que los representan).")
	def getPelicula(@PathVariable Long id) {
		peliculasRepository.pelicula(id)
	}

	@PutMapping("/pelicula/{id}")
	@ApiOperation("Permite actualizar una película con sus personajes asociados.")
	def updatePelicula(@RequestBody Pelicula pelicula) {
		peliculasRepository.save(pelicula)
	}

	@PostMapping("/pelicula")
	@ApiOperation("Permite crear una nueva película con sus personajes.")
	def createPelicula(@RequestBody Pelicula pelicula) {
		peliculasRepository.save(pelicula)
	}

	@DeleteMapping("/pelicula/{id}")
	@ApiOperation("Permite eliminar una película del sistema, esto incluirá a sus personajes (pero no a sus actores que tienen un ciclo de vida diferente).")
	def deletePelicula(@RequestBody Pelicula pelicula) {
		peliculasRepository.delete(pelicula)
	}

}
