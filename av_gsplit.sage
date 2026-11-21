load("av.sage")
load("frobs.sage")

class AVGsplit(AV):
    def __init__(self,g,d,s,A,B,subfields,r=1):
        '''
        Initializes a geometrically split abelian variety.
        '''
        self.s = s
        self.d = d
        self.B = B
        self.A = A
        self.subfields = subfields
        super().__init__(g, r, label=f"G")
    
    def dim(self):
        return self.A.dim()
    
    def splitting_degree(self):
        return self.d
    
    def fact(self):
        return self.B

    def __repr__(self):
        if self.A.dim() == self.g:
            return f"{self.A}"
        return f"| {self.A}"
    
    def frob(self, ring=None):
        if self._frob != None:
            return self._frob

        var = self.B.label.lower()
        if ring == None:
            ring = init_ring(self.B.g, exts=[self.B.base_field_deg()], var=var)

        return self.A.frob(ring=ring)

    def frob_label(self):
        if self.A.dim() == self.g:
            return f"{self.A.frob_label()}"
        return f"| {self.A.frob_label()}"