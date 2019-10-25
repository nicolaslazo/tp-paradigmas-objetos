class Localidad {
	var nombre
	var equipajeImprescindible
	var property precio
	var kilometro
	
	method nombre() = nombre
	method kilometro() = kilometro
	method equipajeImprescindible() = equipajeImprescindible
	method esDestacado() = precio > 2000
	method esPeligroso() = equipajeImprescindible.any({ equipaje => equipaje.contains("Vacuna") })
	method tieneEnEquipaje(unCoso) = equipajeImprescindible.contains(unCoso)
	
	method agregarCertificadoDescuento() {
		equipajeImprescindible.add("Certificado de descuento")
	}
	
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
	
	method costoPorKm() = costoPorKm
	method tiempo() = tiempo
	method costoEntreLocalidades(distancia) = costoPorKm * distancia
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
	override method costoPorKm() =  1429.1533
	
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

	method armarUnViaje(unUsuario,unDestino){ 
		return new Viaje(
			localidadOrigen = unUsuario.localidadDeOrigen(),
			localidadDestino = unDestino,
			medioDeTransporte = unUsuario.eleccionMedioDeTransporte(mediosDeTransporte)
		)
	}

	
	method cartaDeDestinos() = localidades.map{ localidad => localidad.nombre() }.join()
	method esEmpresaExtrema() = self.destinosDestacados().any{localidad => localidad.esPeligroso()}
	method destinosDestacados() = localidades.filter{localidad => localidad.esDestacado()}
	method destinosPeligrosos() = localidades.filter{localidad => localidad.esPeligroso()}
	method destinos() = localidades
	
	method agregarLocalidad(unaLocalidad) {
		localidades.add(unaLocalidad)
	}
	
	method aplicarDescuentoADestinos(unDescuento) {
		localidades.forEach({ destino => destino.aplicarDescuento(unDescuento)	})	
	}
	
	method agregarMedioDeTransporte(unMedioDeTransporte) {
		mediosDeTransporte.add(unMedioDeTransporte)
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
		if (saldo < unDestino.precio()) throw new Exception(message="Saldo insuficiente")
	}
	
	method validarEquipajeImprescindible(unDestino){		
		if (self.tieneEquipajeImprescindible(unDestino).negate()) throw new Exception(message="No tiene equipaje necesario")
	}
	
	method tieneEquipajeImprescindible(unDestino) = unDestino.equipajeImprescindible().all({ item => mochila.contains(item) })
	
	method puedeViajar(unDestino) {		
		self.tieneSaldo(unDestino)
		self.validarEquipajeImprescindible(unDestino)
		
		return true
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
	method viajes() = viajes
	method saldo() = saldo
	
	method followBack(usuario) {
		seguidos.add(usuario)
	}
	
	method eleccionMedioDeTransporte(mediosDeTransporte) {
		perfil.elegirMedioDeTransporte(self, mediosDeTransporte)
	}
}

class Perfil {
	method elegirMedioDeTransporte(usuario, mediosDeTransporte)
}

object perfilEmpresarial inherits Perfil {
	method elegirMedioDeTransporte(usuario, mediosDeTransporte) = mediosDeTransporte.first() // TODO: Implementar correctamente
}

object perfilEstudiantil inherits Perfil {
	method elegirMedioDeTransporte(usuario, mediosDeTransporte) = self.elMasRapido(self.filtrarCosteables(usuario, mediosDeTransporte))
	method filtrarCosteables(usuario, mediosDeTransporte) = mediosDeTransporte.filter({ medio => })
	// TODO: Completar
}

object perfilFamiliar inherits Perfil {
	method elegirMedioDeTransporte(usuario, mediosDeTransporte) = mediosDeTransporte.anyOne()
}
