# Common Ruby on Rails Interview Questions

## Observers and callbacks
### Observers
Use the [observer pattern](https://learn.microsoft.com/en-us/dotnet/standard/events/observer-design-pattern) where we have a provider (subject) and one or more observers. The subject/provider notifies its observers when an event happens. In this way, the observers can perform actions that need to be done as an effect of the subject's events. A common use case is sending notifications.

In RoR, observers are defined in `ActiveRecord::Observer`. Below is an example of an observer that sends a notification after a comment is saved.

```
class CommentObserver < ActiveRecord::Observer
  def after_save(comment)
    Notifications.comment("admin@do.com", "New comment was posted", comment).deliver
  end
end
```

Active record infers that `Comment` is the subject. The observer triggers the notifications when an `after_save` action is performed on comment.

See [docs](https://api.rubyonrails.org/v3.2.0/classes/ActiveRecord/Observer.html) for details.

### Callbacks
These are hooks that exist in the life cycle of an Active Record object. Are defined by the [Callbacks module](https://api.rubyonrails.org/v3.2.0/classes/ActiveRecord/Callbacks.html).

### Differences
Callbacks are short lived. They are passed into a function to be called once in an object's lifecycle. They are more like functions.
Observers are not short lived. They live longer and can be detached or attached at any time. Also, there can be many observers for the same thing and they can have different lifetimes.

### Use cases
- Callbacks: Running a thread and giving a callback that is called when the thread terminates.
- Observers:
  -  Showing values from a model in a UI and updating the model from user input.
  -  Decoupling or distribution of responsibility in your codebase. This is useful when you find that callbacks need to call other unrelated services.

## Optimistic locking vs pessimistic locking
Both are models of locking a database to ensure consistency after/during updates.

### Optimistic locking
A record is locked only when changes are committed to the database. Allows multiple users to attempt to update the same record without informing the users that others are also attempting to update the record. The record changes are validated only when the record is committed. If one user successfully updates the record, the other users attempting to commit their concurrent updates are informed that a conflict exists.

Advantages
- Less overhead
- Best when conflicts are expected to be rare

### Pessimistic locking
A record is locked while it is edited thus preventing simultaneous updates to records. As soon as one user starts to update a record, a lock is placed on it. Other users who attempt to update this record are informed that another user has an update in progress.

Advantages
- Better data integrity

Rails allows for both implementations with Active Record.
- [ActiveRecord::Locking::Optimistic ](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html)
  - A `lock_version` column is required for the table and is checked before any update. If lock version is less than current version, an `ActiveRecord::StaleObjectError` is raised.
- [ActiveRecord::Locking::Pessimistic ](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html)
  - uses the locking mechanism provided by the underlying database - e.g MySQL, Postgres
  - should be used in a transaction to avoid deadlocks
