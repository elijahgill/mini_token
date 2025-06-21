// Library of reusable functions for OpenSCAD


// Generate a cylinder with a chamfered edge.
// Chamfer is the amount the edge is offset from normal, vertically and horizontally. - not the diagonal. The chamfer will always be at a 45 degree angle.
// Height is the total height of the cylinder, including the chamfered end
module chamfered_cylinder(diameter, height, chamfer) {    
    middle_height = height - chamfer*2;
    end_diameter = diameter-chamfer;
    
    //top
    translate([0,0,+middle_height/2+chamfer/2]) 
        cylinder(h = chamfer,d1=diameter, d2=end_diameter,center=true);
    
    //middle
    cylinder(h = middle_height,d=diameter,center=true);
    
    //bottom
    translate([0,0,-middle_height/2-chamfer/2]) 
        cylinder(h = chamfer,d1=end_diameter, d2=diameter,center=true);    
}

// Multiply an object in a grid layout. 
// With a single child, will generate rows*cols copies of the child object
// For multiple children, each child will be arranged in a grid with columns objects in each row
module grid_layout(spacing, columns, rows){
    max = $children > 1? $children - 1: rows*columns-1;
    
    for(i=[0:1:max]){
        row = floor(i/columns);
        col = floor(i) - row*columns;
        translate([(spacing)*col,-(spacing)*row,0]) 
        children($children > 1?i:0);
    }
}