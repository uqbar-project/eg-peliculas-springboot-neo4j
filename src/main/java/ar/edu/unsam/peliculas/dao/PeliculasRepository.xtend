package ar.edu.unsam.peliculas.dao

import ar.edu.unsam.peliculas.domain.Pelicula
import java.util.List
import org.springframework.data.neo4j.repository.query.Query
import org.springframework.data.repository.Repository
import org.springframework.stereotype.Service

@Service
interface PeliculasRepository extends Repository<Pelicula, Long>  {

	@Query("MATCH (pelicula:Movie) WHERE pelicula.title =~ $titulo RETURN pelicula")
	def List<Pelicula> peliculasPorTitulo(String titulo)

	@Query("MATCH (pelicula:Movie)<-[actuo_en:ACTED_IN]-(persona:Person) WHERE ID(pelicula) = $id RETURN pelicula, collect(actuo_en), collect(persona) LIMIT 1")
	def Pelicula pelicula(Long id)
	
  @Query("MATCH (pelicula:Movie) WHERE id(pelicula) = $pelicula.id SET pelicula.titulo = $pelicula.titulo RETURN pelicula")
	def Pelicula updatePelicula(Pelicula pelicula)
}
