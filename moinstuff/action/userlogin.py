# -*- coding: iso-8859-1 -*-
"""
    MoinMoin - userlogin action

    This action a registered user to log in, or, if already
    logged in, to log out. 
    
    
    @copyright: 2002-2004 Michael Reinsch <mr@uue.org>
    @license: GNU GPL, see COPYING for details.
"""

import os
from MoinMoin import wikiutil
import string, time, re, Cookie
from MoinMoin.Page import Page
from MoinMoin.util import MoinMoinNoFooter, pysupport
from MoinMoin import config, user, util, wikiutil
from MoinMoin.util import web, mail, datetime
from MoinMoin.widget import html

#############################################################################
### Form POST Handling
#############################################################################
debug = 0

class UserLoginHandler:

    def __init__(self, request):
        """ Initialize user settings form. """
        self.request = request
        self._ = request.getText
        self.cfg = request.cfg

#    def decodePageList(self, key):
#        """ Decode list of pages from form input
#
#       Each line is a page name, empty lines ignored.
#
#        Items can use '_' as spaces, needed by [name_with_spaces label]
#        format used in quicklinks. We do not touch those names here, the
#        underscores are handled later by the theme code.
#
#        @param key: the form key to get
#        @rtype: list of unicode strings
#        @return: list of normalized names
#        """
#        text = self.request.form.get(key, [''])[0]
#        text = text.replace('\r', '')
#        items = []
#        for item in text.split('\n'):
#            item = item.strip()
#            if not item:
#                continue
#            # Normalize names - except [name_with_spaces label]
#            if not (item.startswith('[') and item.endswith(']')):
#                item = self.request.normalizePagename(item)
#            items.append(item)
#        return items

    def handleData(self):
        _ = self._
        form = self.request.form
    
        if form.has_key('logout'):
            # clear the cookie in the browser and locally. Does not
            # check if we have a valid user logged, just make sure we
            # don't have one after this call.
            self.request.deleteCookie()
            return _("Cookie deleted. You are now logged out.")
    
        elif form.has_key('login_sendmail'):
            if not self.cfg.mail_smarthost:
                return _("""This wiki is not enabled for mail processing.
Contact the owner of the wiki, who can enable email.""")
            try:
                email = form['email'][0].lower()
            except KeyError:
                return _("Please provide a valid email address!")
    
            text = _("""\
Somebody has requested to submit your account data to this email address.

If you lost your password, please use the data below and just enter the
password AS SHOWN into the wiki's password form field (use copy and paste
for that).

After successfully logging in, it is of course a good idea to set a new and known password.
""", formatted=False)
            users = user.getUserList(self.request)
            for uid in users:
                theuser = user.User(self.request, uid)
                if theuser.valid and theuser.email.lower() == email:
                    text += '\n' + _("""\
Login Name: %s

Login Password: %s

Login URL: %s/?action=userform&uid=%s
""", formatted=False) % (
                        theuser.name, theuser.enc_password, self.request.getBaseURL(), theuser.id)

            if not text:
                return _("Found no account matching the given email address '%(email)s'!") % {'email': wikiutil.escape(email)}

            subject = _('[%(sitename)s] Your wiki account data',
                formatted=False) % {'sitename': self.cfg.sitename or "Wiki"}
            mailok, msg = util.mail.sendmail(self.request, [email], subject,
                text, mail_from=self.cfg.mail_from)
            return wikiutil.escape(msg)

        elif form.has_key('login'):
            # Trying to login with a user name and a password

            # Require valid user name
            name = form.get('username', [''])[0]
            
            if not user.isValidName(self.request, name):
                return _("""Invalid user name {{{'%s'}}}.
Name may contain any Unicode alpha numeric character, with optional one
space between words. Group page name is not allowed.""") % wikiutil.escape(name)

            # Check that user exists
            if not user.getUserId(self.request, name):
                return _('Unknown user name: {{{"%s"}}}. Please enter'
                         ' user name and password.') % name

            # Require password
            password = form.get('password',[None])[0]
            if not password:
                return _("Missing password. Please enter user name and"
                         " password.")

            # Load the user data and check for validness
            theuser = user.User(self.request, name=name, password=password)
            if not theuser.valid:
                return _("Sorry, wrong password.")
            
            # Save the user and send a cookie
            self.request.user = theuser
            self.request.setCookie()
            return _("User logged in.")

        elif form.has_key('uid'):
            # Trying to login with the login URL, soon to be removed!
            try:
                 uid = form['uid'][0]
            except KeyError:
                 return _("Bad relogin URL.")

            # Load the user data and check for validness
            theuser = user.User(self.request, uid)
            if not theuser.valid:
                return _("Unknown user.")
            
            # Save the user and send a cookie
            self.request.user = theuser
            self.request.setCookie()
            return _("User logged in.")

        else:
            return _("Something went wrong.")


def execute(pagename, request):
    savemsg = UserLoginHandler(request).handleData()
    Page(request, pagename).send_page(request, msg=savemsg)

