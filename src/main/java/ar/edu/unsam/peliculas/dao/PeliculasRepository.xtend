package ar.edu.unsam.peliculas.dao

import ar.edu.unsam.peliculas.domain.Pelicula
import java.util.List
import org.springframework.data.neo4j.repository.Neo4jRepository
import org.springframework.data.neo4j.repository.query.Query
import org.springframework.stereotype.Repository

@Repository
interface PeliculasRepository extends Neo4jRepository<Pelicula, Long>  {

	@Query("MATCH (pelicula:Movie) WHERE pelicula.title =~ $titulo RETURN pelicula LIMIT 10")
	def List<Pelicula> peliculasPorTitulo(String titulo)

	@Query("MATCH (pelicula:Movie)<-[actuo_en:ACTED_IN]-(persona:Person) WHERE ID(pelicula) = $id RETURN pelicula, collect(actuo_en), collect(persona) LIMIT 1")
	def Pelicula pelicula(Long id)
	
}
