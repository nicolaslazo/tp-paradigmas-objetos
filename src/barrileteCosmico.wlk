class Localidad {
	var nombre
	var equipajeImprescindible
	var property precio
	var kilometro
	
	method nombre() = nombre
	method kilometro() = kilometro
	method esDestacado() = precio > 2000
	method esPeligroso() = equipajeImprescindible.any({equipaje => equipaje.contains("Vacuna") })
	method agregarCertificadoDescuento() = equipajeImprescindible.add("Certificado de descuento")
	method tieneEnEquipaje(unCoso) = equipajeImprescindible.contains(unCoso)
	
	method aplicarDescuento(unDescuento){ 
		precio = (precio - precio * (unDescuento / 100))
		self.agregarCertificadoDescuento()
	}
	
	method distanciaA(otraLocalidad) {
		var otroKilometro = otraLocalidad.kilometro()
		return (otroKilometro - kilometro).abs()
	}
}

class Montania inherits Localidad{
	var altura
	override method esDestacado() = true
	override method esPeligroso() = super().esPeligroso() && altura > 5000
}
class Playa inherits Localidad{
	override method esPeligroso() = false
}
class CiudadHistorica inherits Localidad{
	var museos
	override method esPeligroso() = equipajeImprescindible.any({equipaje => equipaje.contains("Seguro asistencia al viajero") }).negate()
	override method esDestacado() = super().esDestacado() && museos.count() > 3
}

class MedioDeTransporte {
	var costoPorKm
	var tiempo
	
	method costoEntreLocalidades(unosKilometros)= self.costoPorKm() * unosKilometros //#3
	method costoPorKm() = costoPorKm
	method tiempo() = tiempo
}

object micro inherits MedioDeTransporte{
	override method costoPorKm() = 5000	
}

class Avion inherits MedioDeTransporte{
	var turbinas
	override method costoPorKm() =  turbinas.sum({ turbina => turbina.nivelImpulso() })
}

class Turbina{
	var nivelImpulso
}

class Barco inherits MedioDeTransporte{
	var probabilidadChoque
	override method costoPorKm() =  probabilidadChoque * 1000
}

object tren inherits MedioDeTransporte{
	const multiplicadorMilla = 0.621371192237334
	override method costoPorKm() =  multiplicadorMilla * 2300
	
}



class Viaje{
	var localidadOrigen
	var localidadDestino
	var medioDeTransporte	
	
	method localidadOrigen() = localidadOrigen
	method localidadDestino() = localidadDestino
	
	method distanciaViaje() = localidadOrigen.distanciaA(localidadDestino)
	
	method precio() = medioDeTransporte.costoEntreLocalidades(self.distanciaViaje()) + localidadDestino.precio()
	
}

object barrileteCosmico {
	var localidades = []
	var mediosDeTransporte = []
	
	//TODO: revisar esto
	method armarUnViaje(unUsuario,unDestino) = { 
		var nuevoViaje = new Viaje()
		nuevoViaje.localidadOrigen(unUsuario.localidadOrigen())
		nuevoViaje.localidadDestino(unDestino)
		nuevoViaje.medioDeTransporte(localidades.get(0))	
		return nuevoViaje
	} //#8 o deberia estar aca el cambio?
	// deberia agregar esto a el metodo viajar dentro del usuario para que en viajes en vez de
	// quedar registrados destinos queden registrados viajes?
	
	method cartaDeDestinos() = localidades.map{ localidad => localidad.nombre() }.join()
	method esEmpresaExtrema() = self.destinosDestacados().any{localidad => localidad.esPeligroso()}
	method destinosDestacados() = localidades.filter{localidad => localidad.esDestacado()}
	method destinosPeligrosos() = localidades.filter{localidad => localidad.esPeligroso()}
	method destinos(unaLocalidad) = localidades.add(unaLocalidad)
	method destinos() = localidades
	
	method aplicarDescuentoADestinos(unDescuento) = localidades.forEach{destino => 
		destino.aplicarDescuento(unDescuento)		
	}
	
	method agregarMedioDeTransporte(unMedioDeTransporte) {
		mediosDeTransporte.add(unMedioDeTransporte)
	}
	
	method agregarLocalidad(unaLocalidad) {
		localidades.add(unaLocalidad)
	}
}


class Usuario {
	var userName
	var viajes
	var saldo
	var seguidos
	var localidadDeOrigen	
	var perfil
	var mochila
	
	method tieneSaldo(unDestino) = {
		if (saldo < unDestino.precio()) throw new Exception(message="Saldo insuficiente") else return true // De vuelta, no UserException?
	}
	method validarEquipajeImprecindible(unDestino){		
		if (self.tieneEquipajeImprecinfible(unDestino).negate()) throw new Exception(message="No tiene equipaje necesario") else return true // De vuelta, no UserException?
	}
	method tieneEquipajeImprecinfible(unDestino){
		return mochila.contains(unDestino.equipajeImprescindible())
	}
	
	method puedeViajar(unDestino) {		
		self.tieneSaldo(unDestino)
		self.validarEquipajeImprecindible(unDestino)
	}
	
	method viajar(viaje) {
		self.puedeViajar(viaje)
		viajes.add(viaje)
		saldo -= viaje.precio()
		localidadDeOrigen = viaje.localidadDeDestino() //#8
	}
	
	method seguirUsuario(usuario) {
		seguidos.add(usuario)
		usuario.followBack(self)
	}	
	
	method localidadDeOrigen() = localidadDeOrigen
	method kilometros() = viajes.sum({ viaje => viaje.distanciaViaje() }) //#8
	method followBack(usuario) = seguidos.add(usuario)
	method viajes() = viajes
	method saldo() = saldo
}
