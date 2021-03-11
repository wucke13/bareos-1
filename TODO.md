# Introduction

The access to the Bareos director from a certain console can be limited via ACLs.
These ACLs configure what commands can be executed when logging in via this console.


The ACLs for a certain console are configured in the director configuration.

The systemtests bareos-acl (systemtests/tests/bareos-acl) was prepared in this
branch to reproduce the problem that needs to be solved.

The following file configures a restricted console that is only allowed to execute
certain commands:

etc/bareos/bareos-dir.d/console/bareos-acl-restricted.conf

The interesting part is the following line:

-> CommandACL = restore, cancel, enable, disable, estimate, exit, gui, help, list, llist, messages, memory, quit, release    , reload, rerun, restore, run, show, status, time, version, wait, whoami

As you see, the "messages" command is allowed.

# Problem description

When logging into the bareos system using this console, the message "you have
messages" is issued.
To see the pending messages, the "messages" command needs to be executed. But
instead of showing the messages, "You have no messages" is printed.

The desired behaviour is that the messages command works like usual when the
messages command is allowed via the Command ACL.


# Reproducing the Problem:

* compile bareos
* got to the systemtests/tests/bareos-acl directory.
* run ./testrunner which will setup bareos and run one backup.
* connect to the director using the restricted console:
* bin/bconsole -c etc/bareos/bconsole-acl-restricted.conf
* press Enter to see "You have messages"
* enter "messages" which should show the messages but shows "You have no messages"


bin/bconsole -c etc/bareos/bconsole-acl-restricted.conf
Connecting to Director gonzo:42091
 Encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3
1000 OK: bareos-dir Version: 21.0.0~pre302.a84a55ff8.dirty (11 March 2021)
self-compiled binary
self-compiled binaries are UNSUPPORTED by bareos.com.
Get official binaries and vendor support on https://www.bareos.com
You are logged in as: bareos-acl-restricted

Enter a period (.) to cancel a command.
*
You have messages.
*messages
You have no messages.


To see the desired behaviour, you can use the unrestricted console via:

bin/bconsole
* press Enter to see "You have messages"
* enter "messages" which shows the messages that are queued.

Note: When the messages have been successfully retrieved, they are gone and you need
to rerun the "testrunner" to have messages again.









