import argparse

load("frobs.sage")

def check_dimension(value):
    ivalue = ZZ(value)
    if ivalue <= 1:
        raise argparse.ArgumentTypeError(f"dimension must be > 1")
    return ivalue
from types import SimpleNamespace

def minimal_splitting_degree(frob, d, q):
    if frob.factor()[0][1] > 1:
        return 1
    for r in divisors(d)[1:]:
        frobr = frob_k_from_frob(frob, r, q)
        if frobr.factor()[0][1] > 1:
            return r
    return None

parser = argparse.ArgumentParser(description='This is a script to enumerate Weil polynomials satisfying given conditions.')
parser.add_argument("dimension", type=check_dimension, help='dimension of an abelian varity.')
parser.add_argument("-q", dest="q", type=Integer, default=2, help='order of the base finite field')
parser.add_argument("-v", dest="verbose", action=argparse.BooleanOptionalAction, default=False, help="enable verbose mode")
parser.add_argument("--ordinary", dest="ordinary", action=argparse.BooleanOptionalAction, default=False, help="enumerate ordinary Weil polynomials")
parser.add_argument("--simple", dest="simple", action=argparse.BooleanOptionalAction, default=False, help="enumerate irreducible Weil polynomials")
parser.add_argument("--root", dest="root", action=argparse.BooleanOptionalAction, default=False, help="look for abelian variety A s.t. pi_A \\in -4 Q[pi_A].")
parser.add_argument("--gsplit", dest="gsplit", action=argparse.BooleanOptionalAction, default=False, help="look for Weil polynomials of geometrically split abelian varieties.")
parser.add_argument("-d", dest="d", type=Integer, help='splitting degree bound to look for (default: 2*dim)')

args = parser.parse_args()

if args.d == None:
    args.d = 2 * args.dimension

g = args.dimension
q = args.q
F = GF(q)
p = F.characteristic()

if args.verbose:
    print(f"Generating the list of all Weil polynomials of degree {2*g} over the finite field GF({q.factor()}) ... ", end="", flush=True)

P.<T> = QQ[]
L=P.weil_polynomials(2*g, q)

if args.verbose:
    print(f"{len(L)} found [ok]")

if args.verbose:
    print(f"Looking for ones satisfying conditions:\n* ordinary: {args.ordinary}\n* simple: {args.simple}\n* pi_A \\in -4*Q[pi_A]: {args.root}\n* gsplit: {args.gsplit} (degree: {args.d})\n", flush=True)

for f in L:
    f = f / f.lc()

    if args.simple and (not f.is_irreducible()):
        continue

    if args.ordinary:
        ag = f.coefficient(g)
        if mod(ag, p) == 0:
            continue

    if args.root:
        K.<b> = NumberField(f)
        u = -b/4
        if not u.is_nth_power(4):
            continue

    if args.gsplit:
        k = minimal_splitting_degree(f, args.d, q)
        if k == None:
            continue

    if args.verbose and args.gsplit:
        f_k = frob_k_from_frob(f, k, q)
        #print(f"{f_k} = f_k.factor() = {f_k.factor()}")
        print(f"{f}, degree (min) = {k}, frob_B,q^{k} = {f_k.factor()[0][0]}, s = {f_k.factor()[0][1]}")
    else:
        print(f)

    #print(f"-> f_9 = {frob_k_from_frob(f, 9, q).factor()}")
