package ar.edu.unsam.peliculas.service

import ar.edu.unsam.peliculas.dao.PeliculasRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import static extension ar.edu.unsam.peliculas.service.CipherUtils.*
import ar.edu.unsam.peliculas.domain.Pelicula

@Service
class PeliculaService {

	@Autowired
	PeliculasRepository peliculasRepository
	
	def buscarPorTitulo(String titulo) {
		peliculasRepository.peliculasPorTitulo(titulo.contiene)
	}
	
	def buscarPorId(Long id) {
		peliculasRepository.pelicula(id)
	}
	
	def guardar(Pelicula pelicula) {
		peliculasRepository.save(pelicula)
	}
	
	def eliminar(ar.edu.unsam.peliculas.domain.Pelicula pelicula) {
		peliculasRepository.delete(pelicula)
	}
	
}