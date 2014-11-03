#!/usr/bin/python


from mininet.topo import Topo

class VXLANTestTopo( Topo ):

    """VXLAN test topology."""

    def __init__( self ):
        """Create custom topo."""

        # Initialize topology
        Topo.__init__( self )

        # Add hosts and switches
        red1 = self.addHost('red1',
                          ip="10.0.0.1/24",
                          mac="00:00:00:00:00:01")
        blue1 = self.addHost('blue1',
                          ip="10.0.0.1/24",
                          mac="00:00:00:00:00:01")


        red2 = self.addHost('red2',
                          ip="10.0.0.2/24",
                          mac="00:00:00:00:00:02")
        blue2 = self.addHost('blue2',
                          ip="10.0.0.2/24",
                          mac="00:00:00:00:00:01")

        R1 = self.addHost('R1',
                          ip="10.0.0.1/24",
                          mac="00:00:00:00:00:01")


        s1 = self.addSwitch('s1')
        s2 = self.addSwitch('s1')

        # Add links
        self.addLink( s1, red1 )
        self.addLink( s1, blue1 )
        self.addLink( s2, red2 )
        self.addLink( s2, blue2 )

        self.addLink( s1, R1 )
        self.addLink( s2, R1 )

topos = {'vxlan': ( lambda: VXLANTestTopo() )}

