# Media
Media is a web application to organize media like books, music, films, 
magazines and the like. Media provides following functions

* Add media eather by manual input or by scanning
* Mark physical media being publicly available for borrowing
* Track borrowed physical media
* Mark physical media as available for sales with a price
* Users can add comments to media and rate with stars
* Make electronic media available only to the owner of the media

# Models
The Media application consists of following objects

Object       | Description                          | Association
------------ | ------------------------------------ | ------------------------
User         | User of the application              | MediaItem, Comment
MediaItem    | Media part of user's media library   | Media
Media        | Media of different kinds             | Comment, Rating, MediaCenter, Artist, MediaItem
Artist       | Creators of the media                | Media
Lending      | Lended media                         | Lender (User), Borrower (User), MediaItem
MediaCenter  | Location where media can be obtained | MediaItem

## Media and MediaItem
Media can be collected manually or with a scanner. By entering the ISBN the
media details are looked up in the internet. On source is 
[isbnDB](http://isbndb.com) where we can obtain an api-key and retrieve 
information like

     http://isbndb.com/api/v2/json/my-api-key/book/9781449326333

The API for ISNBdb can be found at 
[ISBNdb API -- Version 2](http://isbndb.com/api/v2/docs)

A Media can be a book, a song, a film and other media. The table shows the
fields each of these media should have

Field            | Book | Song | Film | Description
---------------- | ---- | ---- | ---- | --------------------------------------
title            | x    | x    | x    | 
subtitle         | x    | x    | x    |
description      | x    | x    | x    |
publisher        | x    | x    | x    |
edition          | x    | x    | x    | paperback, hard cover, CD, DVD, VHS
date-of-issue    | x    | x    | x    |
languages        | x    | x    | x    |
age-rating       | x    | x    | x    | 
ratings          | x    | x    | x    |
comments         | x    | x    | x    |
links            | x    | x    | x    | links to additional media information
vendors          | x    | x    | x    | links to shops where media can be bought
icon-small       | x    | x    | x    |
icon-medium      | x    | x    | x    |
icon-large       | x    | x    | x    |
gengre           | x    | x    | x    |
isxn             | x    | x    | x    | isbn, ismn, vendor specific number
artists          | x    | x    | x    | author, band, singer, director, actor
storage-position | x    | x    | x    | eather physical or link
tags             | x    | x    | x    | search tags

A MediaItem is owened by a User. A MediaItem has a Media. We distinguish between
Media and MediaItem as a Media has User specific properties, e.g. different 
Users may own the same Media but don't necessarily want to lend their Media 
both.

Field            | Book | Song | Film | Description
---------------- | ---- | ---- | ---- | --------------------------------------
user             | x    | x    | x    | owner of the media
media            | x    | x    | x    | the actual media
storage-position | x    | x    | x    | eather physical or link
for-sale         | x    | x    | x    | true when for sale
price            | x    | x    | x    | has a price if it is for sale
lendable         | x    | x    | x    | true when lendable
lendings         | x    | x    | x    | 

When implementing Media we can use single table inheritance (STI) to 
differentiate between the different types of media (book, song, film, game).
How to implement STI can be found at [ActiveRecord::Inheritance](http://api.rubyonrails.org/classes/ActiveRecord/Inheritance.html)

## Artist
The artist is looked up when entered eather manually or by scanning a media. If
the artist is not known it is created after double checking whether it exists
with a different name. The lookup of an author looks like this

     http://isbndb.com/api/v2/json/my-api-key/author/regina_obe

An Artist has different roles dependent on the media.

Artist   | Book | Music | Film | Game
-------- | ---- | ----- | ---- | ----
Author   | x    |       | x    | x 
Director |      |       | x    |
Actor    |      |       | x    |
Composer |      | x     |      |
Singer   |      | x     |      | 
Band     |      | x     |      |

Artist has following attributes

Field       | Description
------------| ----------------------------------------------------------
Name        | 
FirstName   |
Role        | Author, Director, ...
DateOfBirth |
DateOfDeath |
Link        | Link that provides additional information about the author

## Lending
If a user wants to borrow a book she sends a request for that book to borrow. 
The owner of the book can accept or dismiss the request. Lender and borrower can
send messages on how to hand over the book. If the borrower wants to return the 
book she sends a respective message. If a book is not available at the moment a
borrowing request will be added to the book's lendings

Field           | Description
--------------- | -----------------------
Media           |
Lender          | Owner of the media
Borrower        | Borrower of the book
Date of Lending | The date the book was lended
Date of return  | The date the book was returned

## Location
The location has an address and media that can be obtained at the location.

Field           | Description
--------------- | -------------------------------------------
Name            | Name of the location
Street          |
Town            | 
Zip-code        |
Country         |
Link            | Link to the location
Media           | The media that is available at the location

