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
User         | User of the application              | Media, Comment
Media        | Media of different kinds             | Comment, Rating, MediaCenter, Artist, User
Artist       | Creators of the media                | Media
Borrowing    | Borrowed media                       | Lender, Media
Lending      | Lended media                         | Borrower, Media
MediaCenter  | Location where media can be obtained | Media

## Media
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
language         | x    | x    | x    |
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
storage-position | x    | x    | x    |
tags             | x    | x    | x    | search tags
for-sale         | x    | x    | x    |
price            | x    | x    | x    |
loanable         | x    | x    | x    |

When implementing Media we can use single table inheritance (STI) to 
differentiate between the different types of media (book, song, film, game).
How to implement STI can be found at [ActiveRecord::Inheritance](http://api.rubyonrails.org/classes/ActiveRecord/Inheritance.html)

## Artist
The artist is looked up when entered eather manually or by scanning a media. If
the artist is not known it is created after double checking whether it exists
with a different name. The lookup of an author looks like this

     http://isbndb.com/api/v2/json/my-api-key/author/regina_obe

## Borrowing and Lending
If a user wants to lend a book she sends a request for that book to lend. The 
owner of the book can accept or dismiss the request. Owner and lender can send
messages on how to hand over the book. If the lender wants to return the book
she sends a respective message.

## Location
The location has an address and media that can be obtained at the location.


