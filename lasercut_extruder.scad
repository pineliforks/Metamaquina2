

union() {
	translate(v = [-37, 15.0000000000]) {
		rotate(a = [90, 0]) {
			color(c = [0.9000000000, 0.7000000000, 0.4500000000, 0.9000000000]) {
				translate(v = [0, 0, 0]) {
					dxf_linear_extrude(layer = "slice1", height = 6, file = "extruder-printrbot-layers.dxf");
				}
			}
			color(c = [0.9000000000, 0.7000000000, 0.4500000000, 0.9000000000]) {
				translate(v = [0, 0, 6]) {
					dxf_linear_extrude(layer = "slice2", height = 6, file = "extruder-printrbot-layers.dxf");
				}
			}
			color(c = [0.9000000000, 0.7000000000, 0.4500000000, 0.9000000000]) {
				translate(v = [0, 0, 12]) {
					dxf_linear_extrude(layer = "slice3", height = 6, file = "extruder-printrbot-layers.dxf");
				}
			}
			color(c = [0.9000000000, 0.7000000000, 0.4500000000, 0.9000000000]) {
				translate(v = [0, 0, 18]) {
					dxf_linear_extrude(layer = "slice4", height = 6, file = "extruder-printrbot-layers.dxf");
				}
			}
			color(c = [0.9000000000, 0.7000000000, 0.4500000000, 0.9000000000]) {
				translate(v = [0, 0, 24]) {
					dxf_linear_extrude(layer = "slice5", height = 6, file = "extruder-printrbot-layers.dxf");
				}
			}
		}
		rotate(a = [90, 0]) {
			color(c = [0.9000000000, 0.7000000000, 0.4500000000, 0.9000000000]) {
				translate(v = [0, 0, 0]) {
					dxf_linear_extrude(layer = "idler", height = 6, file = "extruder-printrbot-layers.dxf");
				}
			}
			color(c = [0.9000000000, 0.7000000000, 0.4500000000, 0.9000000000]) {
				translate(v = [0, 0, 24]) {
					dxf_linear_extrude(layer = "idler", height = 6, file = "extruder-printrbot-layers.dxf");
				}
			}
			translate(v = [9.5000000000, 35, -2.5000000000]) {
				rotate(a = [0, -90, 0]) {
					color(c = [0.9000000000, 0.7000000000, 0.4500000000, 0.9000000000]) {
						translate(v = [0, 0, 6]) {
							dxf_linear_extrude(layer = "idler2", height = 6, file = "extruder-printrbot-layers.dxf");
						}
					}
				}
			}
		}
	}
	translate(v = [7, 14, 58]) {
		rotate(a = [0, -90, 0]) {
			rotate(a = [0, 0, -90]) {
				union() {
					color(c = [0.9000000000, 0.7000000000, 0.4500000000, 0.9000000000]) {
						translate(v = [0, 0, 0]) {
							dxf_linear_extrude(layer = "handle", height = 6, file = "extruder-printrbot-layers.dxf");
						}
					}
					translate(v = [9, 5, 47]) {
						color(c = "silver") {
							difference() {
								cylinder($fn = 60, h = 4, r = 4);
								translate(v = [0, 0, 2]) {
									cylinder($fn = 6, h = 4, r = 2.4000000000);
								}
							}
							translate(v = [0, 0, -50]) {
								cylinder($fn = 60, h = 50, r = 2);
							}
						}
					}
					translate(v = [20, 5, 47]) {
						color(c = "silver") {
							difference() {
								cylinder($fn = 60, h = 4, r = 4);
								translate(v = [0, 0, 2]) {
									cylinder($fn = 6, h = 4, r = 2.4000000000);
								}
							}
							translate(v = [0, 0, -50]) {
								cylinder($fn = 60, h = 50, r = 2);
							}
						}
					}
				}
			}
		}
	}
}
/***********************************************
******      SolidPython code:      *************
************************************************
 
from solid import *
from solid.utils import *
thickness=6
default_sheet_color = [0.9, 0.7, 0.45, 0.9]

def bolt_head(r, h):
  return difference()(
    cylinder(r=r, h=h, segments=60),
    translate([0,0,h/2])(
      cylinder(r=0.6*r, h=h, segments=6)
    )
  )

def bolt(dia, length):
  return color("silver")(
    bolt_head(r=dia, h=dia),
    translate([0,0,-length])(
      cylinder(r=dia/2, h=length, segments=60)
    )
  )

@part("M3x16 bolt", 0.2, currency="R$")
def m3_16():
  return bolt(3, 16)

@part("M4x50 bolt", 1.2, currency="R$")
def m4_50():
  return bolt(4, 50)

def sheet(name, height=0, c=default_sheet_color):
  return color(c)(
    translate([0,0,height])(
      dxf_linear_extrude("extruder-printrbot-layers.dxf", height=thickness, layer=name)
    )
  )

def handle():
  #TODO: implement bolts as a class with "length" and "diameter" attributes
  handle_bolt = m4_50;
  handle_bolt.length = 50-3;

  return union()(
    sheet("handle"),
    translate([9,5,handle_bolt.length])(
      handle_bolt()
    ),
    translate([20,5,handle_bolt.length])(
      handle_bolt()
    ),
  )

def idler():
  return rotate([90,0])(
    sheet("idler"),
    sheet("idler",4*thickness),
    translate([9.5,35,-2.5])(
      rotate([0,-90,0])(
        sheet("idler2",thickness)
      )
    )
  )

def extruder_block():
  return rotate([90,0])(
    sheet("slice1"),
    sheet("slice2", thickness),
    sheet("slice3", 2*thickness),
    sheet("slice4", 3*thickness),
    sheet("slice5", 4*thickness)
  )

@part("JHead MKIV nozzle")
def nozzle(length=50):
  return color([0.2,0.2,0.2])(
    translate([0,0,5])(
      cylinder(r=8,h=5)
    ),
    cylinder(r=6,h=5),
    translate([0,0,-length+10])(
      cylinder(r=8,h=length-10)
    )
  )

def printrbot_extruder():
  return union()(

    translate([-37,2.5*thickness])(
      extruder_block(),
      idler()
    ),

    translate([7,14,58])(
      rotate([0,-90,0])(
        rotate([0,0,-90])(
          handle()
        )
      )
    )

    #nozzle()
  )

if __name__ == '__main__':
  output='lasercut_extruder'
  assembly = printrbot_extruder()
  bom = bill_of_materials()
  print bom
  open(output + '.bom', 'w').write(bom)

  scad_render_to_file(assembly, output + '.scad')

 
 
***********************************************/
                            