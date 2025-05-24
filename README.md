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

- **Automatic Installation**: No manual steps required beyond the standard plugin installation procedure
- **Consolidated Audit Logging**: When you change an entity with custom fields (Issues, Projects, TimeEntries, etc.), all changes (including custom field changes) are recorded in a single audit entry
- **Clean Audit Trail**: Prevents duplicate audit entries for custom field changes
- **Efficient Storage**: Uses optimized data types for PostgreSQL databases

How to remove
-------
```
  $ cd /path/to/redmine
  $ rake redmine:plugins:migrate NAME=redmine_auditlog VERSION=0 RAILS_ENV=production
  $ rm -rf plugins/redmine_auditlog
```
Then restart Redmine. This will not remove the `audits` table.


Compatible with:	Redmine 3.4.x, 3.3.x, 3.2.x, 3.1.x, 3.0.x, 4.0.x, 4.1.x, 4.2.x, 5.0.x   
Tested with Redmine 3.4.6, 4.1.1, 4.2.10, 5.0.5

License
-------
Copyright 2018-2025 Alex Stanev <alex@stanev.org>   
This plugin is released under the GPL v3 license. See   
LICENSE for more information.

