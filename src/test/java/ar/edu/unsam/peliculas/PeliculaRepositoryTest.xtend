package ar.edu.unsam.peliculas

import ar.edu.unsam.peliculas.dao.PeliculasRepository
import ar.edu.unsam.peliculas.domain.Actor
import ar.edu.unsam.peliculas.domain.Pelicula
import ar.edu.unsam.peliculas.domain.Personaje
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.data.neo4j.AutoConfigureDataNeo4j
import org.springframework.boot.test.autoconfigure.data.neo4j.DataNeo4jTest
import org.testcontainers.junit.jupiter.Testcontainers

import static org.junit.Assert.assertEquals

@Testcontainers
@AutoConfigureDataNeo4j
@DataNeo4jTest
@DisplayName("Dada una lista de películas")
class PeliculaRepositoryTest {

	@Autowired
	PeliculasRepository peliculasRepository
	
	Pelicula nueveReinas
	
	@BeforeEach
	def void init() {
		val darin = new Actor => [
			nombreCompleto = "Ricardo Darín"
			anioNacimiento = 1957
		]
		nueveReinas = peliculasRepository.save(new Pelicula => [
			titulo = "Nueve reinas"
			frase = "Dos estafadores, una mujer... y mucho dinero"
			anio = 1998
			personajes = #[
				new Personaje => [
					roles = #["Marcos"]
					actor = darin
				],
				new Personaje => [
					roles = #["Juan"]
					actor = new Actor => [
						nombreCompleto = "Gastón Pauls"
						anioNacimiento = 1972
					]
				]
			]
		])
		peliculasRepository.save(new Pelicula => [
			titulo = "Tiempo de valientes"
			frase = "Los tiempos cambian. Los héroes también."
			anio = 2005
		])
	}
	
	@Test
	@DisplayName("la búsqueda por título funciona correctamente")
	def void testPeliculasPorTitulo() {
		val peliculas = peliculasRepository.peliculasPorTitulo('''(?i).*nueve.*''')
		assertEquals(1, peliculas.size)
		assertEquals(#[], peliculas.head.personajes)
	}

	@Test
	@DisplayName("la búsqueda de una película trae los datos de la película y sus personajes")
	def void testPeliculaConcreta() {
		val pelicula = peliculasRepository.pelicula(nueveReinas.id)
		assertEquals("Nueve reinas", pelicula.titulo)
		assertEquals(2, pelicula.personajes.size)
		val darin = pelicula.personajes.findFirst [ actor.nombreCompleto.equalsIgnoreCase("Ricardo Darín")]
		assertEquals("Marcos", darin.roles.head)
	}

}