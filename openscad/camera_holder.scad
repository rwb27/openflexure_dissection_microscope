/******************************************************************
*                                                                 *
* OpenFlexure Dissection Microscope: Microscope body              *
*                                                                 *
* This is the chassis of the OpenFlexure microscope, an open      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./utilities.scad>;
use <./compact_nut_seat.scad>;
use <./dovetail.scad>;
use <./cameras/picamera_2.scad>;
include <./parameters.scad>;

camera_pcb = [25, 25];
wall_t = 2;
w = camera_pcb[0] + 1 + 4;
starty = -camera_pcb[1]/2-2.4; //edge of the PCB
lens_h = 2.5; //thickness of the camera mount plate (lens pokes through this)
dt_clip = [front_dovetail_w, 16, 20]; //size of the dovetail clip
arm_end_y = front_dovetail_y-dt_clip[1]-4;

difference(){
    union(){
        // plate that the camera sits on
        translate([-w/2, starty,0]) cube([w,camera_pcb[1]+5,lens_h]);
        
        // walls either side for stiffness
        reflect([1,0,0]) sequential_hull(){
            translate([-w/2, starty,0]) cube([wall_t, wall_t, lens_h]);
            translate([-w/2, starty + camera_pcb[1],0]) cube([wall_t, wall_t, lens_h + 8]);
            translate([-dt_clip[0]/2, arm_end_y,0]) cube([wall_t, wall_t, dt_clip[2]]);
        }
        
        // add a bottom
        hull() reflect([1,0,0]){
            translate([-w/2, starty + camera_pcb[1],0]) cube([wall_t, wall_t, lens_h]);
            translate([-dt_clip[0]/2, arm_end_y,0]) cube([wall_t, wall_t, lens_h]);
        }
        
        // mount for the dovetail clip
        translate([-dt_clip[0]/2,arm_end_y,0]) cube([dt_clip[0], 4, dt_clip[2]]);
        
        // the dovetail clip
        translate([0,front_dovetail_y, 0]) mirror([0,1,0]) dovetail_clip(dt_clip, slope_front=2, solid_bottom=0.2);
    }
    
    
    
    // mount for the camera
    translate([0,0,lens_h]) rotate([180,0,0]) picam2_cutout();
    
    // pass-through hole for the camera flex in case it's needed
    translate([0,starty + camera_pcb[1] + 2]) cube([camera_pcb[0] - 2, 4, 999],center=true);
    translate([0,arm_end_y -4]) cube([camera_pcb[0] - 2, 4, 999],center=true);
}