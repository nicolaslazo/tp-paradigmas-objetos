object barrileteCosmico {
	var localidades = []
	var mediosDeTransporte = []

	method armarUnViaje(unUsuario,unDestino){ 
		return new Viaje(
			localidadOrigen = unUsuario.localidadDeOrigen(),
			localidadDestino = unDestino,
			medioDeTransporte = unUsuario.eleccionMedioDeTransporte(unUsuario, unUsuario.localidadDeOrigen(), unDestino, mediosDeTransporte)
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
	override method esPeligroso() = super() && altura > 5000
}
class Playa inherits Localidad{
	override method esPeligroso() = false
}
class CiudadHistorica inherits Localidad{
	var museos 	
	override method esPeligroso() = equipajeImprescindible.any({equipaje => equipaje.contains("Seguro asistencia al viajero") }).negate()
	override method esDestacado() = super() && museos.size() > 3
}

class MedioDeTransporte {	
	var tiempo	
	method costoPorKm() 
	method tiempo() = tiempo
	method costoEntreLocalidades(distancia) = self.costoPorKm() * distancia
}


class Micro inherits MedioDeTransporte{
	override method costoPorKm() = 5000	
}

class Avion inherits MedioDeTransporte{
	var turbinas
	override method costoPorKm() =  turbinas.sum({ turbina => turbina.nivelImpulso() })
}

class Turbina{
	var nivelImpulso
	
	method nivelImpulso() = nivelImpulso
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
	method medioDeTransporte() = medioDeTransporte
	method localidadOrigen() = localidadOrigen
	method localidadDestino() = localidadDestino	
	
	method distanciaViaje() = localidadOrigen.distanciaA(localidadDestino)
	method precio() = return self.medioDeTransporte().costoEntreLocalidades(self.distanciaViaje()) + localidadDestino.precio()
	method equipajeImprescindible() = localidadDestino.equipajeImprescindible()
}

class Usuario {
	var userName
	var viajes
	var saldo
	var seguidos
	var localidadDeOrigen
	var perfil
	var mochila

	method viajes() = viajes
	method saldo() = saldo
	
	method tieneSaldo(viaje){
		if (saldo < viaje.precio()) throw new Exception(message="Saldo insuficiente")
	}
	
	method validarEquipajeImprescindible(viaje){		
		if (self.tieneEquipajeImprescindible(viaje).negate()) throw new Exception(message="No tiene equipaje necesario")
	}
	
	method tieneEquipajeImprescindible(viaje) = viaje.equipajeImprescindible().all({ item => mochila.contains(item) })
	
	method puedeViajar(viaje) {		
		self.tieneSaldo(viaje)
		self.validarEquipajeImprescindible(viaje)
		
		return true
	}
	
	method viajar(viaje) {
		self.puedeViajar(viaje)
		viajes.add(viaje)
		saldo -= viaje.precio()
		localidadDeOrigen = viaje.localidadDestino() //#8
	}
	
	method seguirUsuario(usuario) {
		seguidos.add(usuario)
		usuario.followBack(self)
	}	
	
	method localidadDeOrigen() = localidadDeOrigen
	method kilometros() = viajes.sum({ viaje => viaje.distanciaViaje() }) //#8
		
	method followBack(usuario) {
		seguidos.add(usuario)
	}
	
	method eleccionMedioDeTransporte(usuario, origen, destino, mediosDeTransporte) {
		return perfil.elegirMedioDeTransporte(usuario, origen, destino, mediosDeTransporte)
	}
	
	method filtrarTransportesCosteables(origen, destino, mediosDeTransporte) {
		var costeables = mediosDeTransporte.filter({ medio => medio.costoEntreLocalidades(origen.distanciaA(destino)) <= saldo })
		if(costeables.size() == 0) throw new Exception("No se puede armar viaje porque no puede costear ningun medio de transporte")
		return costeables 
	}
}

class Perfil {
	method elegirMedioDeTransporte(usuario, origen, destino, mediosDeTransporte)
}

object perfilEmpresarial inherits Perfil {
	override method elegirMedioDeTransporte(usuario, origen, destino, mediosDeTransporte) = mediosDeTransporte.min({ medio => medio.tiempo() })
}

object perfilEstudiantil inherits Perfil {
	override method elegirMedioDeTransporte(usuario, origen, destino, mediosDeTransporte) = usuario.filtrarTransportesCosteables(origen, destino, mediosDeTransporte).min({ medio => medio.tiempo() })
}

object perfilFamiliar inherits Perfil {
	override method elegirMedioDeTransporte(usuario, origen, destino, mediosDeTransporte) = mediosDeTransporte.anyOne()
}
