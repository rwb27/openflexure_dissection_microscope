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
use <./dovetail.scad>;
use <./cameras/picamera_2.scad>;
include <./parameters.scad>;

camera_pcb = [25, 25];
wall_t = 2;
w = camera_pcb[0] + 1 + 4;
starty = -camera_pcb[1]/2-2.4; //edge of the PCB
base_h = 7.5; //thickness of the camera mount plate (lens pokes through this)
dt_clip = [front_dovetail_w, 16, 12]; //size of the dovetail clip
arm_end_y = front_dovetail_y-dt_clip[1]-4;

beam_angle = 30;

// parameters of the lens
pedestal_h = 2 + base_h;
lens_r = 3; // for pi lens
aperture_r = lens_r-1.0;
lens_t = 2.5+0.5;
base_r = lens_r+0.8+(pedestal_h+lens_t-1.5)*tan(beam_angle);
//base_r = lens_r+5;


difference(){
    union(){
        // plate that the camera sits on
        hull(){
            cylinder(r=base_r, h=base_h, $fn=32);
            translate([-base_r-0.5-wall_t,0,0]) cube([2*(base_r+0.5+wall_t),wall_t,base_h]);
            translate([-dt_clip[0]/2, arm_end_y,0]) cube([dt_clip[0], wall_t, base_h]);
        }
        
        // walls either side for stiffness
        reflect([1,0,0]) sequential_hull(){
            translate([-base_r-0.5-wall_t,0,0])  cube([wall_t, wall_t, base_h]);
            translate([-dt_clip[0]/2, arm_end_y,0]) cube([wall_t, wall_t, dt_clip[2]]);
        }
        
        
        // mount for the dovetail clip
        translate([-dt_clip[0]/2,arm_end_y,0]) cube([dt_clip[0], 4, dt_clip[2]]);
        
        // the dovetail clip
        translate([0,front_dovetail_y, 0]) mirror([0,1,0]) dovetail_clip(dt_clip, slope_front=2, solid_bottom=0.2);
        
        // the lens holder
        trylinder_gripper(inner_r=lens_r, grip_h=pedestal_h + lens_t - 1.5, h=pedestal_h+lens_t, base_r=base_r, flare=0.5);
        // pedestal to raise the lens up within the gripper
        cylinder(r1=aperture_r+0.8+pedestal_h*tan(beam_angle), r2=aperture_r+0.8,h=pedestal_h, $fn=12);
    }
    
    // hole for the beam passing through the lens
    translate([0,0,pedestal_h]) reflect([1,0,0]) rotate([0,beam_angle+180,0]){
        translate([0,0,-0.5]) cylinder(r=aperture_r,h=999, $fn=12);
        translate([0,0,5]) cylinder(d=5,h=999, $fn=12);
    } 
    //rotate([90,0,0]) cylinder(r=999,h=999,$fn=3);
    //difference(){
    //    cube(999, center=true);
    //    cylinder(d=14, h=999,center=true);
    //}
}