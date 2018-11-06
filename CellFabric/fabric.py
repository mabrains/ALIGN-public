
import json

def write_global_routing_json( fp, terminals):
    data = { 'bbox' : [0,0,10000,10000], 'globalRoutes' : [], 'globalRouteGrid' : [], 'terminals' : terminals}
    fp.write( json.dumps( data, indent=2) + '\n')


class StopPointGrid:
    def __init__( self, nm, layer, direction, *, width, pitch, offset=0):
        self.nm = nm
        self.layer = layer
        self.direction = direction
        assert direction in ['v','h']
        self.width = width
        self.pitch = pitch
        self.offset = offset
        assert pitch > width > 0

        self.grid = []
        self.legalStopVector = []
        self.legalStopIndices = set()

    def addGridPoint( self, value, isLegal):
        self.grid.append( value)
        self.legalStopVector.append( isLegal)
        if isLegal:
            self.legalStopIndices.add( len(self.grid)-1)

    @property
    def n( self):
        return len(self.grid)-1

    def value( self, idx):
        whole = idx // self.n
        fract = idx % self.n
        while fract < 0:
            whole -= 1
            fract += self.n
        assert fract in self.legalStopIndices
        return whole * self.grid[-1] + self.grid[fract]

    def segment( self, netName, center, bIdx, eIdx):
        c = center*self.pitch + self.offset
        c0 = c - self.width//2
        c1 = c + self.width//2
        if self.direction == 'h':
            rect = [ self.value(bIdx), c0, self.value(eIdx), c1]
        else:
            rect = [ c0, self.value(bIdx), c1, self.value(eIdx)]
        return { 'netName' : netName, 'layer' : self.layer, 'rect' : rect}

class UnitCell:

    @property
    def m0Grid( self): return self.m0.grid
    @property
    def m0GridStopIndices( self): return self.m0.legalStopIndices
    @property
    def m1Grid( self): return self.m1.grid
    @property
    def m1GridStopIndices( self): return self.m1.legalStopIndices
    @property
    def polyGrid( self): return self.poly.grid
    @property
    def polyGridStopIndices( self): return self.poly.legalStopIndices
    @property
    def diffconGrid( self): return self.diffcon.grid
    @property
    def diffconGridStopIndices( self): return self.diffcon.legalStopIndices

    def __init__( self):
        self.terminals = []

        self.m0Pitch    = 360
        self.m1Pitch    = 720 
        self.polyPitch  = 720
        self.diffconPitch  = 720

        self.m1Width = 400
        self.m0Width = 200
        self.diffconWidth = 200
        self.polyWidth = 200

        stoppoint = (self.diffconWidth//2 + self.polyOffset-self.polyWidth//2)//2
        self.m0 = StopPointGrid( 'm0', 'metal0', 'h', width=self.m0Width, pitch=self.m0Pitch)
        self.m0.addGridPoint( 0,                           False)
        self.m0.addGridPoint( stoppoint,                   True)
        self.m0.addGridPoint( self.polyOffset,             False)
        self.m0.addGridPoint( self.diffconPitch-stoppoint, True)
        self.m0.addGridPoint( self.diffconPitch,           False)

        stoppoint = (self.m0Width//2 + self.m0Pitch-self.m0Width//2)//2
        self.m1 = StopPointGrid( 'm1', 'metal1', 'v', width=self.m1Width, pitch=self.m1Pitch)
        self.m1.addGridPoint( 0,                        False)
        self.m1.addGridPoint( stoppoint,                True)
        self.m1.addGridPoint( 2*self.m0Pitch,           False)
        self.m1.addGridPoint( 4*self.m0Pitch-stoppoint, True)
        self.m1.addGridPoint( 4*self.m0Pitch,           False)

        self.poly = StopPointGrid( 'poly', 'poly', 'v', width=self.polyWidth, pitch=self.polyPitch, offset=self.polyOffset)
        self.poly.addGridPoint( 0,                        False)
        self.poly.addGridPoint( stoppoint,                True)
        self.poly.addGridPoint( 2*self.m0Pitch,           False)
        self.poly.addGridPoint( 4*self.m0Pitch-stoppoint, True)
        self.poly.addGridPoint( 4*self.m0Pitch,           False)

        self.diffcon = StopPointGrid( 'diffcon', 'diffcon', 'v', width=self.diffconWidth, pitch=self.diffconPitch)
        self.diffcon.addGridPoint( 0,                        False)
        self.diffcon.addGridPoint( stoppoint,                True)
        self.diffcon.addGridPoint( 2*self.m0Pitch,           False)
        self.diffcon.addGridPoint( 4*self.m0Pitch-stoppoint, True)
        self.diffcon.addGridPoint( 4*self.m0Pitch,           False)
        

    @property
    def polyOffset( self): return self.polyPitch // 2

    def m0x( self, x): return self.m0.value( x)
    def m1y( self, y): return self.m1.value( y)
    def polyy( self, y): return self.poly.value( y)
    def diffcony( self, y): return self.diffcon.value( y)

    def addSegment( self, grid, netName, c, bIdx, eIdx):
        segment = grid.segment( netName, c, bIdx, eIdx)
        self.terminals.append( segment)
        return segment
        
    def m0Segment( self, netName, x0, x1, y): return self.addSegment( self.m0, netName, y, x0, x1)
    def m1Segment( self, netName, x, y0, y1): return self.addSegment( self.m1, netName, x, y0, y1)
    def polySegment( self, netName, x, y0, y1): return self.addSegment( self.poly, netName, x, y0, y1)
    def diffconSegment( self, netName, x, y0, y1): return self.addSegment( self.diffcon, netName, x, y0, y1)

    def unit( self, x, y):
        uc.diffconSegment( 's',   2*x+0, 4*y+1, 4*y+3)
        uc.polySegment(    'g',   2*x+0, 4*y+1, 4*y+3)
        uc.polySegment(    'g',   2*x+1, 4*y+1, 4*y+3)
        uc.diffconSegment( 'd',   2*x+2, 4*y+1, 4*y+3)

        uc.m0Segment( 's', 8*x-3, 8*x+3,  4*y+1)
        uc.m0Segment( 's', 8*x-3, 8*x+3,  4*y+3)
        uc.m0Segment( 'g', 8*x+1, 8*x+7,  4*y+2)
        uc.m0Segment( 'd', 8*x+5, 8*x+11, 4*y+1)
        uc.m0Segment( 'd', 8*x+5, 8*x+11, 4*y+3)

        uc.m0Segment( 'gnd', 8*x-1, 8*x+9, 4*y+0)
        uc.m0Segment( 'gnd', 8*x-1, 8*x+9, 4*y+4)

        uc.m1Segment( 's', 2*x+0, 4*y+1, 4*y+3)
        uc.m1Segment( 'g', 2*x+1, 4*y+1, 4*y+3)
        uc.m1Segment( 'd', 2*x+2, 4*y+1, 4*y+3)

if __name__ == "__main__":
    uc = UnitCell()

    for (x,y) in ( (x,y) for x in range(16) for y in range(16)):
        uc.unit( x, y)

    with open( "mydesign_dr_globalrouting.json", "wt") as fp:
        write_global_routing_json( fp, uc.terminals)
