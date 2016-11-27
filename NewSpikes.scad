barThickness = 1.0;
wallThickness = 1.0;
heightHigh = 75; 
heightLow = 15;
width = 16.66667;
percentRound = 0.2;
numCones = 1;
LEDWidth = 1000/60;
spacerX = LEDWidth-width;
barX = numCones*(width+spacerX)+spacerX;
barY = width-2;
masterFN=30; //100 or 3,4,5

N = numCones - 1;
slope = N==0 ? 0 : (heightHigh-heightLow)/(N/2);
function localHeightRising(i) = slope*i+heightLow;
function localHeightFalling(i) = heightLow-slope*(i-N);
function flatten(l) = [ for (a = l) for (b = a) b ] ;
halfN = floor(N/2);
//heights = flatten( [ [ for (i=[0:halfN]) localHeightRising(i) ], 
//    [ for (i=[halfN+1:N]) localHeightFalling(i) ] ] );
heights = [ heightHigh ];
echo(heights);    

module bar(thickness) {
    translate([-width/2-spacerX,-barY/2,0]) {
        cube([numCones*(width+spacerX)+spacerX,barY,thickness]);
    }
}
module translatedRoundCone(h,w,i)
{
    translate([i*(width+spacerX),0,0]) {
        roundCone(h,w);
    }
}

module translatedCone(h,w,i)
{
    translate([i*(width+spacerX),0,0]) {
        cylinder(h=h,d1=w,d2=0,$fn=masterFN);
    }
}

module roundCone(h,w)
{
    z = h*percentRound;
    echo(z);
    m = 2*h/w;
    x = z/m;
    theta = atan(z/x);
    phi = 90-theta;
    y = x*tan(phi);
    echo(y);
    radius = sqrt(x*x+y*y);
    echo(radius);
    topDiameter = 2*x;
    echo(z+y-radius);
    
    union() {
        cylinder(h=h-z,d1=w,d2=topDiameter,$fn=masterFN);
        translate([0,0,h-z-y]) {
            difference() {
                sphere(r=radius,$fn=masterFN);
                translate([-radius,-radius,-radius-z]) {
                    cube([2*radius,2*radius,2*radius]);
                }
            }
        }
    }
}

module conesWithBar(barThick,wallThick) {
difference() {
    union() { 
        bar(barThick);
        for (i=[0:N]) {
           translatedRoundCone(heights[i],width,i);
        }
    }
    for (i=[0:N]) {
        //translatedRoundCone(heights[i]-wallThickness,width-2*wallThickness,i);
        translatedCone(heights[i]-13.5-wallThickness,width-2*wallThickness,i);
    }
}
}

conesWithBar(barThickness,wallThickness);
