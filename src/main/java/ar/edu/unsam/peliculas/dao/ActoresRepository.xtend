package ar.edu.unsam.peliculas.dao

import ar.edu.unsam.peliculas.domain.Actor
import java.util.List
import org.springframework.data.neo4j.repository.query.Query
import org.springframework.data.repository.Repository
import org.springframework.stereotype.Service

@Service
interface ActoresRepository extends Repository<Actor, Long>  {

	@Query("MATCH (actor:Person) WHERE actor.name =~ $nombreABuscar RETURN actor LIMIT 5")
	def List<Actor> actores(String nombreABuscar)

}
