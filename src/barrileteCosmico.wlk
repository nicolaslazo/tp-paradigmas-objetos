class Destino {
	var nombre
	var equipajeImprescindible
	var property precio
	
	method esDetacado() {
		return precio > 2000
	}
	
	method esPeligroso() = equipajeImprescindible.any({equipaje => equipaje.esVacuna() }) //TODO: ver un stars with con un contains o algo asi
	
	method aplicarDescuento(unDescuento) = { 
		self.precio(self.precio() - self.precio() * (unDescuento/100))
		self.agregarCertificadoDescuento()
	}
	
	method agregarCertificadoDescuento() = equipajeImprescindible.add("Certificado de descuento")
	
	method tieneEnEquipaje(unCoso) = equipajeImprescindible.contains(unCoso)
}

class Usuario {
	var username
	var destinosConocidos
	var saldo
	var seguidos
	
	
	method puedeVolar(unDestino) = saldo > unDestino.precio()
	
	method volar(destino) {
		if (self.puedeVolar(destino)) {
			destinosConocidos.add(destino)
			saldo -= destino.precio()
		}
		else {
			// TODO: Agregar excepción en el caso de que no se tenga saldo
		}
	}
	
	method kilometros() {
		return destinosConocidos.sum({ destino => destino.precio() }) * 0.1
	}
	
	method seguirUsuario(usuario) {
		//if (usuario == self) {     --lo comente porque no lo toma bien
			// TODO: Tirar excepción
		//}		
		seguidos.add(usuario)
		usuario.seguirUsuario(self)
	}	
	
}

class Empresa{
	
	var nombre	
	var destinos
	
	method cartaDeDestinos() = destinos.fold("" , {destino => destino.nombre() + ", "})
	
	method esEmpresaExtrema() = destinos.any{destino => destino.esPeligroso()}
	
	method destinosDestacados() = destinos.filter{destino => destino.esDestacado()}
	
	method destinosPeligrosos() = destinos.filter{destino => destino.esPeligroso()}
	
	method aplicarDescuentoADestinos(unDescuento) = destinos.forEach{destino => 
		destino.aplicarDescuento(unDescuento)		
	}
	
}
