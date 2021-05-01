package ar.edu.unsam.peliculas.domain

import ar.edu.unsam.peliculas.errorHandling.UserException
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.springframework.data.neo4j.core.schema.GeneratedValue
import org.springframework.data.neo4j.core.schema.Id
import org.springframework.data.neo4j.core.schema.Node
import org.springframework.data.neo4j.core.schema.Property
import org.springframework.data.neo4j.core.schema.Relationship
import org.springframework.data.neo4j.core.schema.Relationship.Direction

// https://docs.spring.io/spring-data/neo4j/docs/current/reference/html/#mapping
@Node("Movie")
@Accessors
class Pelicula {
	static int MINIMO_VALOR_ANIO = 1900
	
	@Id @GeneratedValue
	Long id

	@Property(name="title") // OJO, no es la property de xtend sino la de OGM
	String titulo
	
	@Property("tagline")
	String frase
	
	@Property("released")
	Integer anio
	
	@Relationship(type = "ACTED_IN", direction = Direction.INCOMING)
	List<Personaje> personajes = new ArrayList<Personaje>
	
	override toString() {
		titulo + " (" + anio + ")" 
	}
	
	def agregarPersonaje(String _roles, Actor _actor) {
		val personaje = new Personaje() => [
					roles = #[_roles]
					actor = _actor
				]
		personaje.validar
		personajes.add(personaje)
	}
	
	def eliminarPersonaje(Personaje personaje) {
		personajes.remove(personaje)
	}
	
	def void validar() {
		if (this.titulo === null || this.titulo.trim.equals("")) {
			throw new UserException("Debe ingresar un título")
		}
		if (this.anio <= MINIMO_VALOR_ANIO) {
			throw new UserException("El año debe ser mayor a " + MINIMO_VALOR_ANIO)
		}
		personajes.forEach [ personaje | personaje.validar ]
	}
}