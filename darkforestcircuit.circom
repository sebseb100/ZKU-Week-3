pragma circom 2.0.0;

include "../../client/node_modules/circomlib/circuits/comparators.circom"

template DarkForest() 
{
    //Accepting coordinates
    signal private input A_x;
    signal private input A_y;
    signal private input B_x;
    signal private input B_y;
    signal private input C_x;
    signal private input C_y;
    signal private input Energy;

    //These would be the calculated side lengths 
    signal AB;
    signal BC;
    signal AC;

    //We'll use the signals defined above to calculate the area
    signal area; 

    //Getting the area without squaring or dividing
    //These operations are not easy in circom so I'm follwing a method to avoid

    AB <== A_x * abs(B_y - C_y);
    BC <== B_x * abs(C_y - A_y);
    AC <== C_x * abs(A_y - B_y);

    //We'll add together these lengths but to reiterate this is the area not the perimiter 
    area = AB + BC + AC;

    //Now we can compare this value with zero to make sure it is big enough
    component Zero = IsZero();

    //Essentially passing the area into the function, again we are limited with arithmetic operations in circom
    //Unless we import tools 
    isZero.in <== area;

    signal TriangleChecker;
    //Notice we capture the output of the Zero componenet
    TriangleChecker <== 1- Zero.out;
    TriangleChecker === 1;

    //If the triangles area is 0 that just means the three points can not form a triangle

    signal delta_AB_x;
    signal delta_AB_y;
    signal delta_BC_x;
    signal delta_BC_y;
    signal delta_AC_x;
    signal delta_AC_y;
    signal squareABx;
    signal squareABy;
    signal squareBCx;
    signal squareBCy;
    signal squareACx;
    signal squareACy;
    signal AB_T;
    signal BC_T;
    signal AC_T;

    delta_AB_x <== A_x - B_x;
    delta_AB_y <== A_y - B_y;

    delta_BC_x <== B_x - C_x;
    delta_BC_y <== B_y - C_y; 

    delta_AC_x <== A_x - C_x;
    delta_AC_y <== A_y - A_y;

    squareABx <== (delta_AB_x*delta_AB_x);
    squareABy <== (delta_AB_y*delta_AB_y);
    squareBCx <== (delta_BC_x*delta_BC_x);
    squareBCy <== (delta_BC_y*delta_BC_y);
    squareACx <== (delta_AC_x*delta_AC_x);
    squareACy <== (delta_AC_y*delta_AC_y);

    AB_T <== (squareABx + squareABy);
    BC_T <== (squareBCx + squareBCy);
    AC_T <== (squareACx + squareACy);

    //Now we create an array that holds 3 items to store AB_T...
    signal array[3];
    signal truthy[3];
    signal output bool; 

    //Now we will make sure for all of the lengths that the length is indeed less than the energy required
    component less[3];
    //Start at index position zero and stop at 3 so three iterations
    for (var index=0; i<3; i++)
    {
        less[i] = LessThan(64);
        less[i].in[0] <== array[i];
        less[i].in[1] <== Energy * Energy;
        truthy[i] <== 1 - less[i].out;
        truthy[i] === 0;
    }


    //if this yields true return it
    bool 
}

component main = DarkForest();