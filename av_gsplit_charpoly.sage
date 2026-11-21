import sys
import argparse
from types import SimpleNamespace

load("av.sage")
load("weil_res.sage")
load("frobs.sage")

def check_dimension(value):
    ivalue = ZZ(value)
    if ivalue < 1:
        raise argparse.ArgumentTypeError(f"dimension must be > 0")
    return ivalue

parser = argparse.ArgumentParser(description='This is a script to compute characteristic polynomials of the Frobenius endomorphism of W_{w,1}(V_{v}(B/F_q^e)) as elements of symbolic ring.')
parser.add_argument("dimension", type=check_dimension, help='dimension of B.')
parser.add_argument("-q", dest="q", type=Integer, help='order of the base finite field')
parser.add_argument("-e", dest="e", default=1, type=Integer, help='extension degree, such that B is defined over F_q^e')
parser.add_argument("-v", required=False, dest="v", type=Integer, help='primitive group parameter.')
parser.add_argument("-w", required=False, dest="w", type=Integer, help='Weil restriction parameter.')

args = parser.parse_args()

R = init(args.dimension, exts=[args.e], var="b")

A = AV(args.dimension, r=args.e, label='B')

if args.v != None:
    A = PrimGroup(A, args.v)

if args.w != None:
    A = WeilRes(A, args.w, 1)

frob = A.frob(ring=R)

q0 = R("q")
if args.q != None:
    frob = frob.subs({q0: args.q})

print(f"{A.frob_label()} = {frob}")