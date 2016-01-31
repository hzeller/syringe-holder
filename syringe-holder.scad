$fn=96;
epsilon=0.02;
transition=4;
holder_distance=22.9;
syringe_dias = [ 19.05 + 0.6, 25.4 + 0.6 ];
angle=40;
syringe_lift=20;
needle_len=24;

module syringe(luer_dia=11, luer_height=10, transition=transition, syringe_dia=19) {
    translate([0,0,-luer_height]) {
	cylinder(r=luer_dia/2, h=luer_height);
	translate([0, 0, luer_height-epsilon]) cylinder(r1=luer_dia/2, r2=syringe_dia/2, h=transition+2*epsilon);
	translate([0,0, luer_height+transition-epsilon]) cylinder(r=syringe_dia/2, h=100);
	translate([0,0,-needle_len]) {
	    cylinder(r1=3, r2=luer_dia/2, h=needle_len+epsilon);  // Needle. With little more space.
	    //rotate(-90) translate([0,-1.5,0]) cube([15,3,25]);
	    //rotate([5,0,0]) translate([0,-5/2-2,12]) scale([1,1,2.2]) sphere(r=7);
	}

	// Cutout for needle access
	hull() {
	    translate([-15,-2 - 15,-luer_height]) rotate([0,90,0]) cylinder(r=15,h=30);
	    translate([-15,-2 - 8,-needle_len+8/2]) rotate([0,90,0]) cylinder(r=8,h=30);
	}
    }

    // register holes
    register_hole_len = 10;
    if (true) {
	for (a=[0,90,180]) {
	    rotate([0,-0,a]) translate([luer_dia/2 + 1.5,0,-register_hole_len/2 - syringe_lift]) cylinder(r=0.8,h=register_hole_len);
	}
    }
}


module syringe_holder(syringe_dia=19,bottom_size=19, only_bottom=false) {
    if (!only_bottom) {
	translate([0,0,0]) rotate_extrude() translate([syringe_dia/2,0,0]) scale([0.3,1.2]) import(file = "bezier.dxf");
    }

    if (true) {
	cylinder(r1=bottom_size/2, r2=syringe_dia/2+2,h=8);
	hull() {
	    cylinder(r=bottom_size/2, h=1);
	    sphere(r=bottom_size/2);
	    translate([0,0,-needle_len-7]) sphere(r=8);
	}
    }
}

module print() {
    difference() {
	union() {
	    translate([-holder_distance,0,syringe_lift]) syringe_holder(syringe_dia=syringe_dias[0], bottom_size=21);
	    translate([holder_distance,0,syringe_lift]) syringe_holder(syringe_dia=syringe_dias[1], bottom_size=28);

	    // Foot
	    foot_elevation = 20;
	    foot_len = 65;
	    hull() {
		translate([-30,foot_elevation,epsilon]) cube([60,1.5,3]);
		translate([-30,foot_elevation+sin(angle)*foot_len,1.5+cos(angle)*foot_len]) rotate([0,90,0]) cylinder(r=1.5, h=60);
	    }

	    // connect holder to bottom.
	    translate([-holder_distance,0,0]) hull() {
		cylinder(r=1, h=40);
		translate([-4/2,foot_elevation,0.05]) rotate([-angle,0,0]) cube([4,0.1,30]);
	    }
	    translate([holder_distance,0,0]) hull() {
		cylinder(r=1, h=40);
		translate([-4/2,foot_elevation,0.05]) rotate([-angle,0,0]) cube([4,0.1,30]);
	    }
	}

	translate([0,0,syringe_lift]) {
	    translate([-holder_distance,0,0]) syringe(syringe_dia=syringe_dias[0]);
	    translate([ holder_distance,0,0]) syringe(syringe_dia=syringe_dias[1]);
	}
    }
}


module print_top() {
    difference() {
	print();
	translate([0,0,-100]) cube([200,200,200], center=true);
    }
}

module print_bottom() {
    difference() {
	print();
	translate([0,0,100-epsilon]) cube([200,200,200], center=true);
    }    
}

//print_top();
//translate([0,-30,0]) rotate([180,0,0]) print_bottom();

if (true) {
    difference() {
	translate([0,0,16]) rotate([-90+angle,0,0]) print();
	translate([22,-40,-40]) cube([100,100,100]);
    }
}

//syringe_holder();
//syringe();