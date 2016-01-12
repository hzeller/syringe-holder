$fn=96;
epsilon=0.02;
syringe_dia=19;
transition=4;
holder_distance=22.1;
needle_space=15;
syringe_dias = [ 19.5, 26.5 ];

module syringe(luer_dia=11, luer_height=20, transition=transition, syringe_dia=19) {
    translate([0,0,-luer_height]) {
	cylinder(r=luer_dia/2, h=luer_height);
	translate([0, 0, luer_height-epsilon]) cylinder(r1=luer_dia/2, r2=syringe_dia/2, h=transition+2*epsilon);
	translate([0,0, luer_height+transition-epsilon]) cylinder(r=syringe_dia/2, h=100);
	translate([0,0,-25]) cylinder(r=0.5, h=25);  // Needle.
    }

    // Air release
    if (false) {
	for (a=[0:360/3:360]) {
	    rotate([0,-0,a]) translate([syringe_dia/2 - 1,0,-30]) cylinder(r=1,h=50);
	}
    }
}


module syringe_holder(syringe_dia=19,only_bottom=false) {
    translate([0,0,needle_space]) {
	if (!only_bottom) {
	    translate([0,0,10]) rotate_extrude() translate([syringe_dia/2-0.7,0,0]) scale([0.3,1]) import(file = "bezier.dxf");
	}
	//translate([0,0,-needle_space]) cylinder(r1=syringe_dia/2+1, r2=syringe_dia/2 + 2,h=12 + needle_space+5);
    }
}

module print() {
    difference() {
	union() {
	    translate([-holder_distance,0,0]) syringe_holder(syringe_dia=syringe_dias[0]);
	    translate([holder_distance,0,0]) syringe_holder(syringe_dia=syringe_dias[1]);

	    hull() {
		translate([-holder_distance,0,0]) syringe_holder(syringe_dia=syringe_dias[0], only_bottom=true);
		translate([holder_distance,0,0]) syringe_holder(syringe_dia=syringe_dias[1], only_bottom=true);
		translate([-30,15,1.5]) rotate([0,90,0]) cylinder(r=1.5, h=60);
	    }

	    // Foot
	    hull() {
		translate([-30,15,1.5]) rotate([0,90,0]) cylinder(r=1.5, h=60);
		translate([-30,15+30,1.5+30]) rotate([0,90,0]) cylinder(r=1.5, h=60);
	    }

	    // re-enforcements.
	    translate([-holder_distance,0,0]) hull() {
		cylinder(r=1, h=20);
		translate([0,15,1.5]) rotate([-45,0,0]) cylinder(r=1, h=30);
	    }
	    translate([holder_distance,0,0]) hull() {
		cylinder(r=1, h=20);
		translate([0,15,1.5]) rotate([-45,0,0]) cylinder(r=1, h=30);
	    }
	}

	translate([0,0,needle_space]) {
	    translate([-holder_distance,0,0]) syringe(syringe_dia=syringe_dias[0]);
	    #translate([ holder_distance,0,0]) syringe(syringe_dia=syringe_dias[1]);
	}
    }
}


rotate([-45,0,0]) print();
//print();
//syringe_holder();
//syringe();