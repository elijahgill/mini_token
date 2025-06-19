$fn=64;

//TODO
// - decal / number for token
// - clean up module parameters for consistency

// Token base
base_diameter = 28; // This should match the grid size (mm) of the map you use
base_height = 3;
base_chamfer = 0.5;

// Stand - this holds the mini
stand_height = 3;
stand_side_thickness = 3.5;
stand_chamfer = 0.5;
slot_space = 0.4; // This should match the thickness of the material you plan on putting in the slot


// calculated values
stand_width = base_diameter - base_chamfer;
stand_slope = stand_side_thickness*1.5;


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


module stand_side (width, thickness, height, slope, chamfer) {    
    ll = [-width/2,-thickness/2]; // LL
    lr = [width/2,-thickness/2]; // LR
    tl = [-width/2,thickness/2]; // TL
    tr = [width/2,thickness/2]; // TR
    
    hull()
    {
        // bottom
        linear_extrude(0.1) 
        polygon([
            ll,
            tl,
            tr,
            lr
        ]);
        
        // middle
        translate([0,0,height-chamfer*2]) 
        linear_extrude(chamfer) 
        polygon([    
            ll + [0,slope/2],
            tl,
            tr,
            lr + [0,slope/2]   
        ]);
        
        // top
        translate([0,0,height-chamfer]) 
        linear_extrude(chamfer) 
        polygon([    
            ll + [0,slope/2] ,
            tl - [0,chamfer/2],
            tr - [0,chamfer/2],
            lr + [0,slope/2]     
        ]);
    };
    
}

module stand_combined(){
        translate([0,-(stand_side_thickness+slot_space)/2,0])
        stand_side(stand_width, stand_side_thickness, stand_height, stand_slope, stand_chamfer);

        translate([0,(stand_side_thickness+slot_space)/2,0])
        rotate(180)
        stand_side(stand_width, stand_side_thickness, stand_height, stand_slope, stand_chamfer);
}


module stand(){
    // Round the stand base so it doesn't overhang the edge of the token
    intersection(){
        stand_combined();
        cylinder(d1=base_diameter-base_chamfer, d2=base_diameter-base_chamfer-stand_slope*2, h=stand_height);
    }
        
}

chamfered_cylinder(base_diameter, base_height, base_chamfer);
translate([0,0,base_height/2]) 
stand();