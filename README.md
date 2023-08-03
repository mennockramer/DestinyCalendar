# DestinyCalendar
An attempt to show all the rotations, events, and other calendar-able things of Destiny.


### TODO/maybe future features:
  - ~~give CalendarEntry `source` enum: `seed` for those automatically seeded, `live` for live API-gathered, `manual` for manually added ones, and then make the seed script only regenerate `seed` ones~~
  - make entry seeding actually grab icons, then use them in calendar view - mouseover gives text? or should text be always displayed? multiple viewing options! turbo frame the calendar, find some way to change views w/o requerying db
  - ~~background image upload/flat colour setting - text auto black/white (difficult for images)~~
    - background \<something\> of the day - fish, gun from vault, random item or image from API?
  - countdown timers to daily+weekly(+season?) reset - line/partial fill of today cell?
  - make prettier
  - autoscroll to current week - may not be needed
  - make use of /Platform/GlobalAlerts endpoint - warning banners for maintenance, perhaps also an API down/game down warning banner
  - more info - LLS slot, Wellspring, Weekly Multipliers (manual entries Friday before, scrape from activity modifiers for live)
  - auth users with Bungie
    - overall entry CRUD stuff locked behind my own/trusted people (rework view to be regular calendar with links and a new entry link in each cell )
    - user-specfic entries? favourites - save display settings
    - LLS highlight with class symbols if not-yet-unlocked exotics available for that class on that day
  - manifest auto-update job - check every day/week? at reset - if fails (API down), try on each following hour
  - big maybe: auto-parse TWIDs/Twitter posts (Mastodon when Bungie) for non-API things  (Iron Banner weeks, bonus rep? )
  - separate initial manifest grabbing on boot from boot process

