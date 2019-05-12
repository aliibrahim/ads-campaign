### Introduction
This is the Ads Campaign Service that find differences between local and remote campaigns.

### Task background

We publish our jobs to different marketing sources. To keep track of where the particular job is published, we create
`Campaign` entity in database. `Campaigns` are periodically synchronized with 3rd party _Ad Service_.

`Campaign` properties:

- `id`
- `job_id`
- `status`: one of [active, paused, deleted]
- `external_reference`: corresponds to Ad’s ‘reference’
- `ad_description`: text description of an Ad

Due to various types of failures (_Ad Service_ inavailability, errors in campaign details etc.)
local `Campaigns` can fall out of sync with _Ad Service_.
So we need a way to detect discrepancies between local and remote state.

### TODOs Completed
1. Developed a [Service](https://medium.com/selleo/essential-rubyonrails-patterns-part-1-service-objects-1af9f9573ca1)(as in _Service Object_ pattern),
which would get campaigns from external JSON API([example link](https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df)) and detect discrepancies between local and remote state.

### Service output format
The output of the service is as follows:
```
[
  {
    "remote_reference": "1",
    "discrepancies": [
      "status": {
        "remote": "disabled",
        "local": "active"
      },
      "description": {
        "remote": "Rails Engineer",
        "local": "Ruby on Rails Developer"
      }
    ]
  }
]
```
### Some helpful scripts that can be run to setup the local database

Usage
```
$ rake db:create # create the db
$ rake db:migrate # run migrations
$ rake db:drop # delete the db
$ rake db:reset # combination of the upper three
$ rake db:schema # creates a schema file of the current database
$ rake g:migration your_migration # generates a new migration file
```

### To run the test suite

Usage
```
$ APP_ENV=test rake db:create db:migrate
$ APP_ENV=test rspec spec
```


### Local Environment
The configuration of the environment is read from the local `.env` file via `dotenv` gem
