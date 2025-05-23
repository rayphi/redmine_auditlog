Redmine Auditlog
-------

Provides full auditlog for user actions in Redmine instance.


How to use
-------
```
  $ cd /path/to/redmine/plugins
  $ git clone https://github.com/RealEnder/redmine_auditlog
  $ cd ../..
  $ rake redmine:plugins:migrate RAILS_ENV="production"
```
Then restart Redmine.

The plugin now includes an automatic migration that handles the `audited:install` generator and database migrations. For PostgreSQL databases, it will automatically use the more efficient `jsonb` storage type for audit changes.

## Features

- Consolidated audit logging for entity changes including their custom fields
- When you change an Issue, Project, TimeEntry or other main entity with custom fields, all changes (including custom field changes) are recorded in a single audit entry
- Prevents duplicate audit entries for custom field changes

How to remove
-------
```
  $ cd /path/to/redmine
  $ rake redmine:plugins:migrate NAME=redmine_auditlog VERSION=0 RAILS_ENV=production
  $ rm -rf plugins/redmine_auditlog
```
Then restart Redmine. This will not remove the `audits` table.


Compatible with:	Redmine 3.4.x, 3.3.x, 3.2.x, 3.1.x, 3.0.x, 4.0.x, 4.1.x , 4.2.x   
Tested with Redmine 3.4.6, 4.1.1, 4.2.10

License
-------
Copyright 2018-2023 Alex Stanev <alex@stanev.org>   
This plugin is released under the GPL v3 license. See   
LICENSE for more information.

