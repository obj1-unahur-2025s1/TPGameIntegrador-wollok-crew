import wollok.game.*
import paquetes.*
import clientes.*
import repartidor.*

class Menu{
    const imagen
    method position() = game.at(0,0)
    method image() = imagen
}

class Nivel{
    const tiempo
    method iniciar() {
      game.clear()
      game.addVisual(repartidor)
      game.addVisual(timer)
      timer.activar(tiempo)
      controles.iniciar()
      game.onTick(2000, "crear cliente", {listaClientes.crearCliente()})
    }

    method terminar() {
        if (repartidor.paquetesEntregados() >= 8) {
            game.addVisual(menuInicial.menus().get(2))
            game.sound("victory.mp3").play()
        } else {
            game.addVisual(menuInicial.menus().get(1))
            game.sound("gameover.mp3").play()
        }
        game.removeTickEvent("crear cliente")
        listaClientes.vaciarClientes()
    }
}

object menuInicial {
    const menus = [new Menu(imagen = "initback2.png"), new Menu(imagen = "gameOver.jpg"), new Menu(imagen = "victoria.png"), new Menu(imagen = "controles.jpg")]
    const niveles = [new Nivel(tiempo = 60), new Nivel(tiempo = 45)]

    method menus() = menus
    method niveles() = niveles

    method mostrarMenu() {
        game.clear()
        game.boardGround("mapa22.png")
        game.addVisual(menus.first())
        self.configurarNivel(keyboard.num1(), "backsound60ss.mp3", 0)
        self.configurarNivel(keyboard.num2(), "backsound45s.mp3", 1)    
    }

    method configurarNivel(tecla, sonidoFondo, numeroNivel) {
    tecla.onPressDo({
      if (menus.any({m=>game.hasVisual(m)})){
        game.sound("level2.mp3").play()
        game.sound(sonidoFondo).play()
        self.iniciarNivel(numeroNivel)}
      })
    }

    method iniciarNivel(nivel) {niveles.get(nivel).iniciar()}
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

    keyboard.enter().onPressDo({
        if (menuInicial.menus().any({m=>game.hasVisual(m)}))
        menuInicial.mostrarMenu()
        })
  }
}
