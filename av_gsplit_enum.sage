import argparse

load("av.sage")
load("prim_group.sage")
load("weil_res.sage")
load("av_gsplit.sage")
load("endomorphisms.sage")

def print_log(str, verbose=None, end=None):
    if verbose == None:
        verbose = args.verbose
    if verbose:
        print(str, end=end)

def check_dimension(value):
    ivalue = ZZ(value)
    if ivalue <= 1:
        raise argparse.ArgumentTypeError(f"dimension must be > 1")
    return ivalue

parser = argparse.ArgumentParser(description='This is a script to enumerate possible characteristic polynomials of the Frobenius of geometrically split ordinary abelian varieties.')
parser.add_argument("dimension", type=check_dimension, help='dimension of a geometrically split ordinary abelian variety A.')
parser.add_argument("-v", dest="verbose", action=argparse.BooleanOptionalAction, default=False, help="enable verbose mode")
parser.add_argument("--subfields", "-s", dest="subfields", action=argparse.BooleanOptionalAction, default=False, help="append data about structure of A over all subfields of F_q^d to the table")
#parser.add_argument("--endomorphisms", "-e", dest="endomorphisms", action=argparse.BooleanOptionalAction, default=False, help="append extended data about endomorphisms algebras to the table")
#parser.add_argument("--restrictions", "-r", dest="restrictions", action=argparse.BooleanOptionalAction, default=False, help="compute restrictions (system of equations) on coefficients of Frobenius polynomial if available")
parser.add_argument("--frobs", dest="frobs", action=argparse.BooleanOptionalAction, default=False, help="print characteristic polynomials")


args = parser.parse_args()

gp.read("invphi.gp")
def inverse_phi(n):
    return vector(ZZ, list(gp.invphi(n)))

def subfields_degrees(d):
    return divisors(d)

def case2_degrees(g):
    D = []
    for s in divisors(g)[1:]:
        for zdeg in range(s, 2*g+1):
            if mod(zdeg, s) != 0:
                continue

            if mod(2*g, zdeg) != 0:
                continue

            for d in inverse_phi(zdeg):
                if zdeg != 2*g or (zdeg == 2*g and mod(s, 2) == 1):
                    D += [(d,s)] 
    return D

def subfields(d):
    # Enumeration of all compatible variants for fields of definitions of B in subfields of F_{q^d}.
    res = []
    D = divisors(d)[:-1]
    for i in range(2^len(D)):
        L0 = ZZ(i).bits()
        if len(L0) < len(D):
            L0 = L0 + [0] * (len(D) - len(L0))
        L = {}
        for j in range(len(D)):
            L[D[j]] = L0[j]
        for v in D:
            if L[v] == 0:
                for v0 in divisors(v):
                    if L[v0] != 0:
                        L = None
                        break
            else:
                for v0 in divisors(d/v):
                    if v*v0 == d:
                        continue
                    if L[v*v0] != 1:
                        L = None
                        break
            if L == None:
                break
        if L != None:
            res.append(L)
    return res

def av_gsplit_enum(g, s, d):
    # Enumeration of possible simple geometrically split abelian varieties A of dimension g s.t.
    # 1) A ~ B^s over F_{q^d} for simple B
    # 2) A is simple over all proper subfields of F_{q^d}.

    LL = subfields(d)
    res = []
    for L in LL:
        G = {}
        for v in divisors(d)[:-1]:
            G[v] = []
            # B is defined over F_{q^v}
            if L[v] == 1 and euler_phi(d/v) * g/s >= g:
                B = AV(g/s, v, "B")
                A = PrimGroup(B, d/v)
                AGS = AVGsplit(g, d, s, A, B, G)
                G[v].append(AGS)
            # B is undefined over F_{q^v}
            if L[v] == 0:
                u = d
                for v0 in divisors(d/v):
                    if v*v0 == d:
                        continue
                    if L[v*v0] == 1:
                        u = v*v0
                        break
                # at this point B is primitive over F_{q^u}
                B = AV(g/s, u, "B")
                if u == d:
                    # B is primitive over F_{q^d}
                    W = WeilRes(B, u, v)
                    if mod(d/v, 4) != 0 and W.dim() == g:
                        AGS = AVGsplit(g, d, s, W, B, G)
                        G[v].append(AGS)
                    elif mod(d/v, 4) == 0:
                        if W.dim() == g:
                            W.conditions += ["pi_B ∉ -4Q[pi_B]^4"]
                            AGS = AVGsplit(g, d, s, W, B, G)
                            AGS.conditions += ["pi_B ∉ -4Q[pi_B]^4"]
                            G[v].append(AGS) # pi_B not in -4Q[pi_B]^4
                        if W.dim()/2 >= g:
                            W.conditions += ["pi_B ∈ -4Q[pi_B]^4"]
                            AGS = AVGsplit(g, d, s, W, B, G)
                            AGS.conditions += ["pi_B ∈ -4Q[pi_B]^4"]
                            G[v].append(AGS) # pi_B in -4Q[pi_B]^4
                else:
                    V = PrimGroup(B, ZZ(d/u))
                    W = WeilRes(V, u, v)
                    AGS = AVGsplit(g, d, s, W, B, G)
                    G[v].append(AGS)
            if G[v] == []:
                G = None
                #print(f"Excluded case: dim B = {g/s}, L = {L}, there is no factor in W({u},{v}) decomposition for d = {d} and degree {v} subfield and e = {u}")
                break
        if G != None:
            for AGS in G[1]:
                res.append(AGS)
    return res

def print_log_av(A):
    print_log(f"A ~ {A}", end="")
    if A.B.r > 1:
        print_log(f", B is primitive over F_q^{A.B.r}", end="")
    else:
        print_log(f", B is primitive over F_q", end="")  
    if A.End0 != None:
        print_log(f", End0(A) = {A.End0[0]}", end="")

    if len(A.conditions) > 0:
        print_log(", " + A.conditions_str())
    else:
        print_log("")
    
    if A.B.End0 != None:
        print_log("\nPossible End0(B): ")
        for EB in A.B.End0:
            print_log(f"-> {EB}")

    if len(A.subfields.items()) > 1:
        print_log("\nSubfields:")
        for v,avs in A.subfields.items():
            if v != 1:
                for A_v in avs:
                    intermediate = [vv for vv in divisors(A_v.B.r)[1:-1] if mod(vv, v)==0]
                    if len(intermediate) == 0:
                        print_log(f"-> A/F_q^{v} ~ {A_v}, B is defined over F_q^{A_v.B.r}", end="")
                    elif len(intermediate) == 1:
                        print_log(f"-> A/F_q^{v} ~ {A_v}, B is defined over F_q^{A_v.B.r} and it is undefined over F_q^{intermediate[0]}", end="")
                    else:
                        print_log(f"-> A/F_q^{v} ~ {A_v}, B is defined over F_q^{A_v.B.r} and it is undefined over F_q^k for k in {intermediate}", end="")
                    if len(A_v.conditions) > 0:
                        print_log(", " + A_v.conditions_str())
                    else:
                        print_log("")

def case1(g):
    res = []
    D = divisors(g)[1:]
    for d in D:
        if not d.is_prime():
            #print_log(f"d = {d} is not prime, A is split over some proper subfield of F_q^d.\n")
            continue

        print_log(f"-------- The characteristic polynomial belongs to Z[T^{d}] --------")

        for s in divisors(g)[1:]:
            if s != d:
                #print(f"s = {s} != d = {d}, A is split over some proper subfield of F_q^d.")
                continue

            print_log(f"A/F_q^{d} ~ B^{s}, dim B = {g/s}")
            AVS = av_gsplit_enum(g, s, d)
            res += AVS
            for A in AVS:
                print_log_av(A)
                print_log("\n")
    return res

def case2(g):
    res = []
    exts = case2_degrees(g)

    print_log(f"-------- Q[pi] = Q[pi_B^d, zeta_d] --------")
    print_log(f"d belongs to {set([d for d,s in exts])}\n")
    for d,s in exts:
        AVS = av_gsplit_enum(g, s, d)
        if AVS != []:
            print_log("+" * 40)
            print_log(f"A/F_q^{d} ~ B^{s}, dim B = {g/s}")
            zdeg = euler_phi(d)
            inter_dg = zdeg/s
            for A in AVS:
                if 2 * g == zdeg:
                    A.End0 = [f"Q(\\zeta_{d})"]
                    endBs,conds = endB_cyc_enum(g, s, d)
                else:
                    A.End0 = [f"Q(\\pi^{d}, \\zeta_{d})"]
                    if inter_dg > 1:
                        endBs,conds = endB_intersection_enum(g, s, d)
                    else:
                        endBs = None
                if endBs != None:
                    A.B.End0 = []
                    for i in range(len(endBs)):
                        if len(conds[i]) >= 1:
                             A.B.End0.append(f"{numfield_label(endBs[i], deg=2*g/s)}, {conds[i]}")
                        else:
                            A.B.End0.append(f"{numfield_label(endBs[i], deg=2*g/s)}")
                print_log_av(A)
                print_log("\n")

                #TODO: filter out AVs basing on field of definitions
            if inter_dg > 1 and AVS[0].B.End0 == []:
                print_log("There are no suitable endomorphism rings!\n")
            else:
                res += AVS
    return res

def print_frobs(res):
    print("Characteristic polynomials from the table:")
    res = sorted(res, key=lambda f: (f.splitting_degree(), f.fact().dim(), f.fact().base_field_deg()))
    for A in res:
        print(f"{A.frob_label()} = {A.frob()}\n", flush=True)

def print_table(g, res):
    caption = ["d", "A", "A/F_{q^d}", "e", "g_B", "chi_A,q(T)", "conditions"] 
    rows = [caption]
    res = sorted(res, key=lambda f: (f.splitting_degree(), f.fact().dim(), f.fact().base_field_deg()))
    for A in res:
        conditions = A.conditions.copy()
        if args.subfields:
            for v, avs in A.subfields.items():
                if v == 1:
                    continue
                lst = []
                for G in avs:
                    lst.append(f"{G}")
                if len(lst) == 1:
                    conditions += [f"A/F_q^{v} ~ {lst[0]}"]
                else:
                    conditions += [f"A/F_q^{v} ~ {lst}"]
        if len(conditions) == 0:
            conds = ""
        else:
            conds = ", ".join(conditions)
        B = A.fact()
        rows.append([A.splitting_degree(), A, f"B^{g/B.dim()}", f"{B.base_field_deg()}", f"{B.dim()}", f"{A.frob_label()}", f"{conds}"])
    print(table(rows, header_row=True))

g = args.dimension

res = case1(g) + case2(g)

print_table(g, res)

print("", flush=True)

if args.frobs:
    print_frobs(res)
