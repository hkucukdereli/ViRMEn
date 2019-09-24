#include "mex.h"
#include "matrix.h"
#include "math.h"

int sign(double x) {
    if (x > 0) return 1;
    if (x < 0) return -1;
    return 0;
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    mwSize ncols, index;
    double *coord3new, *coord3;
    float a = -0.125;
    float c = 5.0;
    float aspectRatio, elev, azi, b;
    int s, p, ndims, xSign, zSign;
    int *dims[2];

    // Get aspect ratio of window
    aspectRatio = 16./9.;
    
    // viewing parameters
    s = 1;
    p = 1;
    
    // inputs
    ncols = mxGetN(prhs[0]);
    coord3 = mxGetPr(prhs[0]);
    
    // outputs
    ndims = 2;
    dims[0] = 3;
    dims[1] = ncols;
    plhs[0] = mxCreateNumericArray(ndims, dims, mxDOUBLE_CLASS, mxREAL);
    coord3new = mxGetPr(plhs[0]);
    
    printf("[%f, %f, %f] \n", coord3[3*index], coord3[3*index+1], coord3[3*index+2]);
    
    // test code below
    for (index = 0; index < ncols; index++) {
        elev = atan2(coord3[3*index+2], sqrt(pow(coord3[3*index], 2) + pow(coord3[3*index+1], 2)));
        azi = abs(atan2(coord3[3*index+1],coord3[3*index]));
        printf("%f %f/n", elev, azi);
        if ((azi < -M_PI) && (azi > (-M_PI + M_PI / 4))) {
            if (coord3new[3*index+2] == 0) {coord3new[3*index+2] = 1;}
            if (coord3new[3*index+2] == 1) {coord3new[3*index+2] = 0;}
        }
        if (sign(coord3[3*index]) == -1) {
            azi = -azi + M_PI;
        }
        
        b = -tan(azi) * sign(coord3[3*index+1]);
        coord3new[3*index] = ((-b - sqrt(pow(b, 2) - 4 * a * c)) / (2 * a)) * sign(coord3[3*index]);
        
        if (coord3new[3*index] < -20) {coord3new[3*index] = -20;}
        if (coord3new[3*index] > 20) {coord3new[3*index] = 20;}
        coord3new[3*index+1] = a * pow(coord3new[3*index], 2);
    }

    coord3new[3*index+2] = 1;
    printf("[%f, %f, %f] \n", coord3[3*index], coord3[3*index+1], coord3[3*index+2]);
    return;    
    }