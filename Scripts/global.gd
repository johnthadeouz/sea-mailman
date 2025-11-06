extends Node3D

var packages_delivered: int = 0

func deliver_package(package: Package):
	packages_delivered += 1
	package.queue_free()
	print(packages_delivered)
	
func play_click():
	$Click.play()

func play_slider():
	$SlideSound.play()
