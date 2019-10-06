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

class MedioDeTransporte {
	var costoPorKm
	var tiempo
	
	method costoPorKm() = costoPorKm
	method tiempo() = tiempo
}

object barrileteCosmico {
	var destinos = []
	
	method cartaDeDestinos() = destinos.map{ destino => destino.nombre() }.join()
	method esEmpresaExtrema() = self.destinosDestacados().any{destino => destino.esPeligroso()}
	method destinosDestacados() = destinos.filter{destino => destino.esDestacado()}
	method destinosPeligrosos() = destinos.filter{destino => destino.esPeligroso()}
	method destinos(unDestino) = destinos.add(unDestino)
	method destinos() = destinos
	
	method aplicarDescuentoADestinos(unDescuento) = destinos.forEach{destino => 
		destino.aplicarDescuento(unDescuento)		
	}
}


class Usuario {
	var username
	var viajes
	var saldo
	var seguidos
	var localidadDeOrigen
	
	method puedeViajar(unDestino) {
		if (saldo < unDestino.precio()) throw new Exception(message="Saldo insuficiente") // De vuelta, no UserException?
	}
	
	method volar(destino) {
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
