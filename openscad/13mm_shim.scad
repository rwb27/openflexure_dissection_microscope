// spacers to help get the lens position right

heights=[8,4,3,2,1,0.75,0.5];
for(i=[0:len(heights)]){
    translate([i*14,0,0]) difference(){
        cylinder(r=13/2, h=heights[i], $fn=16);
        cylinder(r=13/2-0.8, h=999, $fn=16, center=true);
    }
}