

wall_thickness = 4;
base_thickness = 1.6;
box_length = 30;
box_width = 20;
box_height = 15;

lid_triangle_height = 2.4;
lid_thickness = 3;
lid_length = box_length + wall_thickness;

translate([0,0,box_height/2]) box();
translate([-40, 0, 0]) lid();

module box()
{
    box_full_width = box_width + 2*wall_thickness;
    box_full_length = box_length + 2*wall_thickness;
    box_full_height = box_height + base_thickness + lid_thickness;
    
    difference()
    {
        //main box
        cube([box_full_width, box_full_length, box_full_height], center=true);
        
        //main cutout
        translate([-box_width/2, -box_length/2, -box_height/2]) cube([box_width, box_length, box_height+20]);
        
        //cutout for lid
        //4% larger in x and z to provide some tolerance for shrinkage and allow easier sliding
        translate([0,wall_thickness/2,box_height/2-0.4]) scale([1.03, 1, 1.03]) lid();
         translate([-box_width/2,box_length/2,box_height/2]) cube([box_width, wall_thickness*3, 10]);
       
        
        //These changes only save about 4 minutes (estimated by cura)
        //cutout in base to speed up printing
        //translate([0,0,-box_full_height/2]) cube([box_width*2/3, box_length*2/3, 10], center=true);
        
        //cutout in front and back walls to speed up printing
        //translate([0,0,0]) cube([box_width*0.6, box_length*2, box_height], center=true);
        //translate([0,-box_length/2,box_height/2]) cube([box_width*0.6, wall_thickness*3, 10], center=true);
         
        translate([0,0,-12]) cube([40, 40, 30], center=true);
    }
    
   
}

module lid()
{
    //main body of the lid
    cube([box_width, lid_length, lid_thickness], center=true);
    
    //right triangle bit
    translate([box_width/2, -lid_length/2, -lid_thickness/2]) rotate([90,0,90]) prism_isos(lid_length, lid_thickness, lid_triangle_height);
    
    //left triangle bit
    translate([-box_width/2, lid_length/2, -lid_thickness/2]) rotate([90,0,-90]) prism_isos(lid_length, lid_thickness, lid_triangle_height);
}

//from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
//makes 3D triangles
module prism_isos(l, w, h){
   polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w/2,h], [l,w/2,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
           );
  
}

module triangle_mount(base, height, length)
{
    translate([-length/2,0,base/2]) rotate([90,0,0]) union(){
        //triangle portion
        //rotate([90,0,-90]) 
        translate([0,-base/2,0]) prism_isos(length,base,height);
        
        //rectangular support
        //rotate([0,90,0])
        //translate([-length/2,0,base]) 
        translate([length/2,0,-base/2]) cube([length,base,base], center=true);
    }
}