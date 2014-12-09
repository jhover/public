#
# A set of classes to represent components of a game of Monopoly,
# in order to allow simulations.
#
#
#
import random
import logging
from ConfigParser import ConfigParser, NoOptionError
from UserList import UserList

log = logging.getLogger()


class CircularList(UserList):
    ''' Good for representing lists of things that must be cycled through, e.g. players, 
    squares on the board.
    
    
    '''
    def __init__(self):
        UserList.__init__(self)        
        self.currentindex = 0
    
    #def append(self,object):
    #    self.list.append(object)
        
           
    def next(self):
        self.currentindex += 1
        if self.currentindex >= self.__len__():
            self.currentindex = self.currentindex - self.__len__()
        return UserList.__getitem__(self, self.currentindex)
    
    def advance(self, number=1):
        for i in range(0,number):
            ret = self.next()
        return ret

    def setCurrentIndex(self, index):
        self.currentindex = index


class Player(object):
    
    def __init__(self, game, config, playerconfig, section ):
        self.game = game   # The game this player is participating in.
        self.name = section
        self.prettyname = playerconfig.get(section, 'prettyname')
        self.dollars = int( config.get('global','player_funds'))
        self.strategy = DefaultStrategy(self)
        self.properties = []  # Player starts out with no property
        self.boardindex = 0   # Player starts on Go
        self.bankrupt = False
        self.inJail = False
        self.jailTurns = 0
    
    def pay(self, otherplayer, amount):
        '''
         Handles the owing of money from one party to another. 
         Triggers mortaging if needed, and all bankruptcy.
        '''
        log.debug("Player.pay(): BEFORE [%s] has $%d. [%s] has $%d." % (self.name, 
                                                                             self.dollars,
                                                                             otherplayer.name,
                                                                             otherplayer.dollars
                                                                             ))
        log.info("%s, with $%d, owes %s $%d. Transferring... " % ( self.prettyname,
                                                             self.dollars, 
                                                             otherplayer.prettyname, 
                                                             amount                                                               
                                                            ))
        if self.dollars > amount:
            self.dollars = self.dollars - amount
            otherplayer.dollars += amount
            log.debug("Player.pay(): AFTER [%s] has $%d. [%s] has $%d." % (self.name, 
                                                                             self.dollars,
                                                                             otherplayer.name,
                                                                             otherplayer.dollars
                                                                             ))
        else:
            otherplayer.dollars += self.dollars
            self.dollars = 0
            self.bankrupt = True
            log.info("%s has gone BANKRUPT trying to pay %s" % (self.prettyname, otherplayer.prettyname))
            self.goBankruptOne(otherplayer)

    def goBankruptOne(self, otherplayer):
        '''
            First version of going bankrupt.
        '''
        #
        # Give all your property to debtor
        #
        log.info("Player %s giving all %d of his properties to debtor %s." % (self.prettyname, 
                                                                              len(self.properties),
                                                                              otherplayer.prettyname))
        # Copy list, since transfer will alter the list during loop
        totransfer = self.properties[:]
        for p in totransfer:
            log.debug("Requesting transfer of property [%s] to [%s]..." % (p.name, 
                                                                               otherplayer.name
                                                                               ))
            p.transfer(otherplayer, 0)
            


    def ownsAllOfGroup(self, groupname):
        '''
            Determines if this player owns all of a given group. 
        '''
        group = []
        for p in self.game.properties:
            if p.group == groupname:
                group.append(p)
        #grpstr = ""
        #for g in group:
        #    grpstr += str(g)
        #log.debug("Player.ownsAllOfGroup(): Found all %s : %s" % (groupname, grpstr))
        
        for g in group:
            if g.owner != self:
                log.debug("Player.ownsAllOfGroup(): [%s] Does not own %s group." % (self.name, groupname) )
                return False    
        log.debug("Player.ownsAllOfGroup(): [%s] Does own all of %s group." % (self.name, groupname) )
        return True
    
    
    def ownsNumberOfGroup(self, groupname):
        '''
            Counts number of a group this player owns. 
        '''
        num = 0
        for p in self.properties:
            if p.group == groupname:
                num += 1
        return num
    
      
    def calcAssets(self):
        amt = self.dollars
        for p in self.properties:
            if not p.mortaged:
                amt += p.cost
        log.debug("Player.calcAssets(): [%s] has $%d in assets."  % (self.name, amt))
        return amt




    
    def __str__(self):
        s = "" 
        s += "Player: [%s] " % self.name
        s += "BoardLocation: [%d]:[%s] " % (self.boardindex, self.game.board.squares[self.boardindex].name)
        s += "Dollars=%d " % self.dollars
        s += "Bankrupt=%s " % self.bankrupt
        if len(self.properties) > 0:
            s += "Owns="
            for p in self.properties:
                s += " [%s]" % p.name
                if p.houses > 0:
                    s += ":%d houses" % p.houses
        else:
            s += "Owns=No properties."
        return s


    
class Property(object):
    
    def __init__(self,game, config, propconfig, section ):
        log.debug("Property.__init__(): Creating [%s] Property" % section)
        self.game = game
        self.name = section
        self.boardindex = int( propconfig.get(section, 'boardindex') )
        self.name = section
        self.group = propconfig.get(section, 'group')
        try:
            self.baserent = int(propconfig.get(section, 'rent'))
        except ValueError:
        #
        # XXX Temporary value...
        #
            self.baserent = 50
        
        try:   
            self.onehouse=int(propconfig.get(section, '1house'))
            self.twohouse=int(propconfig.get(section, '2house'))
            self.threehouse = int(propconfig.get(section, '3house'))
            self.fourhouse = int(propconfig.get(section, '4house'))
            self.whotel = int(propconfig.get(section, 'whotel'))                     
            self.housecost = int(propconfig.get(section, 'housecost'))
            self.hotelcost = int(propconfig.get(section, 'hotelcost'))            

        except :
            pass
        
        #
        # Handle Railroads
        #
        if self.group == "railroad":
            self.w2=int(propconfig.get(section, 'w2'))
            self.w3=int(propconfig.get(section, 'w3'))
            self.w4=int(propconfig.get(section, 'w4'))
        
        if self.group == "utility":
            self.rentw1mult=int(propconfig.get(section, 'rentw1mult')) 
            self.rentw2mult=int(propconfig.get(section, 'rentw2mult')) 
        
        self.prettyname = propconfig.get(section, 'prettyname')
        self.cost = int(propconfig.get(section, 'cost'))
        self.houses = 0
        self.hotels = 0
        self.owner = None
        self.mortage = self.cost * float(config.get('global','mortage_fraction'))
        self.mortaged = False
        
        
    def rent(self):
        '''
            Returns rent owed based on current mortage, group ownership house, and hotel state.
        '''
        if self.mortaged:
            log.debug("Property.rent(): [%s] is mortaged. No rent. "% self.name)
            return 0
        if self.group == "railroad":
            num = self.owner.ownsNumberOfGroup("railroad")
            if num == 1:
                log.debug("Property.rent(): Player owns one RR. %d "% self.baserent)
                return self.baserent
            elif num == 2:
                log.debug("Property.rent(): Player owns two RR. %d "% self.w2)
                return self.w2
            elif num == 3:
                log.debug("Property.rent(): Player owns three RR. %d "% self.w3)
                return self.w3
            elif num == 4:
                log.debug("Property.rent(): Player owns four RR. %d "% self.w4)
                return self.w4
            
        elif self.group == "utility":
            num = self.owner.ownsNumberOfGroup("utility")
            if num == 1:
                amtowed = self.game.dice.total * self.rentw1mult
                log.debug("Property.rent(): Player owns one Utility. $%d "% amtowed)
                return int(amtowed)
            if num == 2:
                amtowed = self.game.dice.total * self.rentw2mult
                log.debug("Property.rent(): Player owns one Utility. $%d "% amtowed)
                return int(amtowed)
                
            
        else:
            if self.houses + self.hotels < 1:
                if self.owner.ownsAllOfGroup(self.group):
                    return self.baserent * 2
                else:
                    # return double rent if player owns whole color group
                    return self.baserent
            else:
                if self.houses == 1:
                    return self.onehouse
                if self.houses == 2:
                    return self.twohouse
                if self.houses == 3:
                    return self.threehouse
                if self.houses == 4:
                    return self.fourhouse
        


    def transfer(self, newowner, dollars):
        ''' 
            Transfers (gives or sells) this property from its current owner 
            to a new owner for X dollars. Note, does not remove property from old owner. 
            Assumes this has been done by caller. 
        '''
        oldowner = self.owner
        newowner.properties.append(self)
        oldowner.properties.remove(self)
        self.owner = newowner
        log.debug("Property.transfer(): Before: [%s]:$%d   [%s]:$%d" % (oldowner.name, 
                                                                        oldowner.dollars, 
                                                                        newowner.name, 
                                                                        newowner.dollars))
        if dollars > 0:
            oldowner.dollars = oldowner.dollars + dollars
            newowner.dollars = newowner.dollars - dollars
        log.info("Property %s transferred from %s to %s. for $%d." % (self.prettyname, 
                                                             oldowner.prettyname, 
                                                             newowner.prettyname,
                                                             dollars
                                                              ))
        log.debug("Property.transfer(): After: [%s]:$%d   [%s]:$%d" % (oldowner.name, 
                                                                        oldowner.dollars, 
                                                                        newowner.name, 
                                                                        newowner.dollars))

    def process(self, game):
        '''
            Changes the game state to the product of landing on this Property.
        '''
        log.debug("Property.process() called on [%s]" % self.name)
        # is it owned?
        if self.owner.name != "bank":
            if self.owner.name == game.currentplayer.name:
                log.info("%s landed on his own Property ( %s ) . Nothing owed." % (game.currentplayer.prettyname, 
                                                                                   self.prettyname) )
            else:
                # if so, calculate rent
                log.info("%s landed on Property ( %s: %d houses, %d hotels ) owned by %s. Calculating rent..." % (game.currentplayer.prettyname,
                                                                                                                  self.prettyname,
                                                                                                                  self.houses,
                                                                                                                  self.hotels, 
                                                                                                                  self.owner.prettyname) )
                game.currentplayer.pay(self.owner, self.rent())
            
        else:
            # Does lander want it?
            if game.currentplayer.strategy.wantsToBuy(self, self.cost):
                self.transfer(game.currentplayer, self.cost )
                
            # if not, auction

        
    def __str__(self):
        s = ""
        s += "Property: [%s] " % self.name
        return s

    def __cmp__(self, other):
        return cmp(self.boardindex, other.boardindex)


class Square(object):
    '''
        Represents a non-property square. E.g. 
        Go, 
        Jail,
        GoToJail,
        Luxury Tax
        Income Tax 
        Free Parking.
    '''
    
    def __init__(self,game, config, squareconfig, section):
        log.debug("Square.__init__(): Creating [%s] Square" % section)
        self.game = game
        self.name = section
        self.prettyname = squareconfig.get(section, 'prettyname')
        self.type = squareconfig.get(section, 'type')
        self.boardindex = int( squareconfig.get(section, 'boardindex') )
        try:
            self.amount = int(squareconfig.get(section, 'amount'))
        except:
            pass
    
    def process(self, game):
        '''
            Changes the game state to the product of executing this square.
        '''
        log.debug("Square.process()")
        if self.name == "luxurytax":
            game.currentplayer.pay(game.bank, self.amount)
        
        if self.name == "incometax":
            amt = game.currentplayer.calcAssets()
            percentage =  amt * 0.10  
            if percentage < 200.0:
                game.currentplayer.pay(game.bank, int(percentage))
                log.info("%s pays $%d in Income Tax." %(game.currentplayer.prettyname, int(percentage)))
            else:
                log.info("%s pays $200 in Income Tax." % game.currentplayer.prettyname)
                game.currentplayer.pay(game.bank, 200)
        
        if self.name == "go":
            game.bank.pay(game.currentplayer, self.amount)    

        if self.name == "gotojail":
            game.currentplayer.boardindex = 10
            game.currentsquare = game.board.squares[10]
            game.currentplayer.inJail = True
            game.currentplayer.jailTurns = 0
            log.info("Player %s now on Jail" % game.currentplayer.prettyname)

        if self.type == "commchest":
            card = game.commchest.next()
            log.info("Community Chest: %s" % card)
            card.process(game, game.currentplayer)
        if self.type == "chance":
            card = game.chance.next()
            log.info("Chance: %s" % card)
            card.process(game, game.currentplayer)

    def __cmp__(self, other):
        return cmp(self.boardindex, other.boardindex)

    def __str__(self):
        s = ""
        s += "Square: [%s] " % self.name
        return s

class Board(object):
    ''' 
    Represents the standard board layout. 
    '''

    def __init__(self, game, config):
        self.game = game
        self.config = config
        self.squares = CircularList()
        items = []
        self.properties = []
        
        self.propconfig=ConfigParser()
        propconfigfile = "%s/properties.conf" %  self.config.get('global','configdir').strip()
        log.debug("Game: Parsing Properties config file: %s" % propconfigfile)
        self.propconfig.read( propconfigfile  )
        for section in self.propconfig.sections():
            prop = Property(game, self.config, self.propconfig, section)
            items.append(prop)
            self.properties.append(prop)

        self.sqconfig=ConfigParser()
        sqconfigfile = "%s/squares.conf" %  self.config.get('global','configdir').strip()
        log.debug("Game: Parsing Squares config file: %s" % sqconfigfile)
        self.sqconfig.read( sqconfigfile  )
        for section in self.sqconfig.sections():
            sq = Square(game, self.config, self.sqconfig, section)
            items.append(sq)        
        
        items.sort()
        for i in items:
            self.squares.append(i)
        
           
    def __str__(self):
        s = "Board Contents:\n"
        for sq in self.squares:
            s += "%s\n" % sq
        return s
        


class Game(object):
    '''
        Represents the state of a game. Typically called as: 

            g = Game(config)
            g.play()
    
    '''
    def __init__(self,config):
        log.info("Beginning Game...")
        self.config = config
        self.maxturns = int(config.get('global','maxturns'))
        self.dice = Dice()
        self.board = Board(self, config)
        self.properties = self.board.properties
        
        #
        # Initialize Players
        #
        self.players = CircularList()
        self.playerconfig=ConfigParser()
        pconfigfile = "%s/player.conf" %  self.config.get('global','configdir').strip()
        log.debug("Game.__init__(): Parsing Player config file: %s" % pconfigfile)
        self.playerconfig.read( pconfigfile  )
        for section in self.playerconfig.sections():
            p = Player(self, self.config, self.playerconfig, section)
            log.debug("Game.__init__(): Adding player %s to self.players" % p.name)
            self.players.append(p)
        
        #
        # Initialize cards...
        #
        self.commchest = CircularList()
        chestconfigfile = "%s/commchest.conf" % self.config.get('global','configdir').strip()
        log.debug("Game.__init__(): Parsing Commchest config file: %s" % chestconfigfile)
        self.chestconfig = ConfigParser()
        self.chestconfig.read( chestconfigfile  )
        for section in self.chestconfig.sections():
            c = Card(self.config, self.chestconfig, section)
            log.debug("Game.__init__(): Adding Card %s to self.commchest" % c.name)
            self.commchest.append(c)
        
        
        self.chance = CircularList()
        chanceconfigfile = "%s/chance.conf" % self.config.get('global','configdir').strip()
        log.debug("Game.__init__(): Parsing Chance config file: %s" % chanceconfigfile)
        self.chanceconfig = ConfigParser()
        self.chanceconfig.read( chanceconfigfile  )
        for section in self.chanceconfig.sections():
            c = Card(self.config, self.chanceconfig, section)
            log.debug("Game.__init__(): Adding Card %s to self.chance" % c.name)
            self.chance.append(c)        
               
        #
        # Initialize Bank
        # Bank starts owning all properties.
        #        
        self.bank = Bank(config)
        for p in self.properties:
            p.owner = self.bank
            self.bank.properties.append(p)
        
        #
        # Establish the rest of game state
        #
        self.currentdie=2    # value of the current die roll
        self.currentplayer = None
        self.turns = 0   # How many turns have been played in this game so far.
        
        log.debug("Game.__init__(): Game object initialized.")

    def printConfig(self, config):
        s = ""
        for sec in config.sections():
            s += "[%s]\n" % sec
            for (key, val) in config.items(sec):
                s += "%s=%s\n" % (key, val)
        return s

    def play(self):
        log.debug("Game.play(): called.")
        #while self.playersNotBankrupt() > 2:
        #    self.takeTurn()
        while self.turns < self.maxturns and self.playersNotBankrupt() > 1:
            self.takeTurn()
        log.info("Game Over. %d Turns taken." % self.turns)
        if self.playersNotBankrupt() == 1:
            winner = None
            for p in self.players:
                if not p.bankrupt:
                    winner = p
            log.info("Game Winner is: %s using strategy %s " % ( p.prettyname, p.strategy.name))
        else:
            log.info("Game halted due to turn count.")
        
        #for p in self.players:
        #    log.info("%s" % p)
        log.debug("%s" % self)
        
        
    def playersNotBankrupt(self):
        playersOK = 0
        for p in self.players:
            if not p.bankrupt:
                playersOK += 1
        log.debug("Game.playersNotBankrupt(): %d players not bankrupt." % playersOK)
        return playersOK

    def takeTurn(self):
        self.turns += 1
        log.info("Beginning turn %d..." % self.turns)
        self.currentplayer = self.players.next()
        log.debug("Game.takeTurn(): Currentplayer is now [%s]." % self.currentplayer.name)
        if not self.currentplayer.bankrupt:
            log.debug("Game.takeTurn(): Currentplayer [%s] Boardindex=%d." % (self.currentplayer.name, 
                                                                              self.currentplayer.boardindex))
            self.currentsquare = self.board.squares[self.currentplayer.boardindex]
            log.debug("Game.takeTurn(): Currentsquare [%s]." % self.currentsquare.name)
            self.board.squares.currentindex = self.currentplayer.boardindex
            log.debug("Game.takeTurn(): Board.squares.currentindex = %d." % self.board.squares.currentindex) 
            log.info("It is %s's turn. Starting on %s." % (self.currentplayer.prettyname, 
                                                           self.currentsquare.prettyname))
            self.dice.roll()
            log.info("Player %s rolling die... Rolled a %d." % (self.currentplayer.prettyname, self.dice.total))
            # Handle all squares except the final landing one...
            for i in range(self.dice.total - 1):
                self.currentsquare = self.board.squares.next()
                self.passSquare(self.currentplayer,self.currentsquare )
                self.currentplayer.boardindex = self.currentsquare.boardindex 
            # Now handle last square landed on...
            self.currentsquare = self.board.squares.next()
            self.landOnSquare(self.currentplayer,self.currentsquare )
            self.currentplayer.boardindex = self.currentsquare.boardindex        
            
            log.info("Player %s checking on house/hotel buying question..." % self.currentplayer.prettyname)
            for p in self.currentplayer.properties:
                if self.currentplayer.ownsAllOfGroup(p.group) and self.currentplayer.strategy.wantsToAddHouse(p) and p.houses < int(self.config.get('global','maxhouses')):
                    log.info("Player %s putting extra house on %s" % (self.currentplayer.prettyname,p.prettyname))
                    self.currentplayer.pay(self.bank, p.housecost)
                    self.bank.houses -= 1
                    p.houses += 1       
            
            log.info("Player %s's turn over." % self.currentplayer.prettyname)
        else:
            log.info("Player %s bankrupt. No turn." % self.currentplayer.prettyname)
        
        
    def passSquare(self,player,square):
        log.debug("Game.passSquare(): Handling player %s passing square %s" % (player.name , square.name))
        if square.name == "go":
            # Don't pay money for first round of game, even though they are on Go
            #if not self.turns <= len(self.players):
            gopayout = int(self.config.get('global','gopayout'))
            self.bank.dollars = self.bank.dollars - gopayout
            player.dollars += gopayout
            log.info("Player [%s] passed Go, got $%d." %( player.prettyname, gopayout))
        
    def landOnSquare(self, player,square):
        log.info("Player %s landed on %s." % (player.prettyname, square.prettyname))    
        if isinstance(square, Square):
            log.debug("landOnSquare(): Landed on a non-property square.")
            square.process(self)
            log.debug("Game.landOnSquare(): Player [%s] now on [%s]."%(player.name, self.board.squares[player.boardindex].name )) 
        
        elif isinstance(square, Property):
            log.debug("landOnSquare(): Landed on a Property square.")
            square.process(self)

       
    def __str__(self):
        '''
        Provides a human-readable representation of the state of this Game
        '''
        s = ""
        s += "Game: %d players\n" % len(self.players)
        s += self.printConfig(self.config)
        s += self.printConfig(self.playerconfig)
        s += "%s" % self.board
        for p in self.players:
            s += "%s\n" % p
        s += "%s" % self.board
        s += "%s" % self.bank
        return s
        

class Dice(object):
    ''' Simple representation of Dice. Needed because Utilities calc rent based 
        on roll. And escaping Jail involves whether doubles were rolled.
    
    '''
    def __init__(self):
        self.first = 1
        self.second = 1
        self.total = 2
      
    def roll(self):
        self.first = random.randint(1,6)
        self.second = random.randint(1,6)
        self.total = self.first + self.second 
        log.debug("Dice.roll(): Rolled a %d" % self.total)
        return self.total

    def isDoubles(self):
        if self.first == self.second:
            return True
        else:
            return False



class Bank(object):
    '''
        Represents the bank
    '''
    def __init__(self,config):
        self.name = "bank"
        self.prettyname = "Bank"
        self.dollars = int( config.get('global','bank_funds'))
        self.properties = []
        self.houses = int(config.get('global','numhouses'))
        self.hotels = int(config.get('global','numhotels'))
    
    def pay(self, otherplayer, amount):
        '''
         Handles the owing of money frombank to another. 
        '''
        log.info("%s owes %s $%d. Transferring..." % ( self.prettyname, otherplayer.prettyname, amount))
        self.dollars = self.dollars - amount
        otherplayer.dollars += amount
     
    
        
    def __str__(self):
        s = ""
        s += "Bank: Funds=%d Unpurchased properties=%d Houses=%d Hotels=%d" % (self.dollars, 
                                                                               len(self.properties), 
                                                                               self.houses, 
                                                                               self.hotels)  
        return s


class Card(object):
    
    def __init__(self, config, cardconfig, section):
        self.name = section
        self.type = cardconfig.get( section, 'type')  # Chance|Community Chest
        self.text = cardconfig.get( section, 'text')
        self.action = cardconfig.get( section, 'action')  # goto|advance|payall|paybank|recieve|getpaid|special
        if self.action in [ "paybank", "payall","recieve","getpayed"]:
            self.amount =  int(cardconfig.get( section, 'amount'))
        log.debug("Card.__init__(): Card being created [%s] " % section)
    
    def process(self,game, player):
        pass
        if self.action == "paybank":
            player.pay(game.bank, self.amount)
        elif self.action == "payall":
            for p in game.players:
                if not p.bankrupt and p != player:
                    player.pay(p, self.amount)
        elif self.action == "recieve":
            game.bank.pay(player, self.amount)
        elif self.action == "getpayed":
            pass
    
        
    def __str__(self):
        s = ""
        s += "Card: Type=%s Text= %s" % ( self.type, self.text)
        return s



class Strategy(object):
    
    def __init__(self):
        pass
    
    def wantsToBuy(self, property, amount):
        pass        


class DefaultStrategy(Strategy):
    '''
    Represents the decisionmaking logic of a default, standard player.
    
    
    '''
    def __init__(self, player):
        Strategy.__init__(self)
        self.name = 'Default'
        self.player = player
        self.purchaseReserve = 400  # Don't buy stuff when short on cash
        
    def wantsToBuy(self, property, amount):
        log.debug("DefaultStrategy.wantsToBuy(): Player [%s] with $%d considering buying [%s] for $%d." % ( self.player.name, 
                                                                                                            self.player.dollars,
                                                                                                            property.name, 
                                                                                                            amount) )
        if self.player.dollars > self.purchaseReserve and self.player.dollars > amount  :
            log.debug("DefaultStrategy.wantsToBuy(): Sure! Let's do it.")
            return True
        else:
            log.debug("DefaultStrategy.wantsToBuy(): Insufficient funds!")
            return False

    def wantsToAddHouse(self, property):
        if property.group != "railroad" and property.group != "utility":
            if self.player.ownsAllOfGroup(property.group) and self.player.dollars > self.purchaseReserve and self.player.dollars > property.housecost:
                return True
            else:
                return False
        return False

    
        
        
            