package ar.edu.unsam.peliculas.domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.springframework.data.annotation.Id
import org.springframework.data.neo4j.core.schema.GeneratedValue
import org.springframework.data.neo4j.core.schema.Node
import org.springframework.data.neo4j.core.schema.Property

@Node("Person")
@Accessors
class Actor {
	@Id @GeneratedValue
	Long id

	@Property("name") // OJO, no es la Property de Xtend sino la de OGM
	String nombreCompleto
	
	@Property("born")
	int anioNacimiento
	
	override toString() {
		nombreCompleto
	}
}
