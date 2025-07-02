import wollok.game.*
import paquetes.*
import clientes.*
import menu.*

object repartidor {
    var property position = game.at(0, 0)
    var property image = "Repa0150.png"
    var paqueteAgarrado = null
    var paquetesEntregados = 0

    var hitbox = self.hitbox1x1()

    method hitbox() = hitbox

    method hitbox1x1() = [self.position()] 

    method hitbox3x3() = 
    [self.position(), self.position().up(1), self.position().up(2),
     self.position().right(1), self.position().right(1).up(1), self.position().right(1).up(2),
     self.position().right(2), self.position().right(2).up(1), self.position().right(2).up(2)]

    method hitbox2x3() = 
    [self.position(), self.position().up(1), self.position().up(2),
     self.position().right(1), self.position().right(1).up(1), self.position().right(1).up(2)]

    method moverDerecha() {
        if (self.position().x() <= 8) position = position.right(1)
        image = "Repa0150.png"
        hitbox = self.hitbox1x1()
        game.sound("motosound.mp3").play()
    }

    method moverIzquierda() {
        if (self.position().x() > 0) position = position.left(1)
        image = "Repa0250.png"
        hitbox = self.hitbox1x1()
        game.sound("motosound.mp3").play()
    }

    method moverArriba() {
        if (self.position().y() <= 8) position = position.up(1)
        image = "Repa0350.png"
        hitbox = self.hitbox1x1()
        game.sound("motosound.mp3").play()
    }

    method moverAbajo() {
        if (self.position().y() > 0) position = position.down(1)
        image = "Repa0450.png"
        hitbox = self.hitbox1x1()
        game.sound("motosound.mp3").play()
    }

    method agarrarPaquete() {
        if (paqueteAgarrado == null) {
            const paquete = self.paqueteEnEsteEspacio()
            if (paquete != null) {
                paqueteAgarrado = paquete
                listaPaquetes.sacarPaquete(paquete)
                game.sound("blip2.mp3").play()
            }
        }
    }

    method entregarPaquete() {
        if (paqueteAgarrado != null) {
            const cliente = self.clienteEnEsteEspacio()
            if (cliente != null && cliente.puedeRecibirElPaquete(paqueteAgarrado)) {
                cliente.recibirPaquete(paqueteAgarrado)
                listaPaquetes.devolverPaquete(paqueteAgarrado)
                paquetesEntregados += 1
                game.sound("drop3.mp3").play()
                paqueteAgarrado = null
            }
        }
    }

    method paquetesEntregados() = paquetesEntregados

    method clienteEnEsteEspacio() = listaClientes.clientesActuales().findOrDefault({c=>c.hitbox().any({h=>self.hitbox().contains(h)})}, null)

    method paqueteEnEsteEspacio() = listaPaquetes.paquetesActivos().findOrDefault({p=>p.position() == self.position()}, null)
}

object timer {
    var numeroActual = 60
    var imagen = "60.png"

    method image() = imagen
    method position() = game.origin()

    method activar(tiempo) {
        numeroActual = tiempo
        imagen = self.cambiarImagen(numeroActual)
        game.onTick(1000, "pasarTiempo", { self.disminuir() })
    }

    method disminuir() {
        if (numeroActual > 0) {
            numeroActual -= 1
            imagen = self.cambiarImagen(numeroActual)
        } else {
            menuInicial.niveles().anyOne().terminar()
            game.removeTickEvent("pasarTiempo")
        }
    }

    method cambiarImagen(numero) {
        return numero.toString() + ".png"
    }
}