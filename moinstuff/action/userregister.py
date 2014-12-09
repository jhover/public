# -*- coding: iso-8859-1 -*-
"""
    MoinMoin - RenamePage action

    This action allows you to rename a page.

    Based on the DeletePage action by J�rgen Hermann <jh@web.de>

    @copyright: 2002-2004 Michael Reinsch <mr@uue.org>
    @license: GNU GPL, see COPYING for details.
"""

import os
from MoinMoin import wikiutil
import string, time, re, Cookie
from MoinMoin import config, user, util, wikiutil
from MoinMoin.util import web, mail, datetime
from MoinMoin.widget import html
from MoinMoin.Page import Page
from MoinMoin.util import MoinMoinNoFooter, pysupport


#############################################################################
### Form POST Handling
#############################################################################
debug = 0

class UserRegisterHandler:

    def __init__(self, request):
        """ Initialize user settings form. """
        self.request = request
        self._ = request.getText
        self.cfg = request.cfg

    def decodePageList(self, key):
        """ Decode list of pages from form input

        Each line is a page name, empty lines ignored.

        Items can use '_' as spaces, needed by [name_with_spaces label]
        format used in quicklinks. We do not touch those names here, the
        underscores are handled later by the theme code.

        @param key: the form key to get
        @rtype: list of unicode strings
        @return: list of normalized names
        """
        text = self.request.form.get(key, [''])[0]
        text = text.replace('\r', '')
        items = []
        for item in text.split('\n'):
            item = item.strip()
            if not item:
                continue
            # Normalize names - except [name_with_spaces label]
            if not (item.startswith('[') and item.endswith(']')):
                item = self.request.normalizePagename(item)
            items.append(item)
        return items

    def handleData(self):
        _ = self._
        form = self.request.form
    
        # Save user profile
        requestuser = user.User(self.request)
        
        # Creat new, "empty" user. 
        newuser = user.User(self.request)
        newuser.name = None
        from random import randint
        newuser.id = "%s.%d" % (str(time.time()), randint(0,65535))
        newuser.email = None
                      
        # Require non-empty name
        try:
            newuser.name = form['username'][0]
        except KeyError:
            return _("Empty user name. Please enter a user name.")

        # Don't allow users with invalid names
        if not user.isValidName(self.request, newuser.name):
            return _("""Invalid user name {{{'%s'}}}.
Name may contain any Unicode alpha numeric character, with optional one
space between words. Group page name is not allowed.""") % wikiutil.escape(newuser.name)
        
        # Name required to be unique. Check if name belong to another user.
        if user.getUserId(self.request, newuser.name):
            return _("This user name already belongs to somebody else.")

        # try to get the password and pw repeat
        password = form.get('password', [''])[0]
        password2 = form.get('password2',[''])[0]

        # Check if password is given and matches with password repeat
        if password != password2:
            return _("Passwords don't match!")
        if not password:
            return _("Please specify a password!")
        # Encode password
        if password and not password.startswith('{SHA}'):
            try:
                newuser.enc_password = user.encodePassword(password)
            except UnicodeError, err:
                # Should never happen
                return "Can't encode password: %s" % str(err)

        # try to get the (optional) email
        email = form.get('email', [''])[0]
        newuser.email = email.strip()

        # Require email if acl is enabled
        if not newuser.email and self.cfg.acl_enabled:
            return _("Please provide your email address. If you loose your"
                         " login information, you can get it by email.")

        # Email required to be unique
        # See also MoinMoin/scripts/moin_usercheck.py
        if newuser.email:
            users = user.getUserList(self.request)
            for uid in users:
                if uid == newuser.id:
                    continue
                thisuser = user.User(self.request, uid)
                if thisuser.email == newuser.email:
                   return _("This email already belongs to somebody else.")
                    
        # save data but don't send cookie
        newuser.save()            

        result = _("User %s created!" % newuser.name)
        if debug:
            result = result + util.dumpFormData(form)
        return result


def execute(pagename, request):
    savemsg = UserRegisterHandler(request).handleData()
    Page(request, pagename).send_page(request, msg=savemsg)
