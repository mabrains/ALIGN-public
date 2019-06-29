from .canvas import Canvas
from .generators import *
from .grid import *

class DefaultCanvas(Canvas):

    def __init__( self, pdk):
        super().__init__(pdk)
        assert self.pdk is not None, "Cannot initialize DefaultCanvas without a pdk"
        self._initialize_layer_stack()
        for layer, info in self.pdk.items():
            if layer.startswith('M'):
                self._create_metal(layer, info)
            elif layer.startswith('V'):
                self._create_via(layer, info)

    def _initialize_layer_stack(self):
        """layer_stack expects tuple of the form ( via, (metal_vertical, metal_horizontal))"""
        self.layer_stack = [(l, (pl, nl)) if self.pdk[nl]['Direction'] == 'h' else (l, (nl, pl)) \
            for l, (pl, nl) in self.pdk.get_via_stack() if l.startswith('V')]

    def _get_metal_pitch( self, layer):
        return min(self.pdk[layer]['Pitch']) if isinstance(self.pdk[layer]['Pitch'], list) else self.pdk[layer]['Pitch']

    def _get_via_ext( self, metal, via):
        viaenc = self.pdk[via][f'VencA_L'] if self.pdk[via]['Stack'][0] == metal else self.pdk[via][f'VencA_H']
        viawidth = self.pdk[via]['WidthX'] if self.pdk[metal]['Direction'] == 'h' else self.pdk[via]['WidthY']
        return viawidth // 2 + viaenc

    def _create_metal( self, layer, info):
        if isinstance(info['Width'], list):
            # TODO: Figure out what multiple metal widths even means. Just doing first width for now
            # for i in range(0, len(info['Width'])):
            for i in range(0, 1):
                self._create_metal(layer, \
                    {k: v[i] if k in ['Pitch', 'Width', 'MinL', 'MaxL'] else v for k, v in info.items()})
        else:
            base_layer = layer.split('_')[0]
            (pm, pv, nv, nm) = self._find_adjoining_layers(base_layer)
            if nm is None:
                spg_pitch, spg_stop = self._get_metal_pitch(pm), self._get_via_ext(base_layer, pv)
            elif pm is None:
                spg_pitch, spg_stop = self._get_metal_pitch(nm), self._get_via_ext(base_layer, nv)
            else:
                pm_pitch, nm_pitch = self._get_metal_pitch(pm), self._get_metal_pitch(nm)
                if pm_pitch <= nm_pitch:
                    spg_pitch, spg_stop = pm_pitch, self._get_via_ext(base_layer, pv)
                else:
                    spg_pitch, spg_stop = nm_pitch, self._get_via_ext(base_layer, nv)
            layer = layer.lower()
            if len(info['Color']) == 0:
                clg = UncoloredCenterLineGrid( pitch=info['Pitch'], width=info['Width'], offset=0)
            else:
                clg = ColoredCenterLineGrid( colors=info['Color'], pitch=info['Pitch'], width=info['Width'], offset=0)
            setattr(self, layer, self.addGen(
                Wire(layer, base_layer, info['Direction'], clg = clg,
                     spg = EnclosureGrid( pitch=spg_pitch, offset=0, stoppoint=spg_stop, check=True))
            ))

    def _create_via( self, layer, info):
        if self.pdk[info['Stack'][0]]['Direction'] == 'h':
            assert self.pdk[info['Stack'][1]]['Direction'] == 'v', f"{info['Stack']} both appear to be horizontal"
            h_clg = getattr(self, info['Stack'][0].lower()).clg
            v_clg = getattr(self, info['Stack'][1].lower()).clg
            h_ext = self._get_via_ext(info['Stack'][0], layer)
            v_ext = self._get_via_ext(info['Stack'][1], layer)
        else:
            assert self.pdk[info['Stack'][1]]['Direction'] == 'h', f"{info['Stack']} both appear to be vertical"
            v_clg = getattr(self, info['Stack'][0].lower()).clg
            h_clg = getattr(self, info['Stack'][1].lower()).clg
            v_ext = self._get_via_ext(info['Stack'][0], layer)
            h_ext = self._get_via_ext(info['Stack'][1], layer)
        setattr(self, layer.lower(), self.addGen(
            Via(layer.lower(), layer, h_clg = h_clg, v_clg = v_clg, h_ext=h_ext, v_ext=v_ext)
        ))

        def single_centered_via(rect):
            xpos = ( rect[0] + rect[2] ) // 2
            ypos = ( rect[1] + rect[3] ) // 2
            return [xpos - info['WidthX'] // 2, ypos - info['WidthY'] // 2, xpos + info['WidthX'] // 2, ypos + info['WidthY'] // 2]

        self.postprocessor.register(layer, single_centered_via)

    def _find_adjoining_layers( self, layer):
        pm = pv = nv = nm = None
        for (v, (m0, m1)) in self.layer_stack:
            if layer == m0:
                nv = v
                nm = m1
            elif layer == m1:
                pv = v
                pm = m0
        assert nm is not None or pm is not None, f"Could not trace any connections for {layer}"
        return (pm, pv, nv, nm)
