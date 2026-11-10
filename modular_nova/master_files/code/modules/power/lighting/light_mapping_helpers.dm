// Kneecapping light values every light at a time.
/obj/machinery/light/dim
	brightness = 3
	nightshift_brightness = 2.5
	bulb_power = 0.8

/obj/machinery/light/small
	brightness = 5
	nightshift_brightness = 4.5
	bulb_power = 0.9

/obj/machinery/light/cold
	nightshift_light_color = null

/obj/machinery/light/warm
	bulb_colour = LIGHT_COLOR_TUNGSTEN
	nightshift_light_color = null

/obj/machinery/light/floor
	brightness = 5.5
	nightshift_light_color = null
	nightshift_brightness = 4

/obj/machinery/light/floor/warm
	bulb_colour = LIGHT_COLOR_TUNGSTEN

/obj/machinery/light/floor/cold
	bulb_colour = LIGHT_COLOR_FAINT_BLUE
