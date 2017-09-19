# satellite-utils
Collection of playbooks and scripts that I use to make installing, managing, and demoing Satellite easier

## Overview

These are a collection of scripts and playbooks that I use that make life easier. Some might be more useful
thank others. Let me know how to make it better!

## Playbooks

This is the collection of playbooks that I use to accomplish various things. These should be pretty simple,
with only a small learning curve.

### `clean_up_templates.yml`

This is a playbook for cleaning up the shipped templates that come with Satellite 6.2 and 6.3. It has a list
inside the playbook of the "good templates," and it will compare all the templates that belong in the
`default organization` and `default location` to that list.

Anything that is not in that list is marked for removal from the `default organization` and `default location`.

First, it tries the "easy way," which is to update the template and remove it from all locations and organizations.

If that fails, then it falls back to the "hard way," which is to disassociate it from the `default organization` and
`default location` individually.

It could fail for several reasons, but mostly because:
* it's locked
* the template has a duplicate name

## Scripts

This is a collection of scripts I use to help stand up new servers - which include Satellite servers.

### `getca.sh`

This is a script using sed magic to extract out the certificate chain from an ssl connection. It ignores the first
certificate, which should be the server certificate, and returns the actual CA chain afterwards.
