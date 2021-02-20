# Ejemplo Películas con Springboot y Neo4J

[![Build Status](https://www.travis-ci.com/uqbar-project/eg-peliculas-springboot-neo4j.svg?token=sgTrpz74HU8UubV6ofCw&branch=master)](https://www.travis-ci.com/uqbar-project/eg-peliculas-springboot-neo4j)

## Objetivo

Testea el mapeo de una API que expone la [base de grafos de Películas que viene con Neo4J](https://neo4j.com/developer/example-project/).
## Modelo Neo4j

El ejemplo Movies que viene con Neo4j propone

* un nodo película (Movies)
* un nodo para cada actor (Person)
* y la relación entre ellos, marcada por el o los roles que cumplió cada actor en una película (ACTED_IN)

## Carga inicial de datos

Instalar previamente Neo4j o bien levantar una imagen de Docker

```bash
Instalar la última versión de Neo4j con Docker
docker pull neo4j:4.2.3
docker run \
     --publish=7474:7474 --publish=7687:7687 \
     --volume=$HOME/neo4j/data:/data \
     neo4j:4.2.3
```

- Abrir el Navegador de Neo4J Desktop o bien ingresar manualmente a la URL: http://localhost:7474
- Ejecutar el script que carga el grafo de películas (viene como ejemplo)

![script inicial](./video/scriptInicial.gif)

## Configuración

En el archivo [`application.yml`](./src/main/resources/application.yml) encontrarás la configuración hacia la base de grafos, que utiliza el protocolo liviano **bolt**:

```yml
spring:
  data:
    neo4j:
      uri: bolt://localhost:7687
      username: neo4j
      password: #####
logging:
  level:
    org.springframework.data: DEBUG
    org.neo4j: DEBUG
```

Algunas consideraciones:

- la contraseña por defecto cuando instalás Neo4J es **neo4j** pero a veces te obliga a cambiarla, acordate de cambiarla para conectarte correctamente
- el puerto por defecto para el protocolo bolt es 7687, igualmente eso se puede cambiar
- por defecto la aplicación hace un log bastante exhaustivo de conexiones y queries a la base, se puede desactivar subiendo el nivel a INFO, WARN o directamente borrando la línea

## Las consultas

### Películas por título

Para conocer las películas en donde un valor de búsqueda esté contenido en el título (sin distinguir mayúsculas o minúsculas), y limitando la búsqueda a los primeros 10 nodos, ejecutaremos esta consulta

```cypher
MATCH (pelicula:Movie) WHERE pelicula.title =~ '.*Good.*' RETURN pelicula LIMIT 10
```

La interfaz _Neo4jRepository_ de Spring boot nos permite declarativamente establecer las consultas a la base, y reemplazaremos el valor concreto '.*Good.*' por el parámetro que recibe el contrato:

```xtend
	@Query("MATCH (pelicula:Movie) WHERE pelicula.title =~ $titulo RETURN pelicula LIMIT 10")
	def List<Pelicula> peliculasPorTitulo(String titulo)
```

`$titulo` es la nueva forma de asociar el valor del parámetro `titulo` (hay que respetar los mismos nombres). Dado que queremos armar la expresión _contiene_, esto debemos hacerlo antes de llamar al repositorio, en este caso es el Controller (aunque a futuro podríamos pensar en tener un `@Service` que cumpla este rol):

```xtend
	@GetMapping("/peliculas/{titulo}")
	def getPeliculasPorTitulo(@PathVariable String titulo) {
		val tituloABuscar = '''(?i).*«titulo».*'''
		peliculasRepository.peliculasPorTitulo(tituloABuscar)
	}
```

En este caso solo queremos traer el nodo película, sin sus relaciones, por lo que el endpoint devuelve una lista de personajes vacía. Esto mejora la performance de la consulta aunque hay que exponer esta decisión a quien consuma nuestra API.
### Ver los datos de una película concreta

Cuando nos pasen un identificador de una película concreta, ahora sí queremos traer los datos de la película, más sus personajes y eso incluye los datos de cada uno de sus actores:

```cypher
MATCH (pelicula:Movie)<-[actuo_en:ACTED_IN]-(persona:Person) WHERE ID(pelicula) = $id RETURN pelicula, collect(actuo_en), collect(persona) LIMIT 1
```

Es importante utilizar la instrucción [`collect`](https://neo4j.com/docs/cypher-manual/current/functions/aggregating/#functions-collect) para que agrupe correctamente los personajes y los actores.

### Actualizaciones a una película

Es interesante ver que el controller delega la creación, actualización o eliminación al repositorio:

```xtend
	@PostMapping("/pelicula")
	def createPelicula(@RequestBody Pelicula pelicula) {
		peliculasRepository.save(pelicula)
	}

	@DeleteMapping("/pelicula/{id}")
	def deletePelicula(@RequestBody Pelicula pelicula) {
		peliculasRepository.delete(pelicula)
	}
```

pero que esos métodos ni siquiera es necesario que los defina nuestra interfaz, porque ya están siendo inyectados por la interfaz Neo4jRepository (la declaratividad en su máxima expresión). El motor, en este caso Spring boot, persiste el nodo película y [cualquier relación hasta el nivel de profundidad 5 que no entre en referencia circular](https://community.neo4j.com/t/repository-save-find-depth/15181). Anteriormente, existía un SessionManager donde podíamos tener un mayor control de la información que actualizábamos o recuperábamos: para algunos esto puede ser una desventaja, contra lo bueno que puede suponer delegar esa responsabilidad en un algoritmo optimizado.

## Mapeos

Mostraremos a continuación cómo es el mapeo de las películas (las anotaciones a partir de las últimas versiones de Neo4J 4.2.x cambiaron ligeramente)

```xtend
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
```

Para profundizar más recomendamos ver los otros objetos de dominio en este ejemplo y [la página de mapeos de Neo4j - Spring boot](https://docs.spring.io/spring-data/neo4j/docs/current/reference/html/#mapping)

## Sobre los identificadores

Por motivos didácticos hemos mantenido un ID Long que es el que genera Neo4J para sus nodos, aunque [**no resulta una buena estrategia**](https://stackoverflow.com/questions/27336536/reuse-of-deleted-nodes-ids-in-neo4j), ya que cuando eliminamos nodos, Neo4j reutiliza esos identificadores para los nodos nuevos. Recomendamos investigar mecanismos alternativos para generar claves primarias, o bien tener como estrategia el borrado lógico y no físico.

## Tests de integración

Elegimos hacer tests de integración sobre el repositorio, podríamos a futuro incluir al controller, pero dado que no tiene demasiada lógica por el momento estamos bien manteniendo tests más simples. Los casos de prueba que vamos a desarrollar son:

- la búsqueda de películas, donde validaremos que se puede encontrar por "título contiene" sin distinguir mayúsculas o minúsculas y que además no trae los personajes
- la búsqueda puntual de una película que debe traer los personajes. La forma de buscar por id requiere que luego de enviar el mensaje `save` guardemos el nuevo estado de la película persistida, que tiene el identificador que el container de SDN (Spring Data Neo4J) le dio.

```xtend
	@Test
	@DisplayName("la búsqueda por título funciona correctamente")
	def void testPeliculasPorTitulo() {
		val peliculas = peliculasRepository.peliculasPorTitulo('''(?i).*nueve.*''')
		assertEquals(1, peliculas.size)
		assertEquals(#[], peliculas.head.personajes)
	}

	@Test
	@DisplayName("la búsqueda de una película trae los datos de la película y sus perosonajes")
	def void testPeliculaConcreta() {
		val pelicula = peliculasRepository.pelicula(nueveReinas.id)
		assertEquals("Nueve reinas", pelicula.titulo)
		assertEquals(2, pelicula.personajes.size)
		val darin = pelicula.personajes.head
		assertEquals("Marcos", darin.roles.head)
	}
```

Para profundizar más en el tema recomendamos leer [esta página](https://medium.com/neo4j/testing-your-neo4j-based-java-application-34bef487cc3c)