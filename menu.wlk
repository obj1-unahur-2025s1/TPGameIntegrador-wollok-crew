import wollok.game.*
import paquetes.*
import clientes.*
import repartidor.*

object initImagen {
    method position() = game.at(0, 0)
    method image() = "initback2.png"
    method scale() = 0.0 
}
object menuPerder {
    method position() = game.at(0, 0)
    method image() = "gameOver.jpg"
}
object menuGanar {
    method position() = game.at(0, 0)
    method image() = "victoria.png"
}

object menuControles {
    method position() = game.at(0, 0)
    method image() = "controles.jpg"
}


object menuInicial {
    method mostrarMenu() {
        game.clear()
        game.boardGround("mapa22.png")
        game.addVisual(initImagen)
        
    keyboard.num1().onPressDo({ 
        game.sound("level2.mp3").play()
        game.sound("backsound60ss.mp3").play()
        self.iniciarNivel1() 
    })
    keyboard.num2().onPressDo({ 
        game.sound("level2.mp3").play()
        game.sound("backsound45s.mp3").play()
        self.iniciarNivel2() 
    })
    }

    method iniciarNivel1() {
        game.clear()
        game.boardGround("mapa22.png")
        game.addVisual(repartidor)
        game.addVisual(timer)
        timer.activar(60)
        controles.iniciar()
        listaBarreras.crearBarreras()

        game.onTick(2000, "crear cliente", {listaClientes.crearCliente()})
    }

    method iniciarNivel2() {
        game.clear()
        game.boardGround("mapa22.png")
        game.addVisual(repartidor)
        game.addVisual(timer)
        timer.activar(45)
        controles.iniciar()
        listaBarreras.crearBarreras()

        game.onTick(1800, "crear cliente", {listaClientes.crearCliente()})
    }

    method terminarNivel() {
        if (repartidor.paquetesEntregados() >= 8) {
            game.addVisual(menuGanar)
            game.sound("victory.mp3").play()
        } else {
            game.addVisual(menuPerder)
            game.sound("gameover.mp3").play()
        }
        game.removeTickEvent("crear cliente")
        listaClientes.vaciarClientes()
        controles.parar()
    }
}

object controles {
  method iniciar(){
    keyboard.d().onPressDo({ repartidor.moverDerecha() })
    keyboard.right().onPressDo({ repartidor.moverDerecha() })
    keyboard.a().onPressDo({ repartidor.moverIzquierda() })
    keyboard.left().onPressDo({ repartidor.moverIzquierda() })
    keyboard.w().onPressDo({ repartidor.moverArriba() })
    keyboard.up().onPressDo({ repartidor.moverArriba() })
    keyboard.s().onPressDo({ repartidor.moverAbajo() })
    keyboard.down().onPressDo({ repartidor.moverAbajo() })

    keyboard.h().onPressDo({repartidor.agarrarPaquete()})
    keyboard.j().onPressDo({repartidor.entregarPaquete()})
    keyboard.enter().onPressDo({})
  }

  method parar(){
    keyboard.d().onPressDo({})
    keyboard.right().onPressDo({})
    keyboard.a().onPressDo({})
    keyboard.left().onPressDo({})
    keyboard.w().onPressDo({})
    keyboard.up().onPressDo({})
    keyboard.s().onPressDo({})
    keyboard.down().onPressDo({})

    keyboard.h().onPressDo({})
    keyboard.j().onPressDo({})
    keyboard.enter().onPressDo({menuInicial.mostrarMenu()})
  }
}
