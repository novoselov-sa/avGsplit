load("av.sage")

class PrimGroup(AV):
    def __init__(self,B,e):
        '''
        Initializes a primitive subgroup V_e(B) of Weil restriction W(F_q^d, F_q, B) for some e | d and an g-dimensional abelian variety B. Assumes that B is defined (upto isogeny) over F_q.
        '''
        self.e = e
        self.B = B
        self._frob = None
        super().__init__(euler_phi(self.e) * B.dim(), B.base_field_deg(), label=f"V_{self.e}({B})")

    def __repr__(self):
        return f"V_{self.e}({self.B})"
    
    def base_av(self):
        return self.B
    
    def frob(self, ring=None):
        var = self.B.label[0].lower()
        if ring == None:
            ring = init_ring(self.B.g, exts=[self.B.r], var=var)
        q0 = ring('q')
        pol = self.B.frob(ring)
        self._frob = frob_primitive_group2(self.B.dim(), self.e, q0, ring, k=self.base_field_deg(), pol=pol)
        return self._frob
    
    def frob_label(self):
        if self.e == 1:
            G = f"{self.B}"
        else:
            G = f"V_{self.e}({self.B})"
        dg = self.base_field_deg()
        if dg == 1:
            return f"\\chi_{{{G},q}}(T)"
        else:
            return f"\\chi_{{{G},q^{dg}}}(T)"