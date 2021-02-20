package ar.edu.unsam.peliculas

import ar.edu.unsam.peliculas.dao.PeliculasRepository
import ar.edu.unsam.peliculas.domain.Pelicula
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
	
	@BeforeEach
	def void init() {
		val nueveReinas = peliculasRepository.save(new Pelicula => [
			titulo = "Nueve reinas"
			frase = "Dos estafadores, una mujer... y mucho dinero"
			anio = 1998
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
	}
}