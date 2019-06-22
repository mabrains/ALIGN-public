import json

class Pdk():
    def __init__(self):
        self.pdk = {}

    def load(self, filename):
        with open(filename, "rt") as fp:
            j = json.load(fp)
        assert 'Abstraction' in j
        for layer in j['Abstraction']:
            assert layer['Layer'] not in self.pdk, f"Cannot have multiple {layer['Layer']} layers with same name"
            assert layer['Layer'][0].isupper(), f"Layer name {layer['Layer']} must start with capitalized letter"
            if layer['Layer'].startswith('M'):
                self.addMetal(**layer)
            elif layer['Layer'].startswith('V'):
                self.addVia(**layer)
            else:
                self.add(**layer)
        return self.pdk

    @staticmethod
    def _check(parameters, **kwargs):
        assert all( x in kwargs for x in parameters), f"Entry {kwargs} missing one or more of {parameters}"
        assert all( x in parameters for x in kwargs.keys()), f"Entry {kwargs} has one or more spurious entries (Needs only {parameters})"

    def _add(self, parameters, **kwargs):
        # Guarantee one is to one mapping between parameters & kwargs
        layername = kwargs.pop('Layer')
        self.pdk[layername] = {key: None if value == 'NA' else value for key, value in kwargs.items()}

    def addMetal(self, **kwargs):
        params = ['Layer',
                  'LayerNo',
                  'Direction',
                  'Color',
                  'Pitch',
                  'Width',
                  'MinL',
                  'MaxL',
                  'End-to-End']
        self._check(params, **kwargs)
        # Attributes that need additional processing
        # 1. Pitch, Width, MinL, MaxL, End-to-End of type list
        list_params = params[4:]
        ll = set()
        for param in list_params:
            if isinstance(kwargs[param], list):
                if len(kwargs[param]) == 1:
                    kwargs[param] = kwargs[param][0]
                else:
                    ll.add(len(kwargs[param]))
        assert len(ll) <= 1, f"All lists in {kwargs} must of be same length"
        if len(ll) == 1:
            ll = ll.pop()
            for param in list_params:
                if not isinstance(kwargs[param], list):
                    kwargs[param] = [kwargs[param]] * ll
        # 2. Cast direction must be lowercase & ensure it is either v or h
        kwargs['Direction'] = kwargs['Direction'].lower()
        assert kwargs['Direction'] in ('v', 'h'), f"Invalid Direction {kwargs['Direction']} in {kwargs}"
        self._add(params, **kwargs)

    def addVia(self, **kwargs):
        params = ['Layer',
                  'LayerNo',
                  'Stack',
                  'SpaceX',
                  'SpaceY',
                  'WidthX',
                  'WidthY',
                  'VencA_L',
                  'VencA_H',
                  'VencP_L',
                  'VencP_H',
                  'DesignRules']
        self._check(params, **kwargs)
        # Attributes that need additional processing
        # 0. Dimensions
        assert all(isinstance(kwargs[x], int) for x in params[3:7]), f"One or more of {params[3:7]} not an integer in {kwargs}"
        assert all(kwargs[x] % 2 == 0 for x in params[3:7]), f"One or more of {params[3:7]} not even in {kwargs}"
        # 1. Metal Stack
        if isinstance(kwargs['Stack'], str):
            kwargs['Stack'] = kwargs['Stack'].split('-')
        assert len(kwargs['Stack']) == 2, f"{kwargs['Stack']} does not specify two metal layers"
        assert all(x in self.pdk for x in kwargs['Stack']), f"One or more of metals {kwargs['Stack']} not yet defined."
        # 2. DesignRules
        if isinstance(kwargs['DesignRules'], list):
            for rule in kwargs['DesignRules']:
                self._check(['Name', 'Present', 'Absent'], **rule)
        self._add(params, **kwargs)

    def add(self, **kwargs):
        assert 'Layer' in kwargs, '"Layer" is required parameter for all layers in PDK abstraction'
        self._add(None, **kwargs)