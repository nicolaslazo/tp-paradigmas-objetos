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
		return self.agregarCertificadoDescuento()
	}
	
	method distanciaA(otraLocalidad) {
		var otroKilometro = otraLocalidad.kilometro()
		return (otroKilometro - kilometro).abs()
	}
}

class MedioDeTransporte {
	var costoPorKm
	var tiempo
	
	method costoPorKm() = costoPorKm
	method tiempo() = tiempo
}

class Viaje{
	var property localidadOrigen
	var localidadDestino
	var medioDeTransporte	
	
	method precio() = localidadDestino.precio() + localidadOrigen.distanciaA(localidadDestino) * medioDeTransporte.costoPorKm()	

	method localidadDestino(unDestino){
		localidadDestino = unDestino
	}
	
	method medioDeTransporte(unMedioDeTransporte){
		medioDeTransporte = (unMedioDeTransporte)
	}
}

object barrileteCosmico {
	var localidades = []
	var mediosDeTransporte = []

	method armarUnViaje(unUsuario,unDestino){ 
		var nuevoViaje = new Viaje()
		nuevoViaje.localidadOrigen(unUsuario.localidadDeOrigen())
		nuevoViaje.localidadDestino(unDestino)
		nuevoViaje.medioDeTransporte(mediosDeTransporte.anyOne())	
		return nuevoViaje
	}

	
	method cartaDeDestinos() = localidades.map{ localidad => localidad.nombre() }.join()
	method esEmpresaExtrema() = self.destinosDestacados().any{localidad => localidad.esPeligroso()}
	method destinosDestacados() = localidades.filter{localidad => localidad.esDestacado()}
	method destinosPeligrosos() = localidades.filter{localidad => localidad.esPeligroso()}
	method destinos(unaLocalidad) = localidades.add(unaLocalidad)
	method destinos() = localidades
	
	method aplicarDescuentoADestinos(unDescuento) = localidades.forEach{destino => 
		destino.aplicarDescuento(unDescuento)		
	}
	
	method mediosDeTransporte(unMedioDeTransporte) = mediosDeTransporte.add(unMedioDeTransporte)
}


class Usuario {
	var userName
	var viajes
	var saldo
	var seguidos
	var localidadDeOrigen	
	
	
	method puedeViajar(unDestino) {		
		if (saldo < unDestino.precio()) throw new Exception(message="Saldo insuficiente") else return true // De vuelta, no UserException?
	}
	
	method viajar(destino) {
		self.puedeViajar(destino)
		viajes.add(destino)
		saldo -= destino.precio()
	}
	
	method seguirUsuario(usuario) {
		seguidos.add(usuario)
		usuario.followBack(self)
	}	
	
	method localidadDeOrigen() = localidadDeOrigen
	method kilometros() = viajes.sum({ destino => destino.precio() }) * 0.1
	method followBack(usuario) = seguidos.add(usuario)
	method viajes() = viajes
	method saldo() = saldo
}
