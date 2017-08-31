#define DOCTEST_CONFIG_IMPLEMENT
#include <iostream>
#include "diplib.h"
#include "diplib/generation.h"
//#include "diplib/linear.h"
#include "diplib/nonlinear.h"
#include "diplib/testing.h"

int main() {
   dip::Random random( 0 );

   dip::Image filter( { 7, 7 }, 1, dip::DT_SFLOAT );
   filter.Fill( 50 );
   dip::GaussianNoise( filter, filter, random, 20.0 * 20.0 );

   //dip::UnsignedArray sizes = { 20, 30, 35, 40, 45, 50, 55, 60, 65, 70 };
   dip::UnsignedArray sizes = { 5, 7, 10, 13, 15, 20, 25 };

   //dip::SetNumberOfThreads( 1 ); // execute with `OMP_NUM_THREADS=1 ./test_openmp`

   std::cout << dip::GetNumberOfThreads() << std::endl;

   dip::Image img;
   dip::Image out;
   for( auto sz : sizes ) {

      img = dip::Image{ dip::UnsignedArray{ sz, sz }, 1, dip::DT_SFLOAT };
      img.Fill( 50 );
      dip::GaussianNoise( img, img, random, 20.0 * 20.0 );

      dip::dfloat time = 1e9;
      for( dip::uint ii = 0; ii < 10; ++ii ) {
         dip::testing::Timer timer;
         for( dip::uint jj = 0; jj < 50; ++jj ) {
            out.Strip();
            //dip::GeneralConvolution( img, filter, out );
            //dip::Uniform( img, out );
            dip::MedianFilter( img, out );
         }
         timer.Stop();
         time = std::min( time, timer.GetWall());
      }
      std::cout << "size = " << sz << ", time = " << time * 1e3 << " ms" << std::endl;

   }

   return 0;
}