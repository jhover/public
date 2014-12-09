# -*- coding: iso-8859-1 -*-
"""
    MoinMoin Macro
    UserRegister - Macro-ized from UserPreferences
    Depends on presence of userregister Action.
    
    @author John R. Hover <jhover@bnl.gov>

    The presence of this Macro/Action combination will allow
    the UserPreferences Page to be restricted (e.g. to an Admin group)
    UserLogin then becomes the standard way for registered users 
    to log in, and UserRegister becomes the page where Admins can 
    create new users.

"""
#import string, time, re, Cookie
from MoinMoin import wikimacro
import string, time, re, Cookie
from MoinMoin import config, user, util, wikiutil
from MoinMoin.util import web, mail, datetime
from MoinMoin.widget import html

#############################################################################
### Registration Form Generation
#############################################################################
class UserRegisterForm:
    """ Create a new login account """

    _date_formats = { # datetime_fmt & date_fmt
        'iso':  '%Y-%m-%d %H:%M:%S & %Y-%m-%d',
        'us':   '%m/%d/%Y %I:%M:%S %p & %m/%d/%Y',
        'euro': '%d.%m.%Y %H:%M:%S & %d.%m.%Y',
        'rfc':  '%a %b %d %H:%M:%S %Y & %a %b %d %Y',
    }

    def __init__(self, request):
        """ Initialize user settings form.
        """
        self.request = request
        self._ = request.getText
        self.cfg = request.cfg

    
    def make_form(self):
        """ Create the FORM, and the TABLE with the input fields
        """
        sn = self.request.getScriptname()
        pi = self.request.getPathinfo()
        action = u"%s%s" % (sn, pi)
        self._form = html.FORM(action=action)
        self._table = html.TABLE(border="0")

        # Use the user interface language and direction
        lang_attr = self.request.theme.ui_lang_attr()
        self._form.append(html.Raw('<div class="userpref"%s>' % lang_attr))

        self._form.append(html.INPUT(type="hidden", name="action", value="userregister"))
        self._form.append(self._table)
        self._form.append(html.Raw("</div>"))


    def make_row(self, label, cell, **kw):
        """ Create a row in the form table.
        """
        self._table.append(html.TR().extend([
            html.TD(**kw).extend([html.B().append(label), '   ']),
            html.TD().extend(cell),
        ]))


    def asHTML(self):
        """ Create the complete HTML form code. """
        _ = self._
        self.make_form()

        #register interface
        buttons = [
                # IMPORTANT: login should be first to be the default
                # button when a user click enter.
                ('login', _('Create New Account')),
        ]
                                             
        self.make_row(_('Name'), [
            html.INPUT(
                type="text", size="36", name="username", value="NewUser"
            ),
            ' ', _('(Use FirstnameLastname)', formatted=False),
        ])

        self.make_row(_('Password'), [
            html.INPUT(
                type="password", size="36", name="password",
            ),
            ' ', 
        ])

        self.make_row(_('Password repeat'), [
            html.INPUT(
                type="password", size="36", name="password2",
            ),
            ' ', _('(Only when changing passwords)'),
        ])

        self.make_row(_('Email'), [
            html.INPUT(
                type="text", size="36", name="email", value=""
            ),
            ' ',
        ])

        # Add buttons
        button_cell = []
        for name, label in buttons:
            button_cell.extend([
                html.INPUT(type="submit", name=name, value=label),
                ' ',
            ])
        self.make_row('', button_cell)
        
        return unicode(self._form)



def execute(macro, arguments):
    answer = UserRegisterForm(macro.request).asHTML()
    return answer