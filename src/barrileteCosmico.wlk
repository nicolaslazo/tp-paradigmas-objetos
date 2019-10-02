class Destino {
	var nombre
	var equipajeImprescindible
	var property precio
	
	method nombre() {
		return nombre
	}
	
	method esDestacado() {
		return precio > 2000
	}
	
	method esPeligroso() {
		return equipajeImprescindible.any({equipaje => equipaje.contains("Vacuna") }) //TODO: ver un stars with con un contains o algo asi
	}
	
	method aplicarDescuento(unDescuento){ 
		precio = (precio - precio * (unDescuento/100))
		self.agregarCertificadoDescuento()
	}
	
	method agregarCertificadoDescuento() {
		equipajeImprescindible.add("Certificado de descuento")
	}
	
	method tieneEnEquipaje(unCoso) {
		return equipajeImprescindible.contains(unCoso)
		
		}
}

object barrileteCosmico{
	var destinos = []
	
	method cartaDeDestinos() = destinos.map{ destino => destino.nombre() }.join()
	
	method esEmpresaExtrema() = self.destinosDestacados().any{destino => destino.esPeligroso()}
	
	method destinosDestacados() = destinos.filter{destino => destino.esDestacado()}
	
	method destinosPeligrosos() = destinos.filter{destino => destino.esPeligroso()}
	
	method aplicarDescuentoADestinos(unDescuento) = destinos.forEach{destino => 
		destino.aplicarDescuento(unDescuento)		
	}
	
	method destinos(unDestino){
		destinos.add(unDestino)
	}
	
	method destinos(){
		return destinos
	}
}


class Usuario {
	var username
	var destinosConocidos
	var saldo
	var seguidos
	
	
	method puedeVolar(unDestino) {
		return  saldo > unDestino.precio()
	}
	method volar(destino) {
		if (self.puedeVolar(destino)) {
			self.validarSaldo(destino)
			destinosConocidos.add(destino)
			saldo -= destino.precio()
		}
	}
	
	method validarSaldo(destino) {
		if (saldo < destino.precio()) {
			// TODO: tirar excepción
		}
	}
	
	method kilometros() {
		return destinosConocidos.sum({ destino => destino.precio() }) * 0.1
	}
	
	method seguirUsuario(usuario) {
		seguidos.add(usuario)
		usuario.followBack(self)
	}	
	
	method followBack(usuario) {
		seguidos.add(usuario)
	}
	
	method destinosConocidos() {
		return destinosConocidos
	}
	
	method saldo() {
		return saldo
	}
}
