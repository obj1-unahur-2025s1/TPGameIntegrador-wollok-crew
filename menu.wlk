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
        
        keyboard.num1().onPressDo({ 
            game.sound("level2.mp3").play()
            game.sound("backsound60ss.mp3").play()
            self.iniciarNivel(0)
        })
        keyboard.num2().onPressDo({ 
            game.sound("level2.mp3").play()
            game.sound("backsound45s.mp3").play()
            self.iniciarNivel(1)
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

    keyboard.num1().onPressDo({ 
        if (menuInicial.menus().any({m=>game.hasVisual(m)})){
        game.sound("level2.mp3").play()
        game.sound("backsound60ss.mp3").play()
        menuInicial.iniciarNivel(0)
        }
    })
    keyboard.num2().onPressDo({ 
        if (menuInicial.menus().any({m=>game.hasVisual(m)})){
        game.sound("level2.mp3").play()
        game.sound("backsound45s.mp3").play()
        menuInicial.iniciarNivel(1)
        }
    })

    keyboard.enter().onPressDo({
        if (menuInicial.menus().any({m=>game.hasVisual(m)}))
        menuInicial.mostrarMenu()
        })
  }
}
