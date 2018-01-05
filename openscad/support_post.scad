/******************************************************************
*                                                                 *
* OpenFlexure Dissection Microscope: Support Post                 *
*                                                                 *
* This is the post onto which the dissection microscope mounts.   *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./utilities.scad>;
use <./compact_nut_seat.scad>;
use <./dovetail.scad>;
include <./parameters.scad>;

module front(h){
    // the front of the structure (sits just behind the dovetail)
    translate([-front_dovetail_w/2,front_dovetail_y+2,0]) cube([front_dovetail_w, 10-2, h]);
}

module bottom(h=12){
    // the base of the structure
    hull(){
        front(h);
        translate([0,front_dovetail_y + 15,0]) cylinder(r=7, h=h);
    }
}

difference(){
    union(){
        //the dovetail
        translate([0,front_dovetail_y,0]) mirror([0,1,0])dovetail_m([front_dovetail_w, 10, post_h]);
        
        // support for the dovetail
        hull(){
            front(post_h);
            bottom();
        }
        
        // mounting screws lugs (holes are drilled later)
        for(hole = mounting_holes){
            hull(){
                bottom();
                translate(hole + [0, front_dovetail_y,0]) cylinder(r=10,h=8);
            }
        }
    }
    
    // mounting screw holes
    for(hole = mounting_holes){
        translate(hole + [0, front_dovetail_y,3]){
            cylinder(r=6,h=999);
            cylinder(r=6/2*1.1,h=999,center=true);
        }
    }
}
    