# Adapt Content Management System

This is an open sourced version of a CMS system I built and provided access toi when workign as a self-employed consultant around 2011/2012. It has features like:

- Multitenancy, where all data is scoped to a site. Sites can have one or more URLs defined, automatically serving the correct tenant based on the request URL.
- Customizable data types, allowing each site to customize what data they want to put in and get out of the system.
- Ability to customize design, styling and other types of layout within the admin UI for each site.

It's implemented using Ruby on Rails 3 with PostgreSQL as underlying storage.
It also uses Apache Solr to provide site search. As a product, it is fairly
feature complete and was successfully in production for a few years. The code
has however not been touched for over 10 years, and should be viewed through
that lens.

## Running the project locally

The project can be started by running `docker compose up`. The test site should be available at http://test.127.0.0.1.nip.io:3000/, and the admin UI at http://test.127.0.0.1.nip.io:3000/admin with the default login `test@example.com` / `secret`.

Be advised that this is running some rather old software, with old dependencies, that likely have issues both stability-wise and security-wise.
