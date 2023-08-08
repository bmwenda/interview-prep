# Common Ruby on Rails Interview Questions

## What happens from the moment a user types a url in the browser to the moment they get back a response?
This is a very open ended question and there is so much you can say for every step involved, enough to write a book. As you can imagine, different people with different levels and types of experience may give answers of varying depth. It really depends on what the recruiter is evaluating for the specific role. Below are a few things worth mentioning but you can go as far as talking about load balancing, proxies, caching (browser and server), CDNs and much more. It's just enough to get the conversation going.

1. **URL parsing**: The browser parses the url to extract information like domain name, protocol, port, path and so on.
2. **DNS resolution**: The browser resolves the IP address of the domain name by checking it's local cache first. If not found, it makes a lookup request to the DNS servers.
3. **TCP/IP connection**: With the IP address known, the browser establishes a TCP (transmission control protocol) connection with the web server.
4. **HTTP request**: The browser sends a HTTP request to the web server with the required method e.g GET and the request headers.
5. **Web server**: The web server receives the request and checks the path the browser requested for. It starts generating content required to render that page. This may involve several steps such as retrieving scripts, styles and images or simply retrieving content from the cache. If dynamic content is needed, this is forwarded to the application server.
6. **Application server**: This handles dynamic content, for example making database queries to retrieve additional information.
7. **Response**: The server creates a HTTP response and sends it to the browser via the TCP connection. The response contains a status code e.g 200, headers and the response body (content).
8. **Browser processing**: The browser receives the response and interprets the headers and content and decides how to render it.
9. **Completing additional resource requests**: The browser may need to make more requests to correctly render all the content. For example some scripts, style sheets and images may be hosted by different servers and need to be retrieved. This process is done the same way as described above in steps 1 - 8.
10. **Page rendering**: When the browser has fetched all the content it needs, it renders the page and the user can interact with it.

This [stack exchange answer](https://superuser.com/a/31691) is worth a look.

## Security
- What are common security vulnerabilities in web applications? - refer to [OWASP top ten](https://owasp.org/Top10/)
- How does rails solve them? - The official documentation at [Securing Rails Applications](https://guides.rubyonrails.org/security.html) is very comprehensive.

## Rails Routing
### Namespace vs scope
#### Namespace
Used to group controllers under one namespace. It prepends resourceful routes with the given namespace and expects the corresponding actions to be under that namespace. Example:

```
namespace :admin do
  resources :invoices
end
```

Generates
|Path/Url|Verb|Path|Contoller#Action|
|--------|----|----|----------------|
|admin_invoices_path|GET|/admin/invoices|admin/invoices#index|
|                   |POST|/admin/invoices|admin/invoices#create|
|new_admin_invoice_path|GET|/admin/invoices/new|admin/invoices#new|
|...|

The invoices path methods and urls are prefixed with `admin` and the controller action implies the namespace `Admin::InvoicesController` which would be under `app/controllers/admin/invoices_controller.rb`.

#### Scope
Scope can do the same but gives us more flexibility to suit our needs, e.g not prefixing the namespace in the url, not using a module and so on. Examples:

##### Adding a namespace to the url but not using a module namespace

```
scope :admin
  resources :invoices
end
```

Generates
|Path/Url|Verb|Path|Contoller#Action|
|--------|----|----|----------------|
|invoices_path|GET|/admin/invoices|invoices#index|
|                   |POST|/admin/invoices|invoices#create|
|new_invoice_path|GET|/admin/invoices/new|invoices#new|
|...|

While the invoices urls have the `admin` prefix, the contoller action does not. This means `InvoicesController` does not have to be under an `Admin::` module. It would remain in `app/controllers/invoices_controller.rb`.

##### module, path and as
**module**

```
  scope module: :admin do
    resources :invoices
  end
```

Generates:
|Path/Url|Verb|Path|Contoller#Action|
|--------|----|----|----------------|
|invoices_path|GET|/invoices|admin/invoices#index|
|                   |POST|/invoices|admin/invoices#create|
|new_invoice_path|GET|/invoices/new|admin/invoices#new|
|...|

This option does not add a prefix to the paths, but defines the module namespace where the controller should be, in this case `Admin::InvoicesController`.

**path**

Allows us to customize the prefix of the URI pattern

```
  scope module: :admin, path: 'payments' do
    resources :invoices
  end
```

Generates:
|Path/Url|Verb|Path|Contoller#Action|
|--------|----|----|----------------|
|invoices_path|GET|/payments/invoices|admin/invoices#index|
|                   |POST|/payments/invoices|admin/invoices#create|
|new_invoice_path|GET|/payments/invoices/new|admin/invoices#new|
|...|

**as**

Allows us to customize the path method names.

```
  scope module: :admin, path: 'payments', as: 'user_generated' do
    resources :invoices
  end
```

Generates:
|Path/Url|Verb|Path|Contoller#Action|
|--------|----|----|----------------|
|user_generated_invoices_path|GET|/payments/invoices|admin/invoices#index|
|                   |POST|/payments/invoices|admin/invoices#create|
new_user_generated_invoice_path|GET|/payments/invoices/new|admin/invoices#new|
|...|

From this, we can infer that `namespace` is a shorthand. We can achieve the same result for `namespace :admin` with:
```
  scope module: :admin, path: 'admin', as: 'admin' do
    resources :invoices
  end
```

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
