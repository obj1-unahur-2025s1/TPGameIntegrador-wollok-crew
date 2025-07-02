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
        listaClientes.reiniciar()
        listaPaquetes.reiniciar()
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
    var enReglas = false
    const menus = [new Menu(imagen = "initback3.png"), new Menu(imagen = "perderScreen500.png"), new Menu(imagen = "ganar500.png"), new Menu(imagen = "reglasDef.png")]
    const niveles = [new Nivel(tiempo = 60), new Nivel(tiempo = 45)]

    method menus() = menus
    method niveles() = niveles

    method mostrarMenu() {
        game.clear()
        game.boardGround("j2.png")
        game.addVisual(menus.first())
        
        self.configurarNivel(keyboard.num1(), "backsound60ss.mp3", 0)
        self.configurarNivel(keyboard.num2(), "backsound45s.mp3", 1)
        self.configurarReglas(keyboard.o())
    }

    method configurarNivel(tecla, sonidoFondo, numeroNivel) {
        tecla.onPressDo({
            if (menus.any({m => game.hasVisual(m)})) {
                game.sound("level2.mp3").play()
                game.sound(sonidoFondo).play()
                self.iniciarNivel(numeroNivel)
            }
        })
    }

    method configurarReglas(tecla) {
        tecla.onPressDo({
            if (menus.any({m => game.hasVisual(m)})) {
                game.clear()
                game.addVisual(menus.get(3))   
                enReglas = true   
                controles.iniciar()             
            }
        })
    }

    method iniciarNivel(nivel) {
        niveles.get(nivel).iniciar()
    }

    method cambiarReglas() {
        enReglas = !enReglas
    }

    method enReglas() = enReglas 
}

object controles {
    method asignarTeclas(keyboardTeclas, accion) {
        keyboardTeclas.forEach({k => k.onPressDo(accion)})
    }

    method iniciar(){
        self.asignarTeclas([keyboard.d(), keyboard.right()], { repartidor.moverDerecha() })
        self.asignarTeclas([keyboard.a(), keyboard.left()], { repartidor.moverIzquierda() })
        self.asignarTeclas([keyboard.w(), keyboard.up()], { repartidor.moverArriba() })
        self.asignarTeclas([keyboard.s(), keyboard.down()], { repartidor.moverAbajo() })
        self.asignarTeclas([keyboard.h()], { repartidor.agarrarPaquete() })
        self.asignarTeclas([keyboard.j()], { repartidor.entregarPaquete() })
        
        self.asignarTeclas([keyboard.enter()], {
            if (menuInicial.enReglas()) {
                menuInicial.cambiarReglas()  
                menuInicial.mostrarMenu()
            }
            else if (menuInicial.menus().any({m => game.hasVisual(m)})) {
                menuInicial.mostrarMenu()
            }
        })
    }

    method parar(){
        self.asignarTeclas([keyboard.d(), keyboard.right()], {})
        self.asignarTeclas([keyboard.a(), keyboard.left()], {})
        self.asignarTeclas([keyboard.w(), keyboard.up()], {})
        self.asignarTeclas([keyboard.s(), keyboard.down()], {})
        self.asignarTeclas([keyboard.h()], {})
        self.asignarTeclas([keyboard.j()], {})
        self.asignarTeclas([keyboard.enter()], {})
    }
}