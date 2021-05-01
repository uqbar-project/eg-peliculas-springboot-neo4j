package ar.edu.unsam.peliculas.domain

import ar.edu.unsam.peliculas.errorHandling.UserException
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.springframework.data.neo4j.core.schema.RelationshipProperties
import org.springframework.data.neo4j.core.schema.TargetNode

@RelationshipProperties
@Accessors
class Personaje {
	// @Id @GeneratedValue Long id
	List<String> roles

	@TargetNode
	Actor actor

	def rolesMostrables() {
		if (roles.isEmpty) {
			return ""
		}
		val rolesAsString = roles.toString
		rolesAsString.substring(1, rolesAsString.length - 1)	
	}
	
	override toString() {
		rolesMostrables + " por " + actor.toString
	}
	
	def void validar() {
		if (this.roles === null || this.roles.isEmpty) {
			throw new UserException("Debe ingresar al menos un rol para el personaje")
		}
		if (this.actor === null) {
			throw new UserException("Debe ingresar qué actor cumple ese personaje")
		}
	}
	
}
