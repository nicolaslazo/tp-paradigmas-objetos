class Destino {
	var nombre
	var equipajeImprescindible
	var precio
	
	method precio() {
		return precio
	}
}

class Usuario {
	var username
	var destinosConocidos
	var saldo
	var seguidos
	
	method volar(destino) {
		if (saldo > destino.precio()) {
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
		if (usuario == self) {
			// TODO: Tirar excepción
		}
		
		seguidos.add(usuario)
		usuario.seguirUsuario(self)
	}
}

const garlicsSea = new Destino(
	nombre = "Garlic's Sea",
	equipajeImprescindible = ["Caña de Pescar, Piloto"],
	precio = 2500
)

const silversSea = new Destino(
	nombre = "Silver's Sea",
	equipajeImprescindible = ["Protector Solar","Equipo de Buceo"],
	precio = 1350
)

const lastToninas = new Destino(
	nombre = "Last Toninas",
	equipajeImprescindible = ["Vacuna Gripal", "Vacuna B", "Necronomicon"],
	precio = 3500
)

const goodAirs = new Destino(
	nombre = "Good Airs",
	equipajeImprescindible = ["Cerveza", "Protector Solar"],
	precio = 1500
)