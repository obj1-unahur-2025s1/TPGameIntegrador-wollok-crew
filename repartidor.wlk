import wollok.game.*
import paquetes.*
import clientes.*
import menu.*


object repartidor {
    var property position = game.at(10, 0)
    var property image = "Repa01.png"
    var paqueteAgarrado = null
    var paquetesEntregados = 0

    var hitbox = self.hitbox3x3()

    method hitbox() = hitbox

    method hitbox3x3() = 
    [self.position(),   self.position().up(1),  self.position().up(2),
    self.position().right(1), self.position().right(1).up(1), self.position().right(1).up(2),
    self.position().right(2), self.position().right(2).up(1), self.position().right(2).up(2)]

    method hitbox2x3() = 
    [self.position(),   self.position().up(1),  self.position().up(2),
    self.position().right(1), self.position().right(1).up(1), self.position().right(1).up(2)]

    method moverDerecha() {
        if (position.x() < 22) position = position.right(1)
        image = "Repa01.png"
        hitbox = self.hitbox3x3()
        game.sound("motosound.mp3").play()
    }

    method moverIzquierda() {
        if (position.x() > 0) position = position.left(1)
        image = "Repa02.png"
        hitbox = self.hitbox3x3()
        game.sound("motosound.mp3").play()
    }

    method moverArriba() {
        if (position.y() < 21) position = position.up(1)
        image = "Repa03.png"
        hitbox = self.hitbox2x3()
        game.sound("motosound.mp3").play()
    }

    method moverAbajo() {
        if (position.y() > 0) position = position.down(1)
        image = "Repa04.png"
        hitbox = self.hitbox2x3()
        game.sound("motosound.mp3").play()
    }

    method agarrarPaquete() {
        if (paqueteAgarrado == null && self.paqueteEnEsteEspacio() != null){
            paqueteAgarrado = self.paqueteEnEsteEspacio()
            listaPaquetes.sacarPaquete(self.paqueteEnEsteEspacio())
            game.sound("blip2.mp3").play()
        }
    }

    method entregarPaquete() {
        if (paqueteAgarrado != null && self.clienteEnEsteEspacio() != null && (self.clienteEnEsteEspacio().burbuja() == paqueteAgarrado.burbuja())){
            paqueteAgarrado.actualizarContenido()
            listaClientes.sacarCliente(self.clienteEnEsteEspacio())
            paquetesEntregados += 1
            game.sound("drop3.mp3").play()
            paqueteAgarrado = null
        }
    }

    method paquetesEntregados() = paquetesEntregados

    method clienteEnEsteEspacio() = listaClientes.clientesActuales().findOrDefault({c=>c.hitbox().any({h=>self.hitbox().contains(h)})},null)

    method paqueteEnEsteEspacio() = listaPaquetes.paquetesActivos().findOrDefault({p=>p.hitbox().any({h=>self.hitbox().contains(h)})},null)
}

object timer {
    var numeroActual = 60
    var imagen = "60.png"

    method image() = imagen
    method position() = game.origin()

    method activar(tiempo) {
        numeroActual = tiempo
        imagen = (numeroActual.toString() + ".png")
        game.onTick(1000, "pasarTiempo", { self.disminuir() })
    }

    method disminuir() {
        if (numeroActual > 0) {
            numeroActual -= 1
            imagen = (numeroActual.toString() + ".png")
        } else {
            menuInicial.niveles().anyOne().terminar()
            game.removeTickEvent("pasarTiempo")
        }
    }
}