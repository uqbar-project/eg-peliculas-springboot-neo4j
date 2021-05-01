package ar.edu.unsam.peliculas.service

import ar.edu.unsam.peliculas.dao.ActoresRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import static extension ar.edu.unsam.peliculas.service.CipherUtils.*

@Service
class ActorService {
	@Autowired
	ActoresRepository actoresRepository
	
	def buscarActores(String nombreABuscar) {
		actoresRepository.actores(nombreABuscar.contiene)
	}

		
}