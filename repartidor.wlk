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

    method hayBarreraAbajo() = game.getObjectsIn(self.position().down(1)).any({o=>listaBarreras.esBarrera(o)})
    method hayBarreraArriba() = game.getObjectsIn(self.position().up(1)).any({o=>listaBarreras.esBarrera(o)})
    method hayBarreraIzquierda() = game.getObjectsIn(self.position().left(1)).any({o=>listaBarreras.esBarrera(o)})
    method hayBarreraDerecha() = game.getObjectsIn(self.position().right(1)).any({o=>listaBarreras.esBarrera(o)})

    method moverDerecha() {
        if (!self.hayBarreraDerecha()) position = position.right(1)
        image = "Repa01.png"
        hitbox = self.hitbox3x3()
        game.sound("motosound.mp3").play()
    }

    method moverIzquierda() {
        if (!self.hayBarreraIzquierda()) position = position.left(1)
        image = "Repa02.png"
        hitbox = self.hitbox3x3()
        game.sound("motosound.mp3").play()
    }

    method moverArriba() {
        if (!self.hayBarreraArriba()) position = position.up(1)
        image = "Repa03.png"
        hitbox = self.hitbox2x3()
        game.sound("motosound.mp3").play()
    }

    method moverAbajo() {
        if (!self.hayBarreraAbajo()) position = position.down(1)
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
        if (paqueteAgarrado != null && self.clienteEnEsteEspacio() != null && (self.clienteEnEsteEspacio().idPaqueteElegido() == paqueteAgarrado.idPaquete())){
            listaClientes.sacarCliente(self.clienteEnEsteEspacio())
            paquetesEntregados += 1
            game.sound("drop3.mp3").play()
            paqueteAgarrado = null
        }
    }

    method paquetesEntregados() = paquetesEntregados

    method clienteEnEsteEspacio() = listaClientes.totalClientes().findOrDefault({c=>c.hitbox().any({h=>self.hitbox().contains(h)})},null)

    method paqueteEnEsteEspacio() = listaPaquetes.totalPaquetes().findOrDefault({p=>p.hitbox().any({h=>self.hitbox().contains(h)})},null)

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
            menuInicial.terminarNivel()
            game.removeTickEvent("pasarTiempo")
        }
    }

    method cambiarImagen(numero) {
        return numero.toString() + ".png"
    }
}


class Barrera{
    const property position 
}

object listaBarreras {
  const posicionBarreras = [
    [0,2],[1,2],[2,2],[3,2],[4,2],[5,2],[6,2],[7,2],[8,2],
    [15,2], [16,2],[17,2],[18,2],[19,2],[20,2],[21,2],[22,2],[23,2],[24,2],
    [0,6],[1,6],[2,6],[3,6],[4,6],[5,6],[6,6],[7,6],[8,6],
    [15,6], [16,6],[17,6],[18,6],[19,6],[20,6],[21,6],[22,6],[23,6],[24,6],
    [0,14],[1,14],[2,14],[3,14],[4,14],[5,14],[6,14],[7,14],[8,14],
    [15,14], [16,14],[17,14],[18,14],[19,14],[20,14],[21,14],[22,14],[23,14],[24,14],
    [0,18],[1,18],[2,18],[3,18],[4,18],[5,18],[6,18],[7,18],[8,18],
    [15,18], [16,18],[17,18],[18,18],[19,18],[20,18],[21,18],[22,18],[23,18],[24,18],
    [8,0],[8,1],[8,2],[8,6],[8,7],[8,8],[8,9],[8,10],
    [8,11],[8,12],[8,13],[8,14],[8,18],[8,19],[8,20],[8,21],
    [15,0],[15,1],[15,2],[15,6],[15,7],[15,8],[15,9],[15,10],
    [15,11],[15,12],[15,13],[15,14],[15,18],[15,19],[15,20],[15,21]
  ]
  const barreras = []

  method crearBarreras() {
    posicionBarreras.forEach({p=>const bar = new Barrera(position = game.at(p.get(0),p.get(1))) game.addVisual(bar) barreras.add(bar)})
    }
  method esBarrera(objeto) = (objeto.className() == barreras.first().className())
}
