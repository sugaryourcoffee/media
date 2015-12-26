# Media
Media is a web application to organize media like books, music, films, 
magazines and the like. Media provides following functions

* Add media eather by manual input or by scanning
* Make physical media publicly available for borrowing
* Track borrowed physical media
* Mark physical media as available for sales with a price
* Users can add comments to media and rate with stars

# Models
The Media application consists of following objects

Object    | Description                          | Association
--------- | ------------------------------------ | ------------------------
User      | User of the application              | Media, Comments
Media     | Media of differnt kinds              | User, Comments, Location, Artist
Artist    | Creator of the media                 | Media
Borrowing | Borrowed media                       | Borrower, Media
Lending   | Lended media                         | Lender, Media
Location  | Location where media can be obtained | Media

## Media
Media can be collected manually or with a scanner. By entering the ISBN the
media details are looked up in the internet. On source is 
[isbnDB](http://isbndb.com) where we can obtain an api-key and retrieve 
information like

     http://isbndb.com/api/v2/json/my-api-key/book/9781449326333

## Artist
The artist is looked up when entered eather manually or by scanning a media. If
the artist is not known it is created after double checking whether it exists
with a different name.

## Borrowing and Lending
If a user wants to lend a book she sends a request for that book to lend. The 
owner of the book can accept or dismiss the request. Owner and lender can send
messages on how to hand over the book. If the lender wants to return the book
she sends a respective message.

## Location
The location has an address and media that can be obtained at the location.


