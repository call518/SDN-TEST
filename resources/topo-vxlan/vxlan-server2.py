#!/usr/bin/python


from mininet.topo import Topo

class VXLANTestTopo2( Topo ):

    """vxlan-server2"""

    def __init__( self ):
        """Create topo."""

        # Initialize topology
        Topo.__init__( self )

        # Add hosts and switches
        red2 = self.addHost('red2',
                          ip="10.0.0.2/8",
                          mac="00:00:00:00:00:02")
        blue2 = self.addHost('blue2',
                          ip="10.0.0.2/8",
                          mac="00:00:00:00:00:02")


        s2 = self.addSwitch('s2')

        # Add links
        self.addLink( s2, red2 )
        self.addLink( s2, blue2 )

topos = {'vxlan-server2': ( lambda: VXLANTestTopo2() )}

