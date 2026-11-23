This is a support code for the paper "Simple ordinary geometrically split abelian varieties over finite fields".

# Requirements
* Sage 10.6

# How to use
Clone this repository or download it as ZIP archive and run the examples below.

## Enumeration of geometrically split abelian varieties
To print a list of possible cases of simple ordinary geometrically split abelian varieties run:
```sh
sage av_gsplit_enum.sage [dimension]
```
For example, if you run:
```sh
sage av_gsplit_enum.sage 4
```

The script will output a short table for dimension 4:
```
  d    A                         A/F_{q^d}   e   g_B   chi_A,q(T)                       conditions
├────┼─────────────────────────┼───────────┼───┼─────┼────────────────────────────────┼────────────────────┤
  2    W_{2,1}(B/F_q^2)          B^2         2   2     \chi_{B/F_q^2,q^2}(T^2)
  3    V_3(B)                    B^2         1   2     \chi_{V_3(B),q}(T)
  4    | W_{4,1}(B/F_q^4)        B^2         4   2     | \chi_{B/F_q^4,q^4}(T^4)        pi_B ∈ -4Q[pi_B]^4
  5    V_5(B)                    B^4         1   1     \chi_{V_5(B),q}(T)
  5    | V_5(B)                  B^2         1   2     | \chi_{V_5(B),q}(T)
  6    | W_{2,1}(V_3(B/F_q^2))   B^2         2   2     | \chi_{V_3(B/F_q^2),q^2}(T^2)
  8    | W_{8,1}(B/F_q^8)        B^2         8   2     | \chi_{B/F_q^8,q^8}(T^8)        pi_B ∈ -4Q[pi_B]^4
  10   | W_{2,1}(V_5(B/F_q^2))   B^2         2   2     | \chi_{V_5(B/F_q^2),q^2}(T^2)
  12   | W_{4,1}(V_3(B/F_q^4))   B^2         4   2     | \chi_{V_3(B/F_q^4),q^4}(T^4)

```

To see information about the abelian variety A over all subfields add `--subfields` flag:
```sh
sage av_gsplit_enum.sage 4 --subfields
```

The script will output the table with subfields in conditions:
```
  d    A                         A/F_{q^d}   e   g_B   chi_A,q(T)                       conditions
├────┼─────────────────────────┼───────────┼───┼─────┼────────────────────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  2    W_{2,1}(B/F_q^2)          B^2         2   2     \chi_{B/F_q^2,q^2}(T^2)
  3    V_3(B)                    B^2         1   2     \chi_{V_3(B),q}(T)
  4    | W_{4,1}(B/F_q^4)        B^2         4   2     | \chi_{B/F_q^4,q^4}(T^4)        pi_B ∈ -4Q[pi_B]^4, A/F_q^2 ~ W_{4,2}(B/F_q^4)
  5    V_5(B)                    B^4         1   1     \chi_{V_5(B),q}(T)
  5    | V_5(B)                  B^2         1   2     | \chi_{V_5(B),q}(T)
  6    | W_{2,1}(V_3(B/F_q^2))   B^2         2   2     | \chi_{V_3(B/F_q^2),q^2}(T^2)   A/F_q^2 ~ V_3(B/F_q^2), A/F_q^3 ~ W_{6,3}(B/F_q^6)
  8    | W_{8,1}(B/F_q^8)        B^2         8   2     | \chi_{B/F_q^8,q^8}(T^8)        pi_B ∈ -4Q[pi_B]^4, A/F_q^2 ~ | W_{8,2}(B/F_q^8), A/F_q^4 ~ W_{8,4}(B/F_q^8)
  10   | W_{2,1}(V_5(B/F_q^2))   B^2         2   2     | \chi_{V_5(B/F_q^2),q^2}(T^2)   A/F_q^2 ~ | V_5(B/F_q^2), A/F_q^5 ~ W_{10,5}(B/F_q^10)
  12   | W_{4,1}(V_3(B/F_q^4))   B^2         4   2     | \chi_{V_3(B/F_q^4),q^4}(T^4)   A/F_q^2 ~ | W_{4,2}(V_3(B/F_q^4)), A/F_q^3 ~ | W_{12,3}(B/F_q^12), A/F_q^4 ~ V_3(B/F_q^4), A/F_q^6 ~ W_{12,6}(B/F_q^12)
```

## Explicit characteristic polynomials for the table
To compute characteristic polynomials for the table above use `--frobs` flag:
```sh
sage av_gsplit_enum.sage 4 --frobs
```

```
  d    A                         A/F_{q^d}   e   g_B   chi_A,q(T)                       conditions
├────┼─────────────────────────┼───────────┼───┼─────┼────────────────────────────────┼────────────────────┤
  2    W_{2,1}(B/F_q^2)          B^2         2   2     \chi_{B/F_q^2,q^2}(T^2)
  3    V_3(B)                    B^2         1   2     \chi_{V_3(B),q}(T)
  4    | W_{4,1}(B/F_q^4)        B^2         4   2     | \chi_{B/F_q^4,q^4}(T^4)        pi_B ∈ -4Q[pi_B]^4
  5    V_5(B)                    B^4         1   1     \chi_{V_5(B),q}(T)
  5    | V_5(B)                  B^2         1   2     | \chi_{V_5(B),q}(T)
  6    | W_{2,1}(V_3(B/F_q^2))   B^2         2   2     | \chi_{V_3(B/F_q^2),q^2}(T^2)
  8    | W_{8,1}(B/F_q^8)        B^2         8   2     | \chi_{B/F_q^8,q^8}(T^8)        pi_B ∈ -4Q[pi_B]^4
  10   | W_{2,1}(V_5(B/F_q^2))   B^2         2   2     | \chi_{V_5(B/F_q^2),q^2}(T^2)
  12   | W_{4,1}(V_3(B/F_q^4))   B^2         4   2     | \chi_{V_3(B/F_q^4),q^4}(T^4)

Characteristic polynomials from the table:
\chi_{B/F_q^2,q^2}(T^2) = T^8 + T^6*b1_2 + T^4*b2_2 + T^2*b1_2*q^2 + q^4

\chi_{V_3(B),q}(T) = T^8 - T^7*b1 + T^6*b1^2 - T^6*b2 - T^5*b1*b2 + 2*T^5*b1*q - T^4*b1^2*q + T^4*b2^2 - T^3*b1*b2*q - T^4*q^2 + 2*T^3*b1*q^2 + T^2*b1^2*q^2 - T^2*b2*q^2 - T*b1*q^3 + q^4

| \chi_{B/F_q^4,q^4}(T^4) = T^16 + T^12*b1_4 + T^8*b2_4 + T^4*b1_4*q^4 + q^8

\chi_{V_5(B),q}(T) = T^8 - T^7*b1 + T^6*b1^2 - T^5*b1^3 + T^4*b1^4 - T^6*q + 2*T^5*b1*q - 3*T^4*b1^2*q - T^3*b1^3*q + T^4*q^2 + 2*T^3*b1*q^2 + T^2*b1^2*q^2 - T^2*q^3 - T*b1*q^3 + q^4

| \chi_{V_5(B),q}(T) = T^16 - T^15*b1 + T^14*b1^2 - T^13*b1^3 + T^12*b1^4 - T^14*b2 + 2*T^13*b1*b2 - 3*T^12*b1^2*b2 - T^11*b1^3*b2 - T^13*b1*q + 2*T^12*b1^2*q + 2*T^11*b1^3*q - T^10*b1^4*q + T^12*b2^2 + 2*T^11*b1*b2^2 + T^10*b1^2*b2^2 - 3*T^11*b1*b2*q - T^10*b1^2*b2*q + 2*T^9*b1^3*b2*q - T^12*q^2 - 3*T^11*b1*q^2 + 3*T^10*b1^2*q^2 - 4*T^9*b1^3*q^2 + T^8*b1^4*q^2 - T^10*b2^3 - T^9*b1*b2^3 + 2*T^9*b1*b2^2*q - 3*T^8*b1^2*b2^2*q + 2*T^10*b2*q^2 - T^9*b1*b2*q^2 + 4*T^8*b1^2*b2*q^2 + 2*T^7*b1^3*b2*q^2 + 2*T^9*b1*q^3 - T^8*b1^2*q^3 - 4*T^7*b1^3*q^3 - T^6*b1^4*q^3 + T^8*b2^4 - T^7*b1*b2^3*q - 3*T^8*b2^2*q^2 + 2*T^7*b1*b2^2*q^2 + T^6*b1^2*b2^2*q^2 - T^7*b1*b2*q^3 - T^6*b1^2*b2*q^3 - T^5*b1^3*b2*q^3 + T^8*q^4 + 2*T^7*b1*q^4 + 3*T^6*b1^2*q^4 + 2*T^5*b1^3*q^4 + T^4*b1^4*q^4 - T^6*b2^3*q^2 + 2*T^5*b1*b2^2*q^3 + 2*T^6*b2*q^4 - 3*T^5*b1*b2*q^4 - 3*T^4*b1^2*b2*q^4 - 3*T^5*b1*q^5 + 2*T^4*b1^2*q^5 - T^3*b1^3*q^5 + T^4*b2^2*q^4 + 2*T^3*b1*b2*q^5 - T^4*q^6 - T^3*b1*q^6 + T^2*b1^2*q^6 - T^2*b2*q^6 - T*b1*q^7 + q^8

| \chi_{V_3(B/F_q^2),q^2}(T^2) = T^16 - T^14*b1_2 + T^12*b1_2^2 - T^12*b2_2 + 2*T^10*b1_2*q^2 - T^10*b1_2*b2_2 - T^8*b1_2^2*q^2 - T^8*q^4 + 2*T^6*b1_2*q^4 + T^8*b2_2^2 - T^6*b1_2*b2_2*q^2 + T^4*b1_2^2*q^4 - T^4*b2_2*q^4 - T^2*b1_2*q^6 + q^8

| \chi_{B/F_q^8,q^8}(T^8) = T^32 + T^24*b1_8 + T^16*b2_8 + T^8*b1_8*q^8 + q^16

| \chi_{V_5(B/F_q^2),q^2}(T^2) = T^32 - T^30*b1_2 + T^28*b1_2^2 - T^26*b1_2^3 - T^28*b2_2 - T^26*b1_2*q^2 + T^24*b1_2^4 + 2*T^26*b1_2*b2_2 + 2*T^24*b1_2^2*q^2 - T^24*q^4 - 3*T^24*b1_2^2*b2_2 + 2*T^22*b1_2^3*q^2 - 3*T^22*b1_2*q^4 - T^22*b1_2^3*b2_2 + T^24*b2_2^2 - T^20*b1_2^4*q^2 - 3*T^22*b1_2*b2_2*q^2 + 3*T^20*b1_2^2*q^4 + 2*T^22*b1_2*b2_2^2 - T^20*b1_2^2*b2_2*q^2 - 4*T^18*b1_2^3*q^4 + 2*T^20*b2_2*q^4 + 2*T^18*b1_2*q^6 + T^20*b1_2^2*b2_2^2 + 2*T^18*b1_2^3*b2_2*q^2 + T^16*b1_2^4*q^4 - T^18*b1_2*b2_2*q^4 - T^16*b1_2^2*q^6 + T^16*q^8 - T^20*b2_2^3 + 2*T^18*b1_2*b2_2^2*q^2 + 4*T^16*b1_2^2*b2_2*q^4 - 4*T^14*b1_2^3*q^6 + 2*T^14*b1_2*q^8 - T^18*b1_2*b2_2^3 - 3*T^16*b1_2^2*b2_2^2*q^2 + 2*T^14*b1_2^3*b2_2*q^4 - 3*T^16*b2_2^2*q^4 - T^12*b1_2^4*q^6 - T^14*b1_2*b2_2*q^6 + 3*T^12*b1_2^2*q^8 + 2*T^14*b1_2*b2_2^2*q^4 - T^12*b1_2^2*b2_2*q^6 + 2*T^10*b1_2^3*q^8 + 2*T^12*b2_2*q^8 - 3*T^10*b1_2*q^10 + T^16*b2_2^4 - T^14*b1_2*b2_2^3*q^2 + T^12*b1_2^2*b2_2^2*q^4 - T^10*b1_2^3*b2_2*q^6 + T^8*b1_2^4*q^8 - 3*T^10*b1_2*b2_2*q^8 + 2*T^8*b1_2^2*q^10 - T^8*q^12 - T^12*b2_2^3*q^4 + 2*T^10*b1_2*b2_2^2*q^6 - 3*T^8*b1_2^2*b2_2*q^8 - T^6*b1_2^3*q^10 - T^6*b1_2*q^12 + T^8*b2_2^2*q^8 + 2*T^6*b1_2*b2_2*q^10 + T^4*b1_2^2*q^12 - T^4*b2_2*q^12 - T^2*b1_2*q^14 + q^16

| \chi_{V_3(B/F_q^4),q^4}(T^4) = T^32 - T^28*b1_4 + T^24*b1_4^2 - T^24*b2_4 + 2*T^20*b1_4*q^4 - T^16*q^8 - T^20*b1_4*b2_4 - T^16*b1_4^2*q^4 + 2*T^12*b1_4*q^8 + T^16*b2_4^2 - T^12*b1_4*b2_4*q^4 + T^8*b1_4^2*q^8 - T^8*b2_4*q^8 - T^4*b1_4*q^12 + q^16
```

## Explicit characteristic polynomials for primitive groups
There is also a script that computes characteristic polynomials for any primitive group V_v(B) or the abelian variety W_{w,1}(V_v(B)):
```sh
sage av_gsplit_charpoly.sage -v [v] -w [w] [dimension]
```

For example the following command computes chi_{V_5(B),q}(T) for dim B = 2.
```sh
sage av_gsplit_charpoly.sage -v 5 2
```

```
\chi_{V_5(B),q}(T) = T^16 - T^15*b1 + T^14*b1^2 - T^13*b1^3 + T^12*b1^4 - T^14*b2 + 2*T^13*b1*b2 - 3*T^12*b1^2*b2 - T^11*b1^3*b2 - T^13*b1*q + 2*T^12*b1^2*q + 2*T^11*b1^3*q - T^10*b1^4*q + T^12*b2^2 + 2*T^11*b1*b2^2 + T^10*b1^2*b2^2 - 3*T^11*b1*b2*q - T^10*b1^2*b2*q + 2*T^9*b1^3*b2*q - T^12*q^2 - 3*T^11*b1*q^2 + 3*T^10*b1^2*q^2 - 4*T^9*b1^3*q^2 + T^8*b1^4*q^2 - T^10*b2^3 - T^9*b1*b2^3 + 2*T^9*b1*b2^2*q - 3*T^8*b1^2*b2^2*q + 2*T^10*b2*q^2 - T^9*b1*b2*q^2 + 4*T^8*b1^2*b2*q^2 + 2*T^7*b1^3*b2*q^2 + 2*T^9*b1*q^3 - T^8*b1^2*q^3 - 4*T^7*b1^3*q^3 - T^6*b1^4*q^3 + T^8*b2^4 - T^7*b1*b2^3*q - 3*T^8*b2^2*q^2 + 2*T^7*b1*b2^2*q^2 + T^6*b1^2*b2^2*q^2 - T^7*b1*b2*q^3 - T^6*b1^2*b2*q^3 - T^5*b1^3*b2*q^3 + T^8*q^4 + 2*T^7*b1*q^4 + 3*T^6*b1^2*q^4 + 2*T^5*b1^3*q^4 + T^4*b1^4*q^4 - T^6*b2^3*q^2 + 2*T^5*b1*b2^2*q^3 + 2*T^6*b2*q^4 - 3*T^5*b1*b2*q^4 - 3*T^4*b1^2*b2*q^4 - 3*T^5*b1*q^5 + 2*T^4*b1^2*q^5 - T^3*b1^3*q^5 + T^4*b2^2*q^4 + 2*T^3*b1*b2*q^5 - T^4*q^6 - T^3*b1*q^6 + T^2*b1^2*q^6 - T^2*b2*q^6 - T*b1*q^7 + q^8
```

## Searching for examples of geometrically split abelian varieties
### Enumeration of Jacobians
The script `examples/jacobians_enum` tries to find examples of geometrically split abelian varieties by curves enumeration. In case of dim B = 1 it enumerates all elliptic curves upto isomorphism, for higher dimension it takes random curves (hyperelliptic by default).

Usage:
```
sage examples/jacobians_enum.sage [-h] [-q Q] [-v] [-s S] [-d D] [-e E] [-V V] [--samples SAMPLES] [--min | --no-min] [--plane-curves | --no-plane-curves] dimension
```

Example (dim A = 11, dim B = 1):
```sh
sage examples/jacobians_enum.sage 11 -q 8 -d 23 -e 1 -V 23
```

```
Assume that A/F_8 is ordinary simple 11-dimensional abelian variety such that A ~ B^11 over F_8^23, where B/F_8 is a simple abelian variety of dimension 1.
A is simple over all proper subfields of F_8^23.
Warning: there is no check for primitivity of B over F_8!
Enumerating all elliptic curves over F_8 up to isomorphism.
Looking for factors of V_23(B) ...

Elliptic Curve defined by y^2 + x*y = x^3 + (z3^2+1) over Finite Field in z3 of size 2^3
F_8 = F_2(z3)/(z3^3 + z3 + 1)
frob_B = T^2 + 3*T + 8
frob_A = T^22 - 13*T^21 + 100*T^20 - 564*T^19 + 2502*T^18 - 9227*T^17 + 29101*T^16 - 80279*T^15 + 200148*T^14 - 467731*T^13 + 1101302*T^12 - 2890733*T^11 + 8810416*T^10 - 29934784*T^9 + 102475776*T^8 - 328822784*T^7 + 953581568*T^6 - 2418802688*T^5 + 5247074304*T^4 - 9462349824*T^3 + 13421772800*T^2 - 13958643712*T + 8589934592
frob_A,q^23 = (T^2 - 13913444829*T + 590295810358705651712)^11
frob_V = (T^22 - 13*T^21 + 100*T^20 - 564*T^19 + 2502*T^18 - 9227*T^17 + 29101*T^16 - 80279*T^15 + 200148*T^14 - 467731*T^13 + 1101302*T^12 - 2890733*T^11 + 8810416*T^10 - 29934784*T^9 + 102475776*T^8 - 328822784*T^7 + 953581568*T^6 - 2418802688*T^5 + 5247074304*T^4 - 9462349824*T^3 + 13421772800*T^2 - 13958643712*T + 8589934592) * (T^22 + 10*T^21 + 31*T^20 - 12*T^19 - 189*T^18 + 479*T^17 + 4399*T^16 + 6362*T^15 - 22860*T^14 - 81860*T^13 + 93281*T^12 + 889547*T^11 + 746248*T^10 - 5239040*T^9 - 11704320*T^8 + 26058752*T^7 + 144146432*T^6 + 125566976*T^5 - 396361728*T^4 - 201326592*T^3 + 4160749568*T^2 + 10737418240*T + 8589934592)
A | V_23(B)

Elliptic Curve defined by y^2 + x*y = x^3 + x^2 + (z3^2+1) over Finite Field in z3 of size 2^3
F_8 = F_2(z3)/(z3^3 + z3 + 1)
frob_B = T^2 - 3*T + 8
frob_A = T^22 - 10*T^21 + 31*T^20 + 12*T^19 - 189*T^18 - 479*T^17 + 4399*T^16 - 6362*T^15 - 22860*T^14 + 81860*T^13 + 93281*T^12 - 889547*T^11 + 746248*T^10 + 5239040*T^9 - 11704320*T^8 - 26058752*T^7 + 144146432*T^6 - 125566976*T^5 - 396361728*T^4 + 201326592*T^3 + 4160749568*T^2 - 10737418240*T + 8589934592
frob_A,q^23 = (T^2 + 13913444829*T + 590295810358705651712)^11
frob_V = (T^22 - 10*T^21 + 31*T^20 + 12*T^19 - 189*T^18 - 479*T^17 + 4399*T^16 - 6362*T^15 - 22860*T^14 + 81860*T^13 + 93281*T^12 - 889547*T^11 + 746248*T^10 + 5239040*T^9 - 11704320*T^8 - 26058752*T^7 + 144146432*T^6 - 125566976*T^5 - 396361728*T^4 + 201326592*T^3 + 4160749568*T^2 - 10737418240*T + 8589934592) * (T^22 + 13*T^21 + 100*T^20 + 564*T^19 + 2502*T^18 + 9227*T^17 + 29101*T^16 + 80279*T^15 + 200148*T^14 + 467731*T^13 + 1101302*T^12 + 2890733*T^11 + 8810416*T^10 + 29934784*T^9 + 102475776*T^8 + 328822784*T^7 + 953581568*T^6 + 2418802688*T^5 + 5247074304*T^4 + 9462349824*T^3 + 13421772800*T^2 + 13958643712*T + 8589934592)
A | V_23(B)
...
```

### Enumeration of Weil polynomials
The isogeny factors of Weil restriction W_{d,1}(B) can be non-Jacobians. To find such examples of geometrically split abelian varieties, we can enumerate all Weil polynomials for some small field order q. This can be done by the following script.

```
sage examples/weil_polynomials_enum.sage [-h] [-q Q] [-v] [--ordinary | --no-ordinary] [--simple | --no-simple] [--root | --no-root] [--gsplit | --no-gsplit] [-d D] dimension

This is a script to enumerate Weil polynomials satisfying given conditions.

positional arguments:
  dimension             dimension of an abelian varity.

options:
  -h, --help            show this help message and exit
  -q Q                  order of the base finite field
  -v                    enable verbose mode
  --ordinary, --no-ordinary
                        enumerate ordinary Weil polynomials
  --simple, --no-simple
                        enumerate irreducible Weil polynomials
  --root, --no-root     look for abelian variety A s.t. pi_A \in -4 Q[pi_A].
  --gsplit, --no-gsplit
                        look for Weil polynomials of geometrically split abelian varieties.
  -d D                  splitting degree bound to look for (default: 2*dim)

```

Example for dimension 6 and q = 2:
```shell
sage examples/weil_polynomials_enum.sage 6 -q 2 --simple --gsplit --ordinary -d 7 -v
```
```
Generating the list of all Weil polynomials of degree 12 over the finite field GF(2) ... 164937 found [ok]
Looking for ones satisfying conditions:
* ordinary: True
* simple: True
* pi_A \in -4*Q[pi_A]: False
* gsplit: True (degree: 7)

T^12 - 3*T^11 + 13*T^9 - 18*T^8 - 14*T^7 + 57*T^6 - 28*T^5 - 72*T^4 + 104*T^3 - 96*T + 64, degree (min) = 7, frob_B,q^7 = T^6 - 5*T^5 - 65*T^4 + 189*T^3 - 8320*T^2 - 81920*T + 2097152, s = 2
T^12 - 4*T^11 + 7*T^10 - 6*T^9 + 3*T^8 - 7*T^7 + 15*T^6 - 14*T^5 + 12*T^4 - 48*T^3 + 112*T^2 - 128*T + 64, degree (min) = 7, frob_B,q^7 = T^4 - 13*T^3 + 41*T^2 - 1664*T + 16384, s = 3
T^12 - 4*T^11 + 7*T^10 - 6*T^9 - 4*T^8 + 28*T^7 - 55*T^6 + 56*T^5 - 16*T^4 - 48*T^3 + 112*T^2 - 128*T + 64, degree (min) = 7, frob_B,q^7 = T^6 + 5*T^5 - 65*T^4 - 189*T^3 - 8320*T^2 + 81920*T + 2097152, s = 2
T^12 - 5*T^11 + 9*T^10 - 7*T^9 + 3*T^8 - T^7 - T^6 - 2*T^5 + 12*T^4 - 56*T^3 + 144*T^2 - 160*T + 64, degree (min) = 7, frob_B,q^7 = T^6 + T^5 - 73*T^4 + 815*T^3 - 9344*T^2 + 16384*T + 2097152, s = 2
T^12 - 3*T^11 + 7*T^10 - 8*T^9 + 3*T^8 + 14*T^7 - 27*T^6 + 28*T^5 + 12*T^4 - 64*T^3 + 112*T^2 - 96*T + 64, degree (min) = 7, frob_B,q^7 = T^4 + 13*T^3 + 41*T^2 + 1664*T + 16384, s = 3
T^12 - 3*T^11 + 7*T^10 - 15*T^9 + 31*T^8 - 49*T^7 + 71*T^6 - 98*T^5 + 124*T^4 - 120*T^3 + 112*T^2 - 96*T + 64, degree (min) = 7, frob_B,q^7 = T^6 - 5*T^5 - 65*T^4 + 189*T^3 - 8320*T^2 - 81920*T + 2097152, s = 2
T^12 - 2*T^11 + 2*T^10 + 3*T^8 - 6*T^7 + 13*T^6 - 12*T^5 + 12*T^4 + 32*T^2 - 64*T + 64, degree (min) = 7, frob_B,q^7 = T^6 - T^5 - 73*T^4 - 815*T^3 - 9344*T^2 - 16384*T + 2097152, s = 2
T^12 - 2*T^11 + 2*T^10 - 7*T^9 + 10*T^8 - 13*T^7 + 27*T^6 - 26*T^5 + 40*T^4 - 56*T^3 + 32*T^2 - 64*T + 64, degree (min) = 7, frob_B,q^7 = T^6 - T^5 - 73*T^4 - 815*T^3 - 9344*T^2 - 16384*T + 2097152, s = 2
...
```
