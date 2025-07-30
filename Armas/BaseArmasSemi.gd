extends "res://Armas/BaseArmas.gd"

#Overrides ---------------------------------------------------------
func Disparar():
	if(ListaParaDisparar == true and balas > 0):
		Chispaso()
		InstanciarAudio()
		AnimacionDisparo()
		InstanciarProyectil()
		ManejarMunicion()
		ListaParaDisparar=false
	elif(ListaParaDisparar == false):
		pass

func EquiparArma():
	super()
	Jugador.SeñalSoltarDisparo.connect(self.ActualizarSeñalDisparo)

func TirarArma():
	super()
	Jugador.SeñalSoltarDisparo.disconnect(self.ActualizarSeñalDisparo)

func GuardarArma():
	super()
	Jugador.SeñalSoltarDisparo.disconnect(self.ActualizarSeñalDisparo)
#Funciones terciarias ----------------------------------------------------------
func AnimacionDisparo():
	pass
