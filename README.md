# DestinyCalendar
An attempt to show all the rotations, events, and other calendar-able things of Destiny.


## TODO/maybe future features:
  give CalendarEntry `seeded` boolean: true for those automatically generated, and then make the seed script only regenerate those, leaving manually added ones untouched
  make entry seeding actually grab icons, then use them in calendar view - mouseover gives text? or should text be always displayed? multiple viewing options? 
  countdown timers to daily+weekly(+season?) reset - line/partial fill of today cell?
  make prettier
  autoscroll to current week - may not be needed
  make use of /Platform/GlobalAlertsd endpoint - warning banners for maintenance, perhaps also an API down/game down warning banner
  more info - LLS slot, Wellpsring, etc
  auth users with Bungie
  - overall entry CRUD stuff locked behind my own/trusted people
  - user-specfic entries? favourites
  - LLS highlight with class symbols if not-yet-unlocked exotics available for that class on that day
  manifest auto-update job - check every day/week? at reset - if fails (API down), try on each following hour
  big maybe: auto-parse TWIDs/Twitter posts (Mastodon when Bungie) for non-API things  (Iron Banner weeks, bonus rep? )

