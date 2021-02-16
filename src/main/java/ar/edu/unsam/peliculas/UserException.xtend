package ar.edu.unsam.peliculas

import java.lang.RuntimeException

class UserException extends RuntimeException {
	
	new(String message) { super(message) }
}