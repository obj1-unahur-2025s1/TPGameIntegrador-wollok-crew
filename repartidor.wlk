import wollok.game.*
import paquetes.*
import clientes.*
import menu.*


object repartidor {
    var property position = game.at(10, 0)
    var property image = "Repa01.png"
    var paqueteAgarrado = null
    var paquetesEntregados = 0

    const posiciones = []

    method hitbox() = posiciones

    method hitbox3x3() {
        const x = self.position().x()
        const y = self.position().y()
        const variantesX = [0, 1, 2]
        const varintesY = [0, 1, 2]
        posiciones.clear()

        variantesX.forEach({ vx =>
            varintesY.forEach({ vy =>
                posiciones.add(game.at(x + vx, y + vy))
            })
        })
    }


    method hitbox2x3() {
        const x = self.position().x()
        const y = self.position().y()
        const variantesX = [0, 1]
        const varintesY = [0, 1, 2]
        posiciones.clear()

        variantesX.forEach({ vx =>
            varintesY.forEach({ vy =>
                posiciones.add(game.at(x + vx, y + vy))
            })
        })
    }

    method moverDerecha() {
        if (position.x() < 22) position = position.right(1)
        image = "Repa01.png"
        self.hitbox3x3()
        game.sound("motosound.mp3").play()
    }

    method moverIzquierda() {
        if (position.x() > 0) position = position.left(1)
        image = "Repa02.png"
        self.hitbox3x3()
        game.sound("motosound.mp3").play()
    }

    method moverArriba() {
        if (position.y() < 21) position = position.up(1)
        image = "Repa03.png"
        self.hitbox2x3()
        game.sound("motosound.mp3").play()
    }

    method moverAbajo() {
        if (position.y() > 0) position = position.down(1)
        image = "Repa04.png"
        self.hitbox2x3()
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
        if (paqueteAgarrado != null){
            const cliente = self.clienteEnEsteEspacio()
            if (cliente != null && cliente.burbuja() == paqueteAgarrado.burbuja()){
                cliente.recibirPaquete(paqueteAgarrado)
                game.sound("drop3.mp3").play()
                paquetesEntregados += 1
                paqueteAgarrado = null
            }
        }
    }

    method paquetesEntregados() = paquetesEntregados

    method ObjetoEnEsteEspacioSiHay(objetos) =
    objetos.findOrDefault({ o => o.hitbox().any({ h => self.hitbox().contains(h) }) }, null)

    method clienteEnEsteEspacio() = self.ObjetoEnEsteEspacioSiHay(listaClientes.clientesActuales())

    method paqueteEnEsteEspacio() = self.ObjetoEnEsteEspacioSiHay(listaPaquetes.paquetesActivos())


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