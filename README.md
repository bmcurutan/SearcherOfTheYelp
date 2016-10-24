# Project 2 - Searcher Of The Yelp

Searcher Of The Yelp is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: 20 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height.
   - [x] Custom cells should have the proper Auto Layout constraints.
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] You can use the default UISwitch for on/off states.
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

The following **optional** features are implemented:

- [x] Search results page
   - [x] Infinite scroll for restaurant results.
   - [x] Implement map view of restaurant results.
- [x] Filter page
   - [ ] Implement a custom switch instead of the default UISwitch.
   - [x] Distance filter should expand as in the real Yelp app
   - [x] Categories should show a subset of the full list with a "See All" row to expand. Category list is [here](http://www.yelp.com/developers/documentation/category_list).
- [x] Implement the restaurant detail page.

The following **additional** features are implemented:

- [x] Customized navigation bar and Filters page cells to better match Yelp mock
- [x] Added loading icon on businesses list page
- [x] Abstracted search settings into a separate model to hide implementation details. There's a singleton which can be later developed to save settings across the app instead of re-entering them every time. Assumptions: Default search term is "Restaurants" (as in the mock), and filters are reset when there's a new search.
- [x] Search action on default search term "Restaurants" if UISearchBar text is cleared.
= [x] Added "No Results Found" cell if there are no businesses returned from the search or filter results.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Better ways to implement the "See All" and dropdown cells (as in distance and sort). It would be cleaner to do it without all these switches and "if" checks.
2. Better ways to implement checkboxes and store data for distance and sort (that isn't similar to storing the switch states), since only one value should be stored (and shown as checked) at a time. 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/WCezSt7.gif' title='Searcher of the Yelp Video Walkthrough' width='' alt='Searcher of the Yelp Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

- I tended to over-complicate things with the UI for this app since I was focusing too much on the details (depth-first implementation instead of breadth-first). In the end, at least as a first iteration, I just implemented the "checkmark" cells using basic UISwitch and omitted the custom UISwitch task for now ("You can use the default UISwitch for on/off states").
- I faced some challenges data storing for distance and sort since only one value per section should be stored at a time. From the UI side, sometimes a checkmark would only show up in one section and disappear from the other upon a selection action.
- I would like to explore better ways to implement the "See All" and dropdown cell actions. For now, there are a bunch of switches and "if" checks that make these actions functional, but it would be a better learning experience to know a cleaner, less hacky way to do this. 

## License

    Copyright 2016 Bianca Curutan.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
