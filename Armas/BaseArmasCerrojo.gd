extends "res://Armas/BaseArmas.gd"


#0 = cerrado, 1 = abierto
var estadoCerrojo: int = 0
var listoParaCerrojo = true
#Overrides ---------------------------------------------------------
func Disparar():
	if(ListaParaDisparar == true and balas > 0):
		print("mosss")
		Chispaso()
		InstanciarAudio()
		AnimacionDisparo()
		InstanciarProyectil()
		ManejarMunicion()
		ListaParaDisparar=false
	elif(ListaParaDisparar == false):
		pass

func Recargar():
	if ListaParaDisparar:
		print("Arma cargada, deja el cerrojo")
		return
	
	elif estadoCerrojo == 0:
		print("abrir_cerrojo")
		AnimacionAbrirCerrojo()
		estadoCerrojo = 1
		return
	
	elif estadoCerrojo == 1:
		print("cerrar_cerrojo")
		AnimacionCerrarCerrojo()
		estadoCerrojo = 0
		ListaParaDisparar=true
		return


func RecargarSecundario():
	if(balas < TamañoCargador):
		balas = TamañoCargador
		print("Recargando arma")
		return
	if(balas == TamañoCargador or balas > TamañoCargador):
		return

func EquiparArma():
	super()
	Jugador.SeñalSoltarRecarga.connect(self.actualizarCerrojoVerdadero)

func TirarArma():
	super()
	Jugador.SeñalSoltarRecarga.disconnect(self.actualizarCerrojoVerdadero)

func GuardarArma():
	super()
	Jugador.SeñalSoltarRecarga.disconnect(self.actualizarCerrojoVerdadero)
#anumaciones ------------------------------------------------------------------
func AnimacionAbrirCerrojo():
	pass

func AnimacionCerrarCerrojo():
	pass

func actualizarCerrojoVerdadero():
	listoParaCerrojo=true
