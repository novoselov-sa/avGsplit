import sys
import argparse
from types import SimpleNamespace

load("frobs.sage")

def check_dimension(value):
    ivalue = ZZ(value)
    if ivalue <= 1:
        raise argparse.ArgumentTypeError(f"dimension must be > 1")
    return ivalue

parser = argparse.ArgumentParser(description='This is a script to find examples of characteristic polynomials of the Frobenius of a geometrically split ordinary abelian variety A/Fq. The script tries to find A s.t. A/Fq^d ~ B^s and A is a component of the Weil restriction.')
parser.add_argument("dimension", type=check_dimension, help='dimension of a geometrically split ordinary abelian variety A.')
parser.add_argument("-q", dest="q", type=Integer, help='order of the base finite field')
parser.add_argument("-v", dest="verbose", action=argparse.BooleanOptionalAction, default=False, help="enable verbose mode")
parser.add_argument("-s", dest="s", type=Integer, help='exponent in splitting of A')
parser.add_argument("-d", dest="d", type=Integer, help='splitting degree')
parser.add_argument("-e", dest="e", type=Integer, help='extension degree, such that B is defined over F_q^e')
parser.add_argument("-V", required=False, dest="V", type=Integer, help='primitive group parameters.')
parser.add_argument("--samples", dest="samples", type=Integer, default=1000, help='number of random curves to check')
parser.add_argument("--min", dest="minimal", action=argparse.BooleanOptionalAction, default=True, help="is splitting degree minimal or not")
parser.add_argument("--plane-curves", dest="plane_curves", action=argparse.BooleanOptionalAction, default=False, help="sample random smooth plane curves (slow)")

args = parser.parse_args()
if args.s == None:
    args.s = args.dimension
elif args.s < 2:
    print("Error: parameter s must be >= 2")
    exit()

if args.q == None:
    args.q = random_prime(2^8)

if args.d == None:
    args.d = args.dimension
elif args.d < 2:
    print("Error: parameter d must be >= 2")
    exit()

if args.e == None:
    args.e = args.d
elif mod(args.d, args.e) != 0:
    print(f"Error: F_{args.q}^{args.e} must be subfield of F_{args.q}^{args.d}")
    exit()
elif args.e == 1 and args.V == None:
    print(f"Error: the primitive group is required for e = 1 (use -V argument)")
    exit()

def HEC(f):
    try:
        res = HyperellipticCurve(f)
    except ValueError:
        return 'singular'
    return res

def HEC_random(genus, q, imag=None):
    Fq = GF(q)
    R.<x> = Fq['x']
    if imag == None:
        imag = sample([True, False],1)[0]
    d = 0
    while d == 0:
        pol = 0
        if imag:
            pol = R.random_element(degree=2*genus+1).monic()
        else:
            pol = R.random_element(degree=2*genus+2).monic()
        d = pol.discriminant()
        if d == 0:
            continue
        if Fq.characteristic() == 2:
            h = R.random_element(degree=genus+1)
        else:
            h = 0
        try:
            C = HyperellipticCurve(pol,h)
        except ValueError:
            d = 0
    return C

def plane_curve_random(genus, q):
    # from Genus-degree formula
    degr = ceil((sqrt(8*genus+1)+3)/2)
    R = PolynomialRing(GF(q), 2, 'xy')

    while True:
        f = R.random_element(degree=degr).homogenize(var="z")
        if f.degree() != degr:
            continue
        C = Curve(f)
        if C.is_irreducible() and C.arithmetic_genus() == genus and C.is_smooth():
            return C

def minimal_splitting_degree(frob, d, q):
    if frob.factor()[0][1] > 1:
        return 1
    for r in divisors(d)[1:]:
        frobr = frob_k_from_frob(frob, r, q)
        if frobr.factor()[0][1] > 1:
            return r
    return None

g = args.dimension
dimB = ZZ(g/args.s)
Fqe = GF(args.q^args.e)
if args.V != None:
    dimV = ZZ(euler_phi(args.V) * g / args.s)

W_label = "B"
if args.V != None:
    W_label = f"V_{args.V}({W_label})"
if args.e > 1:
    W_label = f"W_{{{args.e},1}}({W_label})"

if args.e == 1:
    Fqe_label = f"F_{args.q}"
else:
    Fqe_label = f"F_{args.q}^{args.e}"


R = init(g, set([args.e, args.d]))

print(f"Assume that A/F_{args.q} is ordinary simple {g}-dimensional abelian variety such that A ~ B^{args.s} over F_{args.q}^{args.d}, where B/{Fqe_label} is a simple abelian variety of dimension {dimB}.")
if args.d > 2:
    if args.minimal:
        print(f"A is simple over all proper subfields of F_{args.q}^{args.d}.")
    else:
        print(f"A can be split over a proper subfield of F_{args.q}^{args.d}.")

curves = set()

def check_frob(pol):
    '''
    Given chi_B,q^e(T) computes chi_W_{e,1}(V_r(B)) and checks that it contains a factor chi_{A,q} of degree 2 g with splitting degree d.
    '''
    res = SimpleNamespace(frob_B = pol)
    pols = []
    frob = pol
    if args.V != None:
        frobV = frob_primitive_group2(dimB, args.V, args.q, R, pol=frob)
        frob = frobV
    else:
        frobV = None
    res.frob_V = frobV
    if args.e > 1:
        frobW = frob.subs({T: T^args.e})
        frob = frobW
    else:
        frobW = None
    res.frob_W = frobW
    for frobA, ex in frob.factor():
        if frobA.degree(T) == 2*g:
            frobAd = frob_k_from_frob(frobA, args.d, args.q)
            # check that A ~ B^s over F_q^d
            F = frobAd.factor()
            if len(F) == 1 and F[0][1] == args.s:
                r = minimal_splitting_degree(frobA, args.d, args.q)
                if r == args.d:
                    res.frob_A = frobA
                    res.frob_Ad = frobAd
                    res.frob_min = frobAd
                    res.min_deg = args.d
                    pol_d = frob_k_from_frob(pol, ZZ(args.d / args.e), args.q^args.e)
                    res.twist = (frobAd.mod(pol_d) != 0)
                    res.check = True
                    return res
                elif not args.minimal and r != None:
                    res.frob_A = frobA
                    res.frob_Ad = frobAd
                    res.frob_min = frob_k_from_frob(frobA, r, args.q)
                    res.min_deg = r
                    pol_r = frob_k_from_frob(pol, ZZ(args.r / args.e), args.q^args.e)
                    res.twist = (frobAd.mod(pol_r) != 0)
                    res.twist = (mod(res.frob_min, pol) != 0)
                    res.check = True
                    return res
    res.check = False
    return res

def print_result(curve, res):
    print(f"{curve}")
    if not curve.base_ring().order().is_prime():
        print(f"{Fqe_label} = F_{curve.base_ring().characteristic()}({Fqe.gens()[0]})/({Fqe.polynomial()})")
    print(f"frob_B = {res.frob_B.factor()}")
    print(f"frob_A = {res.frob_A.factor()}")
    print(f"frob_A,q^{args.d} = {res.frob_Ad.factor()}")
    if not args.minimal and args.d != res.min_deg:
        print(f"minimal splitting degree is {res.min_deg}")
        print(f"frob_A,q^{res.min_deg} = {res.frob_min.factor()}")
    if res.frob_V != None and res.frob_W != None:
        print(f"frob_V = {res.frob_V}")
        print(f"frob_W = {res.frob_W}")
        if g == args.e * dimV:
            print(f"A ~ W_{args.e},1(V_{args.V}(B))")
        else:
            print(f"A | W_{args.e},1(V_{args.V}(B))")
    elif res.frob_V != None:
        print(f"frob_V = {res.frob_V.factor()}")
        if g == dimV:
            print(f"A ~ V_{args.V}(B)")
        else:
            print(f"A | V_{args.V}(B)")
    elif res.frob_W != None:
        print(f"frob_W = {res.frob_W}")
        if g == args.e * dimB:
            print(f"A ~ W_{args.e},1(B)")
        else:
            print(f"A | W_{args.e},1(B)")
    if res.twist:
        print(f"B is a twist of B' and A ~ B'^{args.s}")
    print(flush=True)

print(f"Warning: there is no check for primitivity of B over {Fqe_label}!")
if dimB == 1:
    print(f"Enumerating all elliptic curves over {Fqe_label} up to isomorphism.")
elif args.plane_curves:
    print(f"Enumerating smooth plane curves over {Fqe_label}.")
else:
    print(f"Enumerating hyperelliptic curves over {Fqe_label}.")

print(f"Looking for factors of {W_label} ...\n")

if dimB == 1:
    for jE in Fqe:
        E_base = EllipticCurve_from_j(jE)
        if not E_base.is_ordinary():
            continue
        twists = set([E_base] + E_base.twists())
        for E in twists:
            frobE = E.frobenius_polynomial()(T)
            res = check_frob(frobE)
            if res.check:
                print_result(E, res)
elif args.plane_curves:
    for i in range(args.samples):
        C = plane_curve_random(dimB, args.q^args.e)
        if C in curves:
            continue
        curves.add(C)
        frobC = (T^(2*dimB) * C.L_polynomial()(1/T)).numerator()
        ag = frobC.coefficient({T: dimB})
        if mod(ag, C.base_ring().characteristic()) == 0:
            # the curve C is not ordinary
            continue
        res = check_frob(frobC)
        if res.check:
            print_result(C, res)
else:
    for i in range(args.samples):
        C = HEC_random(dimB, args.q^args.e)
        if C == 'singular' or C in curves:
            continue
        curves.add(C)
        frobC = C.frobenius_polynomial()(T)
        ag = frobC.coefficient({T: dimB})
        if mod(ag, C.base_ring().characteristic()) == 0:
            # the curve C is not ordinary
            continue
        res = check_frob(frobC)
        if res.check:
            print_result(C, res)

if dimB > 1:
    print(f"\nChecked {len(curves)} curves.")
