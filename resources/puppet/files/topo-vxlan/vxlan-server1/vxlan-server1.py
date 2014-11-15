#!/usr/bin/python


from mininet.topo import Topo

class VXLANTestTopo1( Topo ):

    """vxlan-server1"""

    def __init__( self ):
        """Create topo."""

        # Initialize topology
        Topo.__init__( self )

        # Add hosts and switches
        red1 = self.addHost('red1',
                          ip="10.0.0.1/8",
                          mac="00:00:00:00:00:01")
        blue1 = self.addHost('blue1',
                          ip="10.0.0.1/8",
                          mac="00:00:00:00:00:01")


        s1 = self.addSwitch('s1')

        # Add links
        self.addLink( s1, red1 )
        self.addLink( s1, blue1 )

topos = {'vxlan-server1': ( lambda: VXLANTestTopo1() )}

